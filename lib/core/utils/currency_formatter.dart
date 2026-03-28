import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/config/constants.dart';

/// Currency formatter for Cambodian Riel (KHR) and US Dollar (USD).
///
/// KhmerBiz POS displays both currencies simultaneously:
/// - Primary: Cambodian Riel (៛)
/// - Secondary: US Dollar ($)
///
/// Example usage:
/// ```dart
/// final formatter = CurrencyFormatter();
/// formatter.formatKHR(12500); // "៛12,500"
/// formatter.formatUSD(3.05);  // "$3.05"
/// formatter.formatDual(12500); // "៛12,500 ($3.05)"
/// ```
final class CurrencyFormatter {

  /// Creates a currency formatter with the given exchange rate.
  ///
  /// [exchangeRate] - The current exchange rate (1 USD = X KHR)
  /// Defaults to [AppConstants.defaultExchangeRate] if not provided.
  CurrencyFormatter({double? exchangeRate})
      : _exchangeRate = exchangeRate ?? AppConstants.defaultExchangeRate {
    _khrFormat = NumberFormat('#,##0', 'en_US');
    _usdFormat = NumberFormat('#,##0.00', 'en_US');
  }
  /// Current exchange rate (1 USD = X KHR)
  /// This can be updated from the API
  double _exchangeRate;

  /// Number format for KHR (no decimal places)
  late final NumberFormat _khrFormat;

  /// Number format for USD (2 decimal places)
  late final NumberFormat _usdFormat;

  /// Current exchange rate
  double get exchangeRate => _exchangeRate;

  /// Update the exchange rate.
  ///
  /// [newRate] - The new exchange rate (1 USD = X KHR)
  /// Throws [ArgumentError] if the rate is outside valid range.
  void updateExchangeRate(double newRate) {
    if (newRate < AppConstants.minExchangeRate ||
        newRate > AppConstants.maxExchangeRate) {
      throw ArgumentError(
        'Exchange rate must be between ${AppConstants.minExchangeRate} and ${AppConstants.maxExchangeRate}',
      );
    }
    _exchangeRate = newRate;
  }

  /// Format amount in Cambodian Riel.
  ///
  /// [amount] - Amount in KHR
  /// Returns formatted string with Riel symbol, e.g., "៛12,500"
  String formatKHR(double amount) {
    final rounded = amount.round().toDouble();
    return '${AppConstants.currencySymbolKHR}${_khrFormat.format(rounded)}';
  }

  /// Format amount in US Dollars.
  ///
  /// [amount] - Amount in USD
  /// Returns formatted string with Dollar symbol, e.g., "$3.05"
  String formatUSD(double amount) {
    return '${AppConstants.currencySymbolUSD}${_usdFormat.format(amount)}';
  }

  /// Format amount showing both KHR and USD.
  ///
  /// [amountInKHR] - Amount in Cambodian Riel
  /// Returns formatted string like "៛12,500 ($3.05)"
  ///
  /// This is the primary format used throughout KhmerBiz POS.
  String formatDual(double amountInKHR) {
    final usdAmount = khqrToUSD(amountInKHR);
    return '${formatKHR(amountInKHR)} (${formatUSD(usdAmount)})';
  }

  /// Format amount showing both USD and KHR (USD primary).
  ///
  /// [amountInUSD] - Amount in US Dollars
  /// Returns formatted string like "$3.05 (៛12,500)"
  String formatDualUSD(double amountInUSD) {
    final khrAmount = usdToKHR(amountInUSD);
    return '${formatUSD(amountInUSD)} (${formatKHR(khrAmount)})';
  }

  /// Convert KHR to USD using current exchange rate.
  ///
  /// [amountInKHR] - Amount in Cambodian Riel
  /// Returns equivalent amount in USD
  double khqrToUSD(double amountInKHR) {
    return amountInKHR / _exchangeRate;
  }

  /// Convert USD to KHR using current exchange rate.
  ///
  /// [amountInUSD] - Amount in US Dollars
  /// Returns equivalent amount in KHR
  double usdToKHR(double amountInUSD) {
    return amountInUSD * _exchangeRate;
  }

  /// Parse KHR string to double.
  ///
  /// [formatted] - Formatted KHR string, e.g., "៛12,500" or "12,500"
  /// Returns the numeric value, or 0 if parsing fails
  double parseKHR(String formatted) {
    try {
      // Remove currency symbol and whitespace
      final cleaned = formatted
          .replaceAll(AppConstants.currencySymbolKHR, '')
          .replaceAll(AppConstants.currencySymbolUSD, '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleaned) ?? 0.0;
    } catch (_) {
      return 0;
    }
  }

  /// Parse USD string to double.
  ///
  /// [formatted] - Formatted USD string, e.g., "$3.05" or "3.05"
  /// Returns the numeric value, or 0 if parsing fails
  double parseUSD(String formatted) {
    try {
      // Remove currency symbol and whitespace
      final cleaned = formatted
          .replaceAll(AppConstants.currencySymbolKHR, '')
          .replaceAll(AppConstants.currencySymbolUSD, '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleaned) ?? 0.0;
    } catch (_) {
      return 0;
    }
  }

  /// Format amount with custom decimal places.
  ///
  /// [amount] - Amount in KHR
  /// [decimalPlaces] - Number of decimal places to show
  /// Returns formatted string
  String formatKHRCustom(double amount, int decimalPlaces) {
    final pattern = decimalPlaces > 0
        ? '#,##0.${'0' * decimalPlaces}'
        : '#,##0';
    final format = NumberFormat(pattern, 'en_US');
    return '${AppConstants.currencySymbolKHR}${format.format(amount)}';
  }

  /// Get exchange rate display string.
  ///
  /// Returns formatted string like "1 USD = ៛4,100"
  String get exchangeRateDisplay {
    return '1 ${AppConstants.currencySymbolUSD} = ${formatKHR(_exchangeRate)}';
  }

  /// Create a copy with a different exchange rate.
  ///
  /// [exchangeRate] - New exchange rate to use
  /// Returns a new [CurrencyFormatter] instance
  CurrencyFormatter copyWith({double? exchangeRate}) {
    return CurrencyFormatter(
      exchangeRate: exchangeRate ?? _exchangeRate,
    );
  }
}

/// Global singleton instance for convenience.
///
/// For most use cases, use this global instance.
/// Create a new instance only when you need different exchange rates.
final currencyFormatter = CurrencyFormatter();

/// Extension on double for convenient currency formatting.
///
/// Example:
/// ```dart
/// 12500.0.formatKHR;        // "៛12,500"
/// 12500.0.formatUSD;        // "$3.05" (converted)
/// 12500.0.formatDual;       // "៛12,500 ($3.05)"
/// ```
extension CurrencyFormattingExtension on double {
  /// Format as KHR
  String get formatKHR => currencyFormatter.formatKHR(this);

  /// Format as USD (converted from KHR)
  String get formatUSD => currencyFormatter.formatUSD(
        currencyFormatter.khqrToUSD(this),
      );

  /// Format as dual (KHR primary, USD secondary)
  String get formatDual => currencyFormatter.formatDual(this);

  /// Convert to USD
  double get toUSD => currencyFormatter.khqrToUSD(this);

  /// Convert to KHR (if this value is in USD)
  double get toKHR => currencyFormatter.usdToKHR(this);
}

/// Extension on int for convenient currency formatting.
extension IntCurrencyFormattingExtension on int {
  /// Format as KHR
  String get formatKHR => currencyFormatter.formatKHR(toDouble());

  /// Format as dual (KHR primary, USD secondary)
  String get formatDual => currencyFormatter.formatDual(toDouble());
}
