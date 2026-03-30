import 'package:equatable/equatable.dart';

/// Data returned after generating a dynamic KHQR code.
///
/// Contains the QR string for rendering, the MD5 hash for polling
/// payment status, and transaction metadata.
class KhqrData extends Equatable {
  const KhqrData({
    required this.qrString,
    required this.md5Hash,
    required this.amountKHR,
    required this.amountUSD,
    required this.invoiceId,
    required this.generatedAt,
    required this.expiresAt,
  });

  /// The QR code content string (EMVCo-compliant KHQR payload).
  final String qrString;

  /// MD5 hash used for polling payment status via Bakong API.
  final String md5Hash;

  /// Transaction amount in Cambodian Riel.
  final double amountKHR;

  /// Transaction amount in US Dollars (converted at generation time).
  final double amountUSD;

  /// Invoice/receipt identifier embedded in the QR.
  final String invoiceId;

  /// Timestamp when the QR was generated.
  final DateTime generatedAt;

  /// Expiration timestamp (generatedAt + 5 minutes).
  final DateTime expiresAt;

  /// Whether the QR code has expired.
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Remaining duration until expiry.
  Duration get remainingDuration {
    final remaining = expiresAt.difference(DateTime.now());
    return remaining.isNegative ? Duration.zero : remaining;
  }

  @override
  List<Object?> get props => [
        qrString,
        md5Hash,
        amountKHR,
        amountUSD,
        invoiceId,
        generatedAt,
        expiresAt,
      ];
}
