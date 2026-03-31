import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/daily_summary.dart';
import 'package:khmerbiz_pos/domain/entities/top_product.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    this.dailySummary,
    this.lowStockCount = 0,
    this.pendingSync = 0,
    this.weeklyData = const [],
    this.topProducts = const [],
    this.recentTransactions = const [],
  });

  final DailySummary? dailySummary;
  final int lowStockCount;
  final int pendingSync;
  final List<DailySummary> weeklyData;
  final List<TopProduct> topProducts;
  final List<Transaction> recentTransactions;

  HomeLoaded copyWith({
    DailySummary? dailySummary,
    int? lowStockCount,
    int? pendingSync,
    List<DailySummary>? weeklyData,
    List<TopProduct>? topProducts,
    List<Transaction>? recentTransactions,
  }) {
    return HomeLoaded(
      dailySummary: dailySummary ?? this.dailySummary,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      pendingSync: pendingSync ?? this.pendingSync,
      weeklyData: weeklyData ?? this.weeklyData,
      topProducts: topProducts ?? this.topProducts,
      recentTransactions: recentTransactions ?? this.recentTransactions,
    );
  }

  @override
  List<Object?> get props => [
        dailySummary,
        lowStockCount,
        pendingSync,
        weeklyData,
        topProducts,
        recentTransactions,
      ];
}

final class HomeError extends HomeState {
  const HomeError({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
