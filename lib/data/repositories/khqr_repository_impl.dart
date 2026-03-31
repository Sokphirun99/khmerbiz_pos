import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:fpdart/fpdart.dart';

import 'package:khmerbiz_pos/core/config/constants.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/core/network/network_info.dart';
import 'package:khmerbiz_pos/domain/entities/khqr_data.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';
import 'package:khmerbiz_pos/domain/entities/payment_status.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/khqr_repository.dart';

/// KHQR Repository implementation.
///
/// Handles dynamic and static KHQR generation and payment status polling.
/// Currently uses a simulation layer that generates valid-looking KHQR
/// payloads and simulates payment confirmation after a configurable delay.
///
/// To switch to real Bakong SDK:
/// 1. Add `flutter_bakong_khqr` to pubspec.yaml
/// 2. Replace [_generateSimulatedQR] with SDK call
/// 3. Replace [_simulatePaymentStatus] with real Bakong API polling
class KhqrRepositoryImpl implements KhqrRepository {
  /// Creates a new [KhqrRepositoryImpl] with required dependencies.
  ///
  /// [networkInfo] is used for connectivity checks.
  /// [exchangeRateRepository] is used for KHR to USD conversion.
  /// [simulateConfirmationAfter] sets the mock polling threshold.
  KhqrRepositoryImpl({
    required NetworkInfo networkInfo,
    required ExchangeRateRepository exchangeRateRepository,
    this.simulateConfirmationAfter = 5,
  })  : _networkInfo = networkInfo,
        _exchangeRateRepository = exchangeRateRepository;

  final NetworkInfo _networkInfo;
  final ExchangeRateRepository _exchangeRateRepository;

  /// Number of poll attempts after which simulation confirms payment.
  /// Set to 0 to disable auto-confirmation in simulation mode.
  final int simulateConfirmationAfter;

  /// Track poll counts per md5Hash for simulation.
  final Map<String, int> _pollCounts = {};

  /// Track generated QR data for simulation reference.
  final Map<String, KhqrData> _generatedQRs = {};

  // ── KHQR Expiry ─────────────────────────────────────────────────────────

  /// KHQR codes expire after 5 minutes.
  static const _qrExpiryDuration = Duration(minutes: 5);

  // ── generateDynamicQR ───────────────────────────────────────────────────

  @override
  Future<Either<Failure, KhqrData>> generateDynamicQR({
    required double amountKHR,
    required String invoiceId,
    required MerchantInfo merchantInfo,
  }) async {
    try {
      // Validate network connectivity
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        return left(const PaymentFailure(
          messageEn: 'Internet connection required to generate KHQR.',
          messageKm: 'ត្រូវការការតភ្ជាប់អ៊ីនធឺណិតដើម្បីបង្កើត KHQR។',
        ),);
      }

      // Validate amount
      if (amountKHR <= 0) {
        return left(ValidationFailure.custom(
          messageEn: 'Amount must be greater than 0.',
          messageKm: 'ចំនួនទឹកប្រាក់ត្រូវតែធំជាង 0។',
        ),);
      }

      // Convert to USD using current exchange rate
      final exchangeRate = _exchangeRateRepository.getCachedRate();
      final amountUSD = amountKHR / exchangeRate;

      // Generate QR payload (simulation)
      final now = DateTime.now();
      final qrString = _generateSimulatedQR(
        amountKHR: amountKHR,
        invoiceId: invoiceId,
        merchantInfo: merchantInfo,
      );

      // Generate MD5 hash for polling
      final md5Hash = md5
          .convert(utf8.encode('$invoiceId-${now.millisecondsSinceEpoch}'))
          .toString();

      final khqrData = KhqrData(
        qrString: qrString,
        md5Hash: md5Hash,
        amountKHR: amountKHR,
        amountUSD: double.parse(amountUSD.toStringAsFixed(2)),
        invoiceId: invoiceId,
        generatedAt: now,
        expiresAt: now.add(_qrExpiryDuration),
      );

      // Store for simulation reference
      _generatedQRs[md5Hash] = khqrData;
      _pollCounts[md5Hash] = 0;

      return right(khqrData);
    } catch (e) {
      return left(PaymentFailure(
        messageEn: 'Failed to generate KHQR code.',
        messageKm: 'បរាជ័យក្នុងការបង្កើតកូដ KHQR។',
        details: e.toString(),
      ),);
    }
  }

  // ── checkPaymentStatus ──────────────────────────────────────────────────

  @override
  Future<Either<Failure, PaymentStatus>> checkPaymentStatus(
      String md5Hash,) async {
    try {
      final isConnected = await _networkInfo.isConnected;
      if (!isConnected) {
        // On network error during polling, return Pending so polling continues.
        // The user may have temporary connectivity loss.
        return right(const PaymentPending());
      }

      // Check if QR has expired
      final qrData = _generatedQRs[md5Hash];
      if (qrData != null && qrData.isExpired) {
        _cleanup(md5Hash);
        return right(const PaymentExpired());
      }

      // Simulation: confirm after N poll attempts
      return right(_simulatePaymentStatus(md5Hash));
    } catch (e) {
      return left(PaymentFailure(
        messageEn: 'Failed to check payment status.',
        messageKm: 'បរាជ័យក្នុងការពិនិត្យស្ថានភាពការទូទាត់។',
        details: e.toString(),
      ),);
    }
  }

  // ── generateStaticQR ────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> generateStaticQR(
      MerchantInfo merchantInfo,) async {
    try {
      // Static QR does not require network (can be generated offline)
      final qrString = _generateStaticQRPayload(merchantInfo);
      return right(qrString);
    } catch (e) {
      return left(PaymentFailure(
        messageEn: 'Failed to generate static KHQR.',
        messageKm: 'បរាជ័យក្នុងការបង្កើត KHQR ថេរ។',
        details: e.toString(),
      ),);
    }
  }

  // ── Simulation Helpers ──────────────────────────────────────────────────

  /// Generate a simulated EMVCo-like KHQR payload string.
  ///
  /// In production, replace with:
  /// ```dart
  /// final result = BakongKHQR.generateMerchant(
  ///   bakongAccountId: merchantInfo.accountId,
  ///   merchantName: merchantInfo.merchantName,
  ///   merchantCity: merchantInfo.merchantCity,
  ///   amount: amountKHR,
  ///   currency: KHQRCurrency.khr,
  ///   billNumber: invoiceId,
  ///   mcc: merchantInfo.merchantCategoryCode,
  /// );
  /// return result.data.qr;
  /// ```
  String _generateSimulatedQR({
    required double amountKHR,
    required String invoiceId,
    required MerchantInfo merchantInfo,
  }) {
    // Build a simplified EMVCo TLV-like string for simulation.
    // Real KHQR follows EMVCo QR Code Specification for Payment Systems.
    final buffer = StringBuffer()
      ..write('000201') // Payload Format Indicator
      ..write('010212') // Point of Initiation (dynamic)
      ..write('29') // Merchant Account (tag 29)
      ..write('0016${merchantInfo.accountId}')
      ..write('52${merchantInfo.merchantCategoryCode.padLeft(4, '0')}')
      ..write('5303${AppConstants.khqrCurrencyCode}')
      ..write('54${amountKHR.toStringAsFixed(0).padLeft(8, '0')}')
      ..write('58${AppConstants.khqrCountryCode}')
      ..write('59${merchantInfo.merchantName}')
      ..write('60${merchantInfo.merchantCity}')
      ..write('62$invoiceId')
      ..write('6304'); // CRC placeholder

    // Append a simulated CRC
    final crc = md5
        .convert(utf8.encode(buffer.toString()))
        .toString()
        .substring(0, 4)
        .toUpperCase();
    buffer.write(crc);

    return buffer.toString();
  }

  /// Generate a static QR payload (no amount).
  String _generateStaticQRPayload(MerchantInfo merchantInfo) {
    final buffer = StringBuffer()
      ..write('000201') // Payload Format Indicator
      ..write('010211') // Point of Initiation (static)
      ..write('29')
      ..write('0016${merchantInfo.accountId}')
      ..write('52${merchantInfo.merchantCategoryCode.padLeft(4, '0')}')
      ..write('5303${AppConstants.khqrCurrencyCode}')
      ..write('58${AppConstants.khqrCountryCode}')
      ..write('59${merchantInfo.merchantName}')
      ..write('60${merchantInfo.merchantCity}')
      ..write('6304');

    final crc = md5
        .convert(utf8.encode(buffer.toString()))
        .toString()
        .substring(0, 4)
        .toUpperCase();
    buffer.write(crc);

    return buffer.toString();
  }

  /// Simulate payment status based on poll count.
  ///
  /// After [simulateConfirmationAfter] polls, returns confirmed.
  /// This allows testing the full polling → confirmation flow.
  PaymentStatus _simulatePaymentStatus(String md5Hash) {
    final count = (_pollCounts[md5Hash] ?? 0) + 1;
    _pollCounts[md5Hash] = count;

    if (simulateConfirmationAfter > 0 &&
        count >= simulateConfirmationAfter) {
      final qrData = _generatedQRs[md5Hash];
      _cleanup(md5Hash);
      return PaymentConfirmedStatus(
        reference: 'SIM-${DateTime.now().millisecondsSinceEpoch}',
        amount: qrData?.amountKHR ?? 0,
      );
    }

    return const PaymentPending();
  }

  /// Clean up tracking data for a completed/expired QR.
  void _cleanup(String md5Hash) {
    _pollCounts.remove(md5Hash);
    _generatedQRs.remove(md5Hash);
  }
}
