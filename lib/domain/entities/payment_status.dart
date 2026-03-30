import 'package:equatable/equatable.dart';

/// Status of a KHQR payment as returned by the Bakong polling API.
sealed class PaymentStatus extends Equatable {
  const PaymentStatus();

  @override
  List<Object?> get props => [];
}

/// Payment is still pending — customer has not yet scanned/paid.
final class PaymentPending extends PaymentStatus {
  const PaymentPending();
}

/// Payment has been confirmed by the bank.
final class PaymentConfirmedStatus extends PaymentStatus {
  const PaymentConfirmedStatus({
    required this.reference,
    required this.amount,
  });

  /// Bank reference/transaction ID.
  final String reference;

  /// Confirmed amount.
  final double amount;

  @override
  List<Object?> get props => [reference, amount];
}

/// The KHQR code has expired (past 5-minute window).
final class PaymentExpired extends PaymentStatus {
  const PaymentExpired();
}

/// Payment failed with a reason from the bank.
final class PaymentFailedStatus extends PaymentStatus {
  const PaymentFailedStatus({required this.reason});

  final String reason;

  @override
  List<Object?> get props => [reason];
}
