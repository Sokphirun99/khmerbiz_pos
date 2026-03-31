import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/core/network/network_info.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';
import 'package:khmerbiz_pos/domain/entities/payment_status.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/khqr_repository.dart';
import 'package:khmerbiz_pos/features/payment/data/deep_link_helper.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_event.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_state.dart';

/// BLoC managing the KHQR and deep-link payment flows.
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  /// Creates a [PaymentBloc] with required services.
  PaymentBloc({
    required KhqrRepository khqrRepository,
    required ExchangeRateRepository exchangeRateRepository,
    required NetworkInfo networkInfo,
    required DeepLinkHelper deepLinkHelper,
    MerchantInfo? merchantInfo,
  })  : _khqrRepository = khqrRepository,
        _exchangeRateRepository = exchangeRateRepository,
        _networkInfo = networkInfo,
        _deepLinkHelper = deepLinkHelper,
        _merchantInfo = merchantInfo ?? MerchantInfo.placeholder,
        super(const PaymentIdle()) {
    on<InitiateKhqrPayment>(_onInitiateKhqr);
    on<PollKhqrStatus>(_onPollStatus);
    on<KhqrPaymentConfirmed>(_onPaymentConfirmed);
    on<KhqrPaymentTimeout>(_onPaymentTimeout);
    on<InitiateAbaDeepLink>(_onInitiateAba);
    on<InitiateWingDeepLink>(_onInitiateWing);
    on<MarkManualPayment>(_onMarkManual);
    on<CancelPayment>(_onCancel);
    on<RetryPayment>(_onRetry);
    on<CountdownTick>(_onCountdownTick);
  }

  final KhqrRepository _khqrRepository;
  final ExchangeRateRepository _exchangeRateRepository;
  final NetworkInfo _networkInfo;
  final DeepLinkHelper _deepLinkHelper;
  final MerchantInfo _merchantInfo;

  static const _pollInterval = Duration(seconds: 3);
  static const _maxPollAttempts = 100;

  Timer? _pollTimer;
  Timer? _countdownTimer;

  double? _lastAmountKHR;
  String? _lastInvoiceId;

  // ── InitiateKhqrPayment ─────────────────────────────────────────────────

  Future<void> _onInitiateKhqr(
    InitiateKhqrPayment event,
    Emitter<PaymentState> emit,
  ) async {
    _stopTimers();
    _lastAmountKHR = event.amountKHR;
    _lastInvoiceId = event.invoiceId;

    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      emit(const PaymentFailed(failure: NetworkFailure(
        messageEn: 'Network connection required for KHQR.',
        messageKm: 'ត្រូវការការតភ្ជាប់បណ្តាញសម្រាប់ KHQR។',
      ),),);
      return;
    }

    emit(const KhqrGenerating());

    final result = await _khqrRepository.generateDynamicQR(
      amountKHR: event.amountKHR,
      invoiceId: event.invoiceId,
      merchantInfo: _merchantInfo,
    );

    result.fold(
      (failure) => emit(PaymentFailed(failure: failure)),
      (khqrData) {
        emit(KhqrReady(
          qrString: khqrData.qrString,
          md5Hash: khqrData.md5Hash,
          amountKHR: khqrData.amountKHR,
          amountUSD: khqrData.amountUSD,
          invoiceId: khqrData.invoiceId,
          expiresAt: khqrData.expiresAt,
          pollAttempt: 0,
          remaining: khqrData.remainingDuration,
        ),);

        _startTimers(khqrData.md5Hash);
      },
    );
  }

  // ── Polling ─────────────────────────────────────────────────────────────

  Future<void> _onPollStatus(
    PollKhqrStatus event,
    Emitter<PaymentState> emit,
  ) async {
    if (event.attemptNumber >= _maxPollAttempts) {
      add(const KhqrPaymentTimeout());
      return;
    }

    final result = await _khqrRepository.checkPaymentStatus(event.md5Hash);

    result.fold(
      (_) => null,
      (status) {
        switch (status) {
          case PaymentPending():
            final currentState = state;
            if (currentState is KhqrReady) {
              emit(KhqrReady(
                qrString: currentState.qrString,
                md5Hash: currentState.md5Hash,
                amountKHR: currentState.amountKHR,
                amountUSD: currentState.amountUSD,
                invoiceId: currentState.invoiceId,
                expiresAt: currentState.expiresAt,
                pollAttempt: event.attemptNumber,
                remaining: currentState.remaining,
              ),);
            }
          case PaymentConfirmedStatus(:final reference):
            add(KhqrPaymentConfirmed(reference: reference));
          case PaymentExpired():
            add(const KhqrPaymentTimeout());
          case PaymentFailedStatus(:final reason):
            _stopTimers();
            emit(PaymentFailed(
              failure: PaymentFailure(
                messageEn: 'Payment failed: $reason',
                messageKm: 'ការទូទាត់បរាជ័យ៖ $reason',
              ),
            ),);
        }
      },
    );
  }

  // ── Terminal States ─────────────────────────────────────────────────────

  void _onPaymentConfirmed(
    KhqrPaymentConfirmed event,
    Emitter<PaymentState> emit,
  ) {
    _stopTimers();
    emit(PaymentConfirmed(
      method: PaymentMethod.khqr,
      reference: event.reference,
      amountKHR: _lastAmountKHR ?? 0,
    ),);
  }

  void _onPaymentTimeout(
    KhqrPaymentTimeout event,
    Emitter<PaymentState> emit,
  ) {
    _stopTimers();
    emit(const PaymentTimeout());
  }

  // ── Deep Links ──────────────────────────────────────────────────────────

  Future<void> _onInitiateAba(
    InitiateAbaDeepLink event,
    Emitter<PaymentState> emit,
  ) async {
    _stopTimers();
    _lastAmountKHR = event.amountKHR;

    final success = await _deepLinkHelper.launchAbaPay(
      amount: event.amountKHR,
      invoiceId: event.invoiceId,
      merchantId: _merchantInfo.merchantId,
    );

    if (success) {
      emit(const ExternalAppLaunched(method: PaymentMethod.aba));
    } else {
      emit(const PaymentFailed(failure: PaymentFailure(
        messageEn: 'Could not launch ABA app.',
        messageKm: 'មិនអាចបើកកម្មវិធី ABA បានទេ។',
      ),),);
    }
  }

  Future<void> _onInitiateWing(
    InitiateWingDeepLink event,
    Emitter<PaymentState> emit,
  ) async {
    _stopTimers();
    _lastAmountKHR = event.amountKHR;

    final success = await _deepLinkHelper.launchWingMoney(
      amount: event.amountKHR,
      invoiceId: event.invoiceId,
      merchantPhone: _merchantInfo.accountId,
    );

    if (success) {
      emit(const ExternalAppLaunched(method: PaymentMethod.wing));
    } else {
      emit(const PaymentFailed(failure: PaymentFailure(
        messageEn: 'Could not launch Wing app.',
        messageKm: 'មិនអាចបើកកម្មវិធី Wing បានទេ។',
      ),),);
    }
  }

  // ── Manual Payment ──────────────────────────────────────────────────────

  void _onMarkManual(
    MarkManualPayment event,
    Emitter<PaymentState> emit,
  ) {
    _stopTimers();
    emit(PaymentConfirmed(
      method: event.method,
      reference: event.notes,
      amountKHR: _lastAmountKHR ?? 0,
    ),);
  }

  // ── Utils ──────────────────────────────────────────────────────────────

  void _onCancel(CancelPayment event, Emitter<PaymentState> emit) {
    _stopTimers();
    emit(const PaymentCancelled());
  }

  void _onRetry(RetryPayment event, Emitter<PaymentState> emit) {
    if (_lastAmountKHR != null && _lastInvoiceId != null) {
      add(InitiateKhqrPayment(
        amountKHR: _lastAmountKHR!,
        invoiceId: _lastInvoiceId!,
      ),);
    }
  }

  void _onCountdownTick(CountdownTick event, Emitter<PaymentState> emit) {
    final currentState = state;
    if (currentState is KhqrReady) {
      emit(KhqrReady(
          qrString: currentState.qrString,
          md5Hash: currentState.md5Hash,
          amountKHR: currentState.amountKHR,
          amountUSD: currentState.amountUSD,
          invoiceId: currentState.invoiceId,
          expiresAt: currentState.expiresAt,
          pollAttempt: currentState.pollAttempt,
          remaining: event.remaining,
      ),);
    }
  }

  void _startTimers(String md5Hash) {
    int attempts = 0;
    _pollTimer = Timer.periodic(_pollInterval, (_) {
      attempts++;
      add(PollKhqrStatus(md5Hash: md5Hash, attemptNumber: attempts));
    });

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final currentState = state;
      if (currentState is KhqrReady) {
        final remaining = currentState.expiresAt.difference(DateTime.now());
        add(CountdownTick(remaining: remaining));
      }
    });
  }

  void _stopTimers() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _countdownTimer?.cancel();
    _countdownTimer = null;
  }

  @override
  Future<void> close() {
    _stopTimers();
    return super.close();
  }
}
