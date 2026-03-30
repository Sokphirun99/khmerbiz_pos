import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khmerbiz_pos/core/network/network_info.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';
import 'package:khmerbiz_pos/domain/entities/payment_status.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/khqr_repository.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_event.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_state.dart';

/// BLoC managing the KHQR and deep-link payment flows.
///
/// Lifecycle:
/// 1. [InitiateKhqrPayment] → generates QR, starts countdown + polling
/// 2. [PollPaymentStatus] (every 3s) → checks Bakong API
/// 3. [CountdownTick] (every 1s) → updates remaining time
/// 4. Terminal states: [PaymentConfirmed], [PaymentTimedOut],
///    [PaymentFailed], [PaymentCancelled]
///
/// For ABA/Wing:
/// 1. [InitiateDeepLinkPayment] → launches banking app
/// 2. [ConfirmManualPayment] → user confirms after returning
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({
    required KhqrRepository khqrRepository,
    required ExchangeRateRepository exchangeRateRepository,
    required NetworkInfo networkInfo,
    MerchantInfo? merchantInfo,
  })  : _khqrRepository = khqrRepository,
        _exchangeRateRepository = exchangeRateRepository,
        _networkInfo = networkInfo,
        _merchantInfo = merchantInfo ?? MerchantInfo.placeholder,
        super(const PaymentInitial()) {
    on<InitiateKhqrPayment>(_onInitiateKhqr);
    on<InitiateDeepLinkPayment>(_onInitiateDeepLink);
    on<PollPaymentStatus>(_onPollStatus);
    on<CountdownTick>(_onCountdownTick);
    on<ConfirmManualPayment>(_onConfirmManual);
    on<CancelPayment>(_onCancel);
    on<RetryPayment>(_onRetry);
  }

  final KhqrRepository _khqrRepository;
  final ExchangeRateRepository _exchangeRateRepository;
  final NetworkInfo _networkInfo;
  final MerchantInfo _merchantInfo;

  /// Polling interval: check payment status every 3 seconds.
  static const _pollInterval = Duration(seconds: 3);

  /// Countdown tick interval: update UI every second.
  static const _tickInterval = Duration(seconds: 1);

  /// Timers for polling and countdown.
  Timer? _pollTimer;
  Timer? _countdownTimer;

  /// Track the current payment context for retry.
  double? _lastAmountKHR;
  String? _lastInvoiceId;
  String? _currentMd5Hash;
  int _pollAttempts = 0;

  // ── InitiateKhqrPayment ─────────────────────────────────────────────────

  Future<void> _onInitiateKhqr(
    InitiateKhqrPayment event,
    Emitter<PaymentState> emit,
  ) async {
    _stopTimers();

    // Store for retry
    _lastAmountKHR = event.amountKHR;
    _lastInvoiceId = event.invoiceId;
    _pollAttempts = 0;

    // Check connectivity first
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(PaymentOffline(
        amountKHR: event.amountKHR,
        invoiceId: event.invoiceId,
      ));
      return;
    }

    emit(const PaymentGenerating());

    // Refresh exchange rate if stale
    if (_exchangeRateRepository.isRateStale()) {
      await _exchangeRateRepository.fetchLatestRate();
    }

    // Generate dynamic QR
    final result = await _khqrRepository.generateDynamicQR(
      amountKHR: event.amountKHR,
      invoiceId: event.invoiceId,
      merchantInfo: _merchantInfo,
    );

    result.fold(
      (failure) {
        emit(PaymentFailed(
          messageEn: failure.messageEn,
          messageKm: failure.messageKm,
        ));
      },
      (khqrData) {
        _currentMd5Hash = khqrData.md5Hash;

        emit(PaymentAwaitingConfirmation(
          khqrData: khqrData,
          remaining: khqrData.remainingDuration,
          pollAttempts: 0,
        ));

        // Start polling timer
        _pollTimer = Timer.periodic(_pollInterval, (_) {
          add(const PollPaymentStatus());
        });

        // Start countdown timer
        _countdownTimer = Timer.periodic(_tickInterval, (_) {
          final remaining = khqrData.expiresAt.difference(DateTime.now());
          add(CountdownTick(
            remaining: remaining.isNegative ? Duration.zero : remaining,
          ));
        });
      },
    );
  }

  // ── PollPaymentStatus ───────────────────────────────────────────────────

  Future<void> _onPollStatus(
    PollPaymentStatus event,
    Emitter<PaymentState> emit,
  ) async {
    final md5 = _currentMd5Hash;
    if (md5 == null) return;

    _pollAttempts++;

    final result = await _khqrRepository.checkPaymentStatus(md5);

    result.fold(
      (failure) {
        // Don't stop polling on transient errors — keep trying
        // until timeout. Only emit failure on terminal errors.
      },
      (status) {
        switch (status) {
          case PaymentPending():
            // Update poll count in current state
            final currentState = state;
            if (currentState is PaymentAwaitingConfirmation) {
              emit(PaymentAwaitingConfirmation(
                khqrData: currentState.khqrData,
                remaining: currentState.remaining,
                pollAttempts: _pollAttempts,
              ));
            }

          case PaymentConfirmedStatus(:final reference, :final amount):
            _stopTimers();
            final exchangeRate = _exchangeRateRepository.getCachedRate();
            emit(PaymentConfirmed(
              reference: reference,
              amountKHR: amount,
              amountUSD: double.parse(
                  (amount / exchangeRate).toStringAsFixed(2)),
              md5Hash: md5,
            ));

          case PaymentExpired():
            _stopTimers();
            emit(PaymentTimedOut(
              amountKHR: _lastAmountKHR ?? 0,
              invoiceId: _lastInvoiceId ?? '',
            ));

          case PaymentFailedStatus(:final reason):
            _stopTimers();
            emit(PaymentFailed(
              messageEn: 'Payment failed: $reason',
              messageKm: 'ការទូទាត់បរាជ័យ៖ $reason',
            ));
        }
      },
    );
  }

  // ── CountdownTick ───────────────────────────────────────────────────────

  void _onCountdownTick(
    CountdownTick event,
    Emitter<PaymentState> emit,
  ) {
    if (event.remaining == Duration.zero) {
      _stopTimers();
      emit(PaymentTimedOut(
        amountKHR: _lastAmountKHR ?? 0,
        invoiceId: _lastInvoiceId ?? '',
      ));
      return;
    }

    final currentState = state;
    if (currentState is PaymentAwaitingConfirmation) {
      emit(PaymentAwaitingConfirmation(
        khqrData: currentState.khqrData,
        remaining: event.remaining,
        pollAttempts: currentState.pollAttempts,
      ));
    }
  }

  // ── InitiateDeepLinkPayment ─────────────────────────────────────────────

  Future<void> _onInitiateDeepLink(
    InitiateDeepLinkPayment event,
    Emitter<PaymentState> emit,
  ) async {
    _stopTimers();

    _lastAmountKHR = event.amountKHR;
    _lastInvoiceId = event.invoiceId;

    // Deep link launching is handled by the UI layer via url_launcher.
    // The bloc just transitions to the "launched" state.
    emit(PaymentDeepLinkLaunched(
      method: event.method,
      amountKHR: event.amountKHR,
      invoiceId: event.invoiceId,
    ));
  }

  // ── ConfirmManualPayment ────────────────────────────────────────────────

  void _onConfirmManual(
    ConfirmManualPayment event,
    Emitter<PaymentState> emit,
  ) {
    _stopTimers();
    final exchangeRate = _exchangeRateRepository.getCachedRate();
    final amount = _lastAmountKHR ?? 0;

    emit(PaymentConfirmed(
      reference: event.reference,
      amountKHR: amount,
      amountUSD: double.parse((amount / exchangeRate).toStringAsFixed(2)),
      md5Hash: '',
    ));
  }

  // ── CancelPayment ──────────────────────────────────────────────────────

  void _onCancel(
    CancelPayment event,
    Emitter<PaymentState> emit,
  ) {
    _stopTimers();
    emit(const PaymentCancelled());
  }

  // ── RetryPayment ───────────────────────────────────────────────────────

  Future<void> _onRetry(
    RetryPayment event,
    Emitter<PaymentState> emit,
  ) async {
    final amount = _lastAmountKHR;
    final invoice = _lastInvoiceId;

    if (amount == null || invoice == null) {
      emit(const PaymentFailed(
        messageEn: 'Cannot retry — missing payment context.',
        messageKm: 'មិនអាចព្យាយាមម្ដងទៀត — បាត់បង់ព័ត៌មានការទូទាត់។',
      ));
      return;
    }

    add(InitiateKhqrPayment(amountKHR: amount, invoiceId: invoice));
  }

  // ── Timer Management ───────────────────────────────────────────────────

  void _stopTimers() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _currentMd5Hash = null;
  }

  @override
  Future<void> close() {
    _stopTimers();
    return super.close();
  }
}
