import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';

/// States for the PaymentBloc.
sealed class PaymentState extends Equatable {
  /// Base constructor for all [PaymentState]s.
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state — no payment flow active.
final class PaymentIdle extends PaymentState {
  /// Creates a [PaymentIdle] state.
  const PaymentIdle();
}

/// Generating the KHQR code (network call in progress).
final class KhqrGenerating extends PaymentState {
  /// Creates a [KhqrGenerating] state.
  const KhqrGenerating();
}

/// QR code is ready for display.
final class KhqrReady extends PaymentState {
  /// Creates a [KhqrReady] state.
  const KhqrReady({
    required this.qrString,
    required this.md5Hash,
    required this.amountKHR,
    required this.amountUSD,
    required this.invoiceId,
    required this.expiresAt,
    required this.pollAttempt,
    required this.remaining,
  });

  /// The QR code content string.
  final String qrString;

  /// MD5 hash for status lookup.
  final String md5Hash;

  /// Amount in KHR.
  final double amountKHR;

  /// Amount in USD.
  final double amountUSD;

  /// Invoice ID.
  final String invoiceId;

  /// Expiration timestamp.
  final DateTime expiresAt;

  /// Current polling attempt count.
  final int pollAttempt;

  /// Time remaining until expiry.
  final Duration remaining;

  /// Formatted remaining time as "M:SS".
  String get remainingFormatted {
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  List<Object?> get props => [
        qrString,
        md5Hash,
        amountKHR,
        amountUSD,
        invoiceId,
        expiresAt,
        pollAttempt,
        remaining,
      ];
}

/// Polling for payment status.
final class KhqrPolling extends PaymentState {
  /// Creates a [KhqrPolling] state.
  const KhqrPolling({
    required this.md5Hash,
    required this.attemptCount,
  });

  /// MD5 hash for status lookup.
  final String md5Hash;

  /// Number of poll attempts so far.
  final int attemptCount;

  @override
  List<Object?> get props => [md5Hash, attemptCount];
}

/// Payment has been confirmed by the bank or manually.
final class PaymentConfirmed extends PaymentState {
  /// Creates a [PaymentConfirmed] state.
  const PaymentConfirmed({
    required this.method,
    required this.reference,
    required this.amountKHR,
    required this.md5Hash,
  });

  /// Payment method used (KHQR, ABA, Wing, Cash).
  final PaymentMethod method;

  /// Bank reference or manual note.
  final String reference;

  /// Confirmed amount in KHR.
  final double amountKHR;

  /// MD5 hash of the confirmed QR.
  final String md5Hash;

  @override
  List<Object?> get props => [method, reference, amountKHR, md5Hash];
}

/// Payment failed with an error.
final class PaymentFailed extends PaymentState {
  /// Creates a [PaymentFailed] state.
  const PaymentFailed({required this.failure});

  /// Failure object containing Khmer and English messages.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// KHQR code has expired.
final class PaymentTimeout extends PaymentState {
  /// Creates a [PaymentTimeout] state.
  const PaymentTimeout();
}

/// User cancelled the payment flow.
final class PaymentCancelled extends PaymentState {
  /// Creates a [PaymentCancelled] state.
  const PaymentCancelled();
}

/// ABA or Wing app was launched via deep link.
final class ExternalAppLaunched extends PaymentState {
  /// Creates an [ExternalAppLaunched] state.
  const ExternalAppLaunched({required this.method});

  /// Which banking app was launched.
  final PaymentMethod method;

  @override
  List<Object?> get props => [method];
}

/// Network was lost during an active payment flow.
final class PaymentOffline extends PaymentState {
  /// Creates a [PaymentOffline] state.
  const PaymentOffline();
}
