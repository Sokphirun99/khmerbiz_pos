import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/daily_summary.dart';

/// Statistical summary of sales for a specific week.
///
/// Aggregates data from multiple [DailySummary] instances.
class WeeklySummary extends Equatable {
  /// Creates a [WeeklySummary] for a date range.
  const WeeklySummary({
    required this.weekStart,
    required this.weekEnd,
    this.totalTransactions = 0,
    this.totalRevenue = 0,
    this.totalRevenueUSD = 0,
    this.dailySummaries = const [],
  });

  /// The start date of the week.
  final DateTime weekStart;

  /// The end date of the week.
  final DateTime weekEnd;

  /// Total number of successful transactions in this week.
  final int totalTransactions;

  /// Total combined revenue for the week in KHR.
  final double totalRevenue;

  /// Total combined revenue for the week in USD.
  final double totalRevenueUSD;

  /// Breakdown of summaries for each day in the week.
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
