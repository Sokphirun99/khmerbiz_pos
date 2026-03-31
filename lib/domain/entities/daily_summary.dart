import 'package:equatable/equatable.dart';

/// Statistical summary of sales for a specific date.
class DailySummary extends Equatable {
  /// Creates a [DailySummary] for a specific [date].
  const DailySummary({
    required this.date,
    this.totalTransactions = 0,
    this.totalRevenue = 0,
    this.totalRevenueUSD = 0,
    this.totalDiscount = 0,
    this.totalTax = 0,
  });

  /// The date this summary represents.
  final DateTime date;

  /// Total number of successful transactions on this day.
  final int totalTransactions;

  /// Total revenue in KHR.
  final double totalRevenue;

  /// Total revenue in USD.
  final double totalRevenueUSD;

  /// Total amount of discounts given in KHR.
  final double totalDiscount;

  /// Total amount of taxes collected in KHR.
  final double totalTax;

  @override
  List<Object?> get props => [
        date,
        totalTransactions,
        totalRevenue,
        totalRevenueUSD,
        totalDiscount,
        totalTax,
      ];
}
