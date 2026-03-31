import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';

/// Events for the PaymentBloc.
sealed class PaymentEvent extends Equatable {
  /// Base constructor for all [PaymentEvent]s.
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Initiate a KHQR payment flow.
///
/// Generates a dynamic QR code and starts the 5-minute countdown
/// with 3-second polling interval.
final class InitiateKhqrPayment extends PaymentEvent {
  /// Creates an [InitiateKhqrPayment] event.
  const InitiateKhqrPayment({
    required this.amountKHR,
    required this.invoiceId,
  });

  /// Total amount in KHR to be paid.
  final double amountKHR;

  /// Invoice/receipt ID for this transaction.
  final String invoiceId;

  @override
  List<Object?> get props => [amountKHR, invoiceId];
}

/// Internal event: poll the Bakong API for payment confirmation.
///
/// Fired by the periodic timer every 3 seconds.
final class PollKhqrStatus extends PaymentEvent {
  /// Creates a [PollKhqrStatus] event.
  const PollKhqrStatus({
    required this.md5Hash,
    required this.attemptNumber,
  });

  /// MD5 hash for status lookup.
  final String md5Hash;

  /// Current polling attempt index.
  final int attemptNumber;

  @override
  List<Object?> get props => [md5Hash, attemptNumber];
}

/// Payment has been confirmed by the bank.
final class KhqrPaymentConfirmed extends PaymentEvent {
  /// Creates a [KhqrPaymentConfirmed] event.
  const KhqrPaymentConfirmed({required this.reference});

  /// Bank reference number.
  final String reference;

  @override
  List<Object?> get props => [reference];
}

/// Payment window has elapsed.
final class KhqrPaymentTimeout extends PaymentEvent {
  /// Creates a [KhqrPaymentTimeout] event.
  const KhqrPaymentTimeout();
}

/// Initiate an ABA PAY deep link payment.
final class InitiateAbaDeepLink extends PaymentEvent {
  /// Creates an [InitiateAbaDeepLink] event.
  const InitiateAbaDeepLink({
    required this.amountKHR,
    required this.invoiceId,
  });

  /// Total amount in KHR.
  final double amountKHR;

  /// Invoice/receipt ID.
  final String invoiceId;

  @override
  List<Object?> get props => [amountKHR, invoiceId];
}

/// Initiate a Wing Money deep link payment.
final class InitiateWingDeepLink extends PaymentEvent {
  /// Creates an [InitiateWingDeepLink] event.
  const InitiateWingDeepLink({
    required this.amountKHR,
    required this.invoiceId,
  });

  /// Total amount in KHR.
  final double amountKHR;

  /// Invoice/receipt ID.
  final String invoiceId;

  @override
  List<Object?> get props => [amountKHR, invoiceId];
}

/// User manually records the payment (e.g., when offline).
final class MarkManualPayment extends PaymentEvent {
  /// Creates a [MarkManualPayment] event.
  const MarkManualPayment({
    required this.method,
    required this.notes,
  });

  /// Payment method used.
  final PaymentMethod method;

  /// Optional notes for the transaction.
  final String notes;

  @override
  List<Object?> get props => [method, notes];
}

/// User cancelled the payment flow.
final class CancelPayment extends PaymentEvent {
  /// Creates a [CancelPayment] event.
  const CancelPayment();
}

/// Retry after a timeout or failure.
final class RetryPayment extends PaymentEvent {
  /// Creates a [RetryPayment] event.
  const RetryPayment();
}

/// Internal event: countdown tick (fired every second).
final class CountdownTick extends PaymentEvent {
  /// Creates a [CountdownTick] event.
  const CountdownTick({required this.remaining});

  /// Remaining duration until QR expiry.
  final Duration remaining;

  @override
  List<Object?> get props => [remaining];
}
