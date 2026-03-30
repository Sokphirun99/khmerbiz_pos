import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/daily_summary.dart';

class WeeklySummary extends Equatable {
  const WeeklySummary({
    required this.weekStart,
    required this.weekEnd,
    this.totalTransactions = 0,
    this.totalRevenue = 0,
    this.totalRevenueUSD = 0,
    this.dailySummaries = const [],
  });
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalTransactions;
  final double totalRevenue;
  final double totalRevenueUSD;
  final List<DailySummary> dailySummaries;

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
