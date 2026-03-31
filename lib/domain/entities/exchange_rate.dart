import 'package:equatable/equatable.dart';

/// Exchange rate entity for KHR/USD conversion.
class ExchangeRate extends Equatable {
  /// Creates an [ExchangeRate] entity.
  const ExchangeRate({
    required this.id,
    required this.rate,
    required this.source,
    required this.fetchedAt,
    this.baseCurrency = 'KHR',
    this.targetCurrency = 'USD',
    this.isActive = true,
  });

  /// Unique identifier for the exchange rate record.
  final String id;

  /// The base currency (usually "KHR").
  final String baseCurrency;

  /// The target currency (usually "USD").
  final String targetCurrency;

  /// The conversion rate from base to target (e.g., 4000.0).
  final double rate;

  /// The source of the rate (e.g., "NBC", "Manual", "Bank").
  final String source;

  /// Timestamp when the rate was fetched or updated.
  final DateTime fetchedAt;

  /// Whether this rate is currently active and used for calculations.
  final bool isActive;

  @override
  List<Object?> get props => [
        id,
        baseCurrency,
        targetCurrency,
        rate,
        source,
        fetchedAt,
        isActive,
      ];
}
