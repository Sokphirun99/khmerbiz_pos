import 'package:url_launcher/url_launcher.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';

/// Helper class for launching Cambodian banking app deep links.
///
/// Supports ABA PAY and Wing Money deep links.
class DeepLinkHelper {
  /// URL scheme for ABA PAY.
  static const String _abaScheme = 'aba://pay';

  /// URL scheme for Wing Money.
  static const String _wingScheme = 'wing://transfer';

  /// Launch the ABA PAY deep link.
  ///
  /// Returns `true` if the app was successfully launched.
  Future<bool> launchAbaPay({
    required double amount,
    required String invoiceId,
    required String merchantId,
  }) async {
    final uri = Uri.parse(
      '$_abaScheme?amount=$amount&merchant=$merchantId&ref=$invoiceId',
    );
    return _launchUri(uri);
  }

  /// Launch the Wing Money deep link.
  ///
  /// Returns `true` if the app was successfully launched.
  Future<bool> launchWingMoney({
    required double amount,
    required String invoiceId,
    required String merchantPhone,
  }) async {
    final uri = Uri.parse(
      '$_wingScheme?amount=$amount&to=$merchantPhone&note=$invoiceId',
    );
    return _launchUri(uri);
  }

  /// Get the display name for a payment method.
  static String getDisplayName(PaymentMethod method) => switch (method) {
        PaymentMethod.aba => 'ABA PAY',
        PaymentMethod.wing => 'Wing Money',
        PaymentMethod.khqr => 'KHQR',
        PaymentMethod.cash => 'Cash',
        PaymentMethod.credit => 'Card',
      };

  /// Get the display name for a payment method in Khmer.
  static String getDisplayNameKm(PaymentMethod method) => switch (method) {
        PaymentMethod.aba => 'ABA PAY',
        PaymentMethod.wing => 'Wing Money',
        PaymentMethod.khqr => 'KHQR',
        PaymentMethod.cash => 'ប្រាក់សុទ្ធ',
        PaymentMethod.credit => 'កាត',
      };

  /// Internal helper to check and launch a URI.
  Future<bool> _launchUri(Uri uri) async {
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
