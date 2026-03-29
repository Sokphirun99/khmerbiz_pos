import 'package:equatable/equatable.dart';
import 'daily_summary.dart';

class WeeklySummary extends Equatable {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalTransactions;
  final double totalRevenue;
  final double totalRevenueUSD;
  final List<DailySummary> dailySummaries;

  const WeeklySummary({
    required this.weekStart,
    required this.weekEnd,
    this.totalTransactions = 0,
    this.totalRevenue = 0,
    this.totalRevenueUSD = 0,
    this.dailySummaries = const [],
  });

  @override
  List<Object?> get props => [
        weekStart,
        weekEnd,
        totalTransactions,
        totalRevenue,
        totalRevenueUSD,
        dailySummaries,
      ];
}
