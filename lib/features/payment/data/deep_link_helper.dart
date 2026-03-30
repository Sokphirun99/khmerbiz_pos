import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/merchant_info.dart';

/// Helper for generating ABA and Wing deep link URLs.
///
/// Deep links allow the POS to open the customer's banking app
/// with pre-filled payment details, reducing manual entry errors.
///
/// Required package: `url_launcher: ^6.2.0`
/// Add to pubspec.yaml: `flutter pub add url_launcher`
///
/// ABA deep link format:
///   aba://pay?account={accountId}&amount={amount}&currency=KHR&memo={invoiceId}
///
/// Wing deep link format:
///   wing://transfer?to={accountId}&amount={amount}&currency=KHR&ref={invoiceId}
///
/// Note: These are documented deep link schemas for ABA and Wing apps.
/// Actual schemas may vary and should be verified with each bank's
/// developer documentation.
class DeepLinkHelper {
  const DeepLinkHelper._();

  // ── ABA Bank ────────────────────────────────────────────────────────────

  /// ABA Mobile app deep link scheme.
  static const String _abaScheme = 'aba';

  /// ABA Mobile app package name (Android).
  static const String abaPackageAndroid = 'com.paygo24.ibank';

  /// ABA Mobile app bundle ID (iOS).
  static const String abaBundleIOS = 'com.aboretum.aba-mobile';

  /// ABA App Store URL (iOS fallback).
  static const String abaAppStoreUrl =
      'https://apps.apple.com/kh/app/aba-mobile/id1023211498';

  /// ABA Play Store URL (Android fallback).
  static const String abaPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.paygo24.ibank';

  /// Generate an ABA deep link URL for payment.
  static Uri generateAbaDeepLink({
    required double amountKHR,
    required String invoiceId,
    required MerchantInfo merchantInfo,
  }) {
    return Uri(
      scheme: _abaScheme,
      host: 'pay',
      queryParameters: {
        'account': merchantInfo.accountId,
        'amount': amountKHR.toStringAsFixed(0),
        'currency': merchantInfo.currency,
        'memo': 'KhmerBiz POS - $invoiceId',
      },
    );
  }

  // ── Wing (Cambodia) ────────────────────────────────────────────────────

  /// Wing app deep link scheme.
  static const String _wingScheme = 'wing';

  /// Wing app package name (Android).
  static const String wingPackageAndroid = 'com.wing.wingmoney';

  /// Wing app bundle ID (iOS).
  static const String wingBundleIOS = 'com.wing.wingmoney';

  /// Wing App Store URL (iOS fallback).
  static const String wingAppStoreUrl =
      'https://apps.apple.com/kh/app/wing-money/id1185498498';

  /// Wing Play Store URL (Android fallback).
  static const String wingPlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.wing.wingmoney';

  /// Generate a Wing deep link URL for payment.
  static Uri generateWingDeepLink({
    required double amountKHR,
    required String invoiceId,
    required MerchantInfo merchantInfo,
  }) {
    return Uri(
      scheme: _wingScheme,
      host: 'transfer',
      queryParameters: {
        'to': merchantInfo.accountId,
        'amount': amountKHR.toStringAsFixed(0),
        'currency': merchantInfo.currency,
        'ref': invoiceId,
      },
    );
  }

  // ── Generic Helpers ────────────────────────────────────────────────────

  /// Get the deep link URI for a given payment method.
  static Uri? getDeepLinkUri({
    required PaymentMethod method,
    required double amountKHR,
    required String invoiceId,
    required MerchantInfo merchantInfo,
  }) {
    return switch (method) {
      PaymentMethod.aba => generateAbaDeepLink(
          amountKHR: amountKHR,
          invoiceId: invoiceId,
          merchantInfo: merchantInfo,
        ),
      PaymentMethod.wing => generateWingDeepLink(
          amountKHR: amountKHR,
          invoiceId: invoiceId,
          merchantInfo: merchantInfo,
        ),
      _ => null,
    };
  }

  /// Get the fallback store URL for a payment method.
  ///
  /// Used when the banking app is not installed.
  static String? getFallbackStoreUrl(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.aba => abaPlayStoreUrl,
      PaymentMethod.wing => wingPlayStoreUrl,
      _ => null,
    };
  }

  /// Get the display name for a payment method.
  static String getDisplayName(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.aba => 'ABA Mobile',
      PaymentMethod.wing => 'Wing Money',
      PaymentMethod.khqr => 'KHQR',
      PaymentMethod.cash => 'Cash',
      PaymentMethod.credit => 'Credit',
    };
  }

  /// Get the Khmer display name for a payment method.
  static String getDisplayNameKm(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.aba => 'ABA ម៉ូបាល',
      PaymentMethod.wing => 'វីង ម៉ានី',
      PaymentMethod.khqr => 'KHQR',
      PaymentMethod.cash => 'សាច់ប្រាក់',
      PaymentMethod.credit => 'ឥណទាន',
    };
  }
}
