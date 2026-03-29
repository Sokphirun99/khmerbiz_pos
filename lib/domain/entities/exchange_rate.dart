import 'package:equatable/equatable.dart';

class ExchangeRate extends Equatable {

  const ExchangeRate({
    required this.id,
    required this.rate, required this.source, required this.fetchedAt, this.baseCurrency = 'KHR',
    this.targetCurrency = 'USD',
    this.isActive = true,
  });
  final String id;
  final String baseCurrency;
  final String targetCurrency;
  final double rate;
  final String source;
  final DateTime fetchedAt;
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
