import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/khqr_data.dart';

/// States for the PaymentBloc.
sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no payment flow active.
final class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Generating the KHQR code (network call in progress).
final class PaymentGenerating extends PaymentState {
  const PaymentGenerating();
}

/// QR code is displayed and polling is active.
///
/// This is the main "waiting for payment" state.
final class PaymentAwaitingConfirmation extends PaymentState {
  const PaymentAwaitingConfirmation({
    required this.khqrData,
    required this.remaining,
    required this.pollAttempts,
  });

  /// Generated KHQR data including QR string and MD5.
  final KhqrData khqrData;

  /// Time remaining until QR expiry.
  final Duration remaining;

  /// Number of poll attempts so far.
  final int pollAttempts;

  /// Formatted remaining time as "M:SS".
  String get remainingFormatted {
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [khqrData, remaining, pollAttempts];
}

/// Payment has been confirmed by the bank.
final class PaymentConfirmed extends PaymentState {
  const PaymentConfirmed({
    required this.reference,
    required this.amountKHR,
    required this.amountUSD,
    required this.md5Hash,
  });

  /// Bank reference/transaction ID.
  final String reference;

  /// Confirmed amount in KHR.
  final double amountKHR;

  /// Confirmed amount in USD.
  final double amountUSD;

  /// MD5 hash for the confirmed KHQR.
  final String md5Hash;

  @override
  List<Object?> get props => [reference, amountKHR, amountUSD, md5Hash];
}

/// KHQR code has expired (5-minute window elapsed).
final class PaymentTimedOut extends PaymentState {
  const PaymentTimedOut({
    required this.amountKHR,
    required this.invoiceId,
  });

  /// Original amount for retry.
  final double amountKHR;

  /// Original invoice ID for retry.
  final String invoiceId;

  @override
  List<Object?> get props => [amountKHR, invoiceId];
}

/// Payment failed with an error.
final class PaymentFailed extends PaymentState {
  const PaymentFailed({
    required this.messageEn,
    required this.messageKm,
  });

  final String messageEn;
  final String messageKm;

  @override
  List<Object?> get props => [messageEn, messageKm];
}

/// User cancelled the payment flow.
final class PaymentCancelled extends PaymentState {
  const PaymentCancelled();
}

/// Deep link payment initiated — waiting for user to return from banking app.
final class PaymentDeepLinkLaunched extends PaymentState {
  const PaymentDeepLinkLaunched({
    required this.method,
    required this.amountKHR,
    required this.invoiceId,
  });

  /// Which banking app was launched.
  final PaymentMethod method;

  /// Amount being paid.
  final double amountKHR;

  /// Invoice ID for reference.
  final String invoiceId;

  @override
  List<Object?> get props => [method, amountKHR, invoiceId];
}

/// Device is offline — cannot initiate KHQR payment.
final class PaymentOffline extends PaymentState {
  const PaymentOffline({
    required this.amountKHR,
    required this.invoiceId,
  });

  final double amountKHR;
  final String invoiceId;

  @override
  List<Object?> get props => [amountKHR, invoiceId];
}
