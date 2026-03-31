import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/domain/entities/daily_summary.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/top_product.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/features/home/presentation/bloc/home_event.dart';
import 'package:khmerbiz_pos/features/home/presentation/bloc/home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required TransactionRepository transactionRepository,
    required ProductRepository productRepository,
  })  : _transactionRepository = transactionRepository,
        _productRepository = productRepository,
        super(const HomeInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
    on<UpdateRecentTransactions>(_onUpdateRecentTransactions);
    on<UpdateLowStockCount>(_onUpdateLowStockCount);
    on<UpdatePendingSync>(_onUpdatePendingSync);
  }

  final TransactionRepository _transactionRepository;
  final ProductRepository _productRepository;

  StreamSubscription<Either<dynamic, List<Transaction>>>? _todayTxSubscription;
  StreamSubscription<Either<dynamic, List<Product>>>? _lowStockSubscription;

  Future<void> _onLoadDashboard(
    LoadDashboard event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());

    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 6));

    final dailyResult = await _transactionRepository.getDailySummary(now);
    final weeklyResult =
        await _transactionRepository.getWeeklySummary(weekStart);
    final topProductsResult =
        await _transactionRepository.getTopProducts(now, now, 5);
    final lowStockResult = await _productRepository.getLowStockProducts();

    DailySummary? dailySummary;
    dailyResult.fold(
      (_) => dailySummary = null,
      (summary) => dailySummary = summary,
    );

    var weeklyData = <DailySummary>[];
    weeklyResult.fold(
      (_) => weeklyData = [],
      (weekly) => weeklyData = weekly.dailySummaries,
    );

    var topProducts = <TopProduct>[];
    topProductsResult.fold(
      (_) => topProducts = [],
      (products) => topProducts = products,
    );

    var lowStockCount = 0;
    lowStockResult.fold(
      (_) => lowStockCount = 0,
      (products) => lowStockCount = products.length,
    );

    emit(
      HomeLoaded(
        dailySummary: dailySummary,
        lowStockCount: lowStockCount,
        weeklyData: weeklyData,
        topProducts: topProducts,
      ),
    );

    _setupSubscriptions();
  }

  Future<void> _onRefreshDashboard(
    RefreshDashboard event,
    Emitter<HomeState> emit,
  ) async {
    if (state is! HomeLoaded) {
      add(const LoadDashboard());
      return;
    }

    final currentState = state as HomeLoaded;
    final now = DateTime.now();
    final weekStart = now.subtract(const Duration(days: 6));

    final dailyResult = await _transactionRepository.getDailySummary(now);
    final weeklyResult =
        await _transactionRepository.getWeeklySummary(weekStart);
    final topProductsResult =
        await _transactionRepository.getTopProducts(now, now, 5);
    final lowStockResult = await _productRepository.getLowStockProducts();

    var dailySummary = currentState.dailySummary;
    dailyResult.fold(
      (_) => null,
      (summary) => dailySummary = summary,
    );

    var weeklyData = currentState.weeklyData;
    weeklyResult.fold(
      (_) => null,
      (weekly) => weeklyData = weekly.dailySummaries,
    );

    var topProducts = currentState.topProducts;
    topProductsResult.fold(
      (_) => null,
      (products) => topProducts = products,
    );

    var lowStockCount = currentState.lowStockCount;
    lowStockResult.fold(
      (_) => null,
      (products) => lowStockCount = products.length,
    );

    emit(
      HomeLoaded(
        dailySummary: dailySummary,
        lowStockCount: lowStockCount,
        pendingSync: currentState.pendingSync,
        weeklyData: weeklyData,
        topProducts: topProducts,
        recentTransactions: currentState.recentTransactions,
      ),
    );
  }

  void _onUpdateRecentTransactions(
    UpdateRecentTransactions event,
    Emitter<HomeState> emit,
  ) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    emit(
      current.copyWith(
        recentTransactions: event.transactions.take(10).toList(),
      ),
    );
  }

  void _onUpdateLowStockCount(
    UpdateLowStockCount event,
    Emitter<HomeState> emit,
  ) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    emit(current.copyWith(lowStockCount: event.count));
  }

  void _onUpdatePendingSync(
    UpdatePendingSync event,
    Emitter<HomeState> emit,
  ) {
    if (state is! HomeLoaded) return;
    final current = state as HomeLoaded;
    emit(current.copyWith(pendingSync: event.count));
  }

  void _setupSubscriptions() {
    _todayTxSubscription?.cancel();
    _todayTxSubscription =
        _transactionRepository.watchTodayTransactions().listen((result) {
      result.fold(
        (_) => null,
        (transactions) {
          add(UpdateRecentTransactions(transactions: transactions));
        },
      );
    });

    _lowStockSubscription?.cancel();
    _lowStockSubscription =
        _productRepository.watchAllActiveProducts().listen((result) {
      result.fold(
        (_) => null,
        (products) {
          final lowStock = products
              .where(
                (p) => p.stock <= p.lowStockThreshold,
              )
              .length;
          add(UpdateLowStockCount(count: lowStock));
        },
      );
    });
  }

  void updatePendingSync(int count) {
    add(UpdatePendingSync(count: count));
  }

  @override
  Future<void> close() {
    _todayTxSubscription?.cancel();
    _lowStockSubscription?.cancel();
    return super.close();
  }
}
