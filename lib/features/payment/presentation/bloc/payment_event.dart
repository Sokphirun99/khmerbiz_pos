import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';

/// Events for the PaymentBloc.
sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Initiate a KHQR payment flow.
///
/// Generates a dynamic QR code and starts the 5-minute countdown
/// with 3-second polling interval.
final class InitiateKhqrPayment extends PaymentEvent {
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

/// Initiate an ABA or Wing deep link payment.
///
/// Opens the banking app with pre-filled payment details.
final class InitiateDeepLinkPayment extends PaymentEvent {
  const InitiateDeepLinkPayment({
    required this.method,
    required this.amountKHR,
    required this.invoiceId,
  });

  /// Payment method (must be [PaymentMethod.aba] or [PaymentMethod.wing]).
  final PaymentMethod method;

  /// Total amount in KHR.
  final double amountKHR;

  /// Invoice/receipt ID.
  final String invoiceId;

  @override
  List<Object?> get props => [method, amountKHR, invoiceId];
}

/// Internal event: poll the Bakong API for payment confirmation.
///
/// Fired by the periodic timer every 3 seconds.
final class PollPaymentStatus extends PaymentEvent {
  const PollPaymentStatus();
}

/// User manually confirms payment (for deep link flows where
/// automatic confirmation is not available).
final class ConfirmManualPayment extends PaymentEvent {
  const ConfirmManualPayment({
    required this.reference,
  });

  /// User-provided or auto-detected reference number.
  final String reference;

  @override
  List<Object?> get props => [reference];
}

/// User cancelled the payment flow.
final class CancelPayment extends PaymentEvent {
  const CancelPayment();
}

/// Retry after a timeout or failure.
///
/// Re-generates the QR code and restarts polling.
final class RetryPayment extends PaymentEvent {
  const RetryPayment();
}

/// Internal event: countdown tick (fired every second).
final class CountdownTick extends PaymentEvent {
  const CountdownTick({required this.remaining});

  /// Remaining duration until QR expiry.
  final Duration remaining;

  @override
  List<Object?> get props => [remaining];
}
