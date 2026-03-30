import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/khqr_data.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';
import 'package:khmerbiz_pos/domain/entities/payment_status.dart';

/// Repository interface for KHQR payment operations.
///
/// Wraps the Bakong KHQR SDK for generating QR codes and polling
/// payment status. Implementations may use `flutter_bakong_khqr`
/// or a simulation layer for development.
abstract class KhqrRepository {
  /// Generate a dynamic KHQR code for a specific transaction.
  ///
  /// Dynamic QR includes the exact [amountKHR] and [invoiceId],
  /// making it unique per transaction.
  Future<Either<Failure, KhqrData>> generateDynamicQR({
    required double amountKHR,
    required String invoiceId,
    required MerchantInfo merchantInfo,
  });

  /// Check the payment status for a previously generated KHQR.
  ///
  /// Uses the [md5Hash] returned from [generateDynamicQR] to poll
  /// the Bakong API for confirmation.
  Future<Either<Failure, PaymentStatus>> checkPaymentStatus(String md5Hash);

  /// Generate a static KHQR code for the merchant.
  ///
  /// Static QR does not include an amount — the customer enters
  /// the amount in their banking app. Useful for printed QR codes.
  Future<Either<Failure, String>> generateStaticQR(
      MerchantInfo merchantInfo);
}
