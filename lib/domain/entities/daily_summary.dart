import 'package:equatable/equatable.dart';

class DailySummary extends Equatable {
  final DateTime date;
  final int totalTransactions;
  final double totalRevenue;
  final double totalRevenueUSD;
  final double totalDiscount;
  final double totalTax;

  const DailySummary({
    required this.date,
    this.totalTransactions = 0,
    this.totalRevenue = 0,
    this.totalRevenueUSD = 0,
    this.totalDiscount = 0,
    this.totalTax = 0,
  });

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
