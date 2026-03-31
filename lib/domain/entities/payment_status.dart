import 'package:equatable/equatable.dart';

/// Status of a KHQR payment as returned by the Bakong polling API.
sealed class PaymentStatus extends Equatable {
  /// Base constructor for [PaymentStatus].
  const PaymentStatus();

  @override
  List<Object?> get props => [];
}

/// Payment is still pending — customer has not yet scanned/paid.
final class PaymentPending extends PaymentStatus {
  /// Creates a [PaymentPending] status.
  const PaymentPending();
}

/// Payment has been confirmed by the bank.
final class PaymentConfirmedStatus extends PaymentStatus {
  /// Creates a [PaymentConfirmedStatus].
  const PaymentConfirmedStatus({
    required this.reference,
    required this.amount,
  });

  /// Bank reference/transaction ID.
  final String reference;

  /// Confirmed amount in the currency of the KHQR.
  final double amount;

  @override
  List<Object?> get props => [reference, amount];
}

/// The KHQR code has expired (past 5-minute window).
final class PaymentExpired extends PaymentStatus {
  /// Creates a [PaymentExpired] status.
  const PaymentExpired();
}

/// Payment failed with a reason from the bank.
final class PaymentFailedStatus extends PaymentStatus {
  /// Creates a [PaymentFailedStatus].
  const PaymentFailedStatus({required this.reason});

  /// The reason for failure (e.g., "Insuficient balance", "User cancelled").
  final String reason;

  @override
  List<Object?> get props => [reason];
}
