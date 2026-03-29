import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final String source;
  final DateTime fetchedAt;
  final bool isActive;

  const ExchangeRate({
    required this.id,
    this.baseCurrency = 'KHR',
    this.targetCurrency = 'USD',
    required this.rate,
    required this.source,
    required this.fetchedAt,
    this.isActive = true,
  });

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
