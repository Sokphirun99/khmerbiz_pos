import 'package:equatable/equatable.dart';

/// Merchant information required for KHQR generation.
///
/// Loaded from local settings/database. The merchant must register
/// with an NBC-approved platform (Bakong, ABA, ACLEDA, etc.).
class MerchantInfo extends Equatable {
  const MerchantInfo({
    required this.merchantId,
    required this.merchantName,
    required this.merchantNameKh,
    required this.merchantCity,
    required this.acquiringBank,
    required this.accountId,
    this.merchantCategoryCode = '5411',
    this.currency = 'KHR',
  });

  /// NBC-issued merchant ID.
  final String merchantId;

  /// Business name in English.
  final String merchantName;

  /// Business name in Khmer.
  final String merchantNameKh;

  /// City where the merchant operates (e.g., 'Phnom Penh', 'Siem Reap').
  final String merchantCity;

  /// Merchant Category Code per ISO 18245.
  /// - 5411 = Grocery stores
  /// - 5812 = Restaurants
  /// - 5999 = Miscellaneous retail
  final String merchantCategoryCode;

  /// Acquiring bank name (e.g., 'ABA', 'ACLEDA', 'Bakong').
  final String acquiringBank;

  /// Transaction currency ('KHR' or 'USD').
  final String currency;

  /// Merchant bank account ID.
  final String accountId;

  /// Default placeholder for development/testing.
  static const MerchantInfo placeholder = MerchantInfo(
    merchantId: 'DEMO_MERCHANT_001',
    merchantName: 'KhmerBiz Demo Store',
    merchantNameKh: 'ហាងសាកល្បង ខ្មែរប៊ីស',
    merchantCity: 'Phnom Penh',
    acquiringBank: 'Bakong',
    accountId: 'demo_account@bakong',
  );

  @override
  List<Object?> get props => [
        merchantId,
        merchantName,
        merchantNameKh,
        merchantCity,
        merchantCategoryCode,
        acquiringBank,
        currency,
        accountId,
      ];
}
