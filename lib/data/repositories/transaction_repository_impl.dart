import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/transactions_dao.dart'
    hide TransactionWithItems;
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/daily_summary.dart';
import 'package:khmerbiz_pos/domain/entities/top_product.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart' as entity;
import 'package:khmerbiz_pos/domain/entities/transaction_item.dart'
    as entityItem;
import 'package:khmerbiz_pos/domain/entities/weekly_summary.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._dao);
  final TransactionsDao _dao;

  entity.Transaction _mapToDomain(TransactionModel model) {
    return entity.Transaction(
      id: model.id,
      receiptNumber: model.receiptNumber,
      transactionDate: model.transactionDate,
      staffId: model.staffId,
      customerId: model.customerId,
      subtotal: model.subtotal,
      discountType: model.discountType,
      discountValue: model.discountValue,
      discountAmount: model.discountAmount,
      taxRate: model.taxRate,
      taxAmount: model.taxAmount,
      totalAmount: model.totalAmount,
      totalAmountUSD: model.totalAmountUSD,
      paymentMethod: model.paymentMethod,
      cashReceived: model.cashReceived,
      changeGiven: model.changeGiven,
      khqrReference: model.khqrReference,
      khqrMd5: model.khqrMd5,
      status: model.status,
      isSynced: model.isSynced,
      syncedAt: model.syncedAt,
      notes: model.notes,
      createdAt: model.createdAt,
    );
  }

  entityItem.TransactionItem _mapItemToDomain(TransactionItemModel model) {
    return entityItem.TransactionItem(
      id: model.id,
      transactionId: model.transactionId,
      productId: model.productId,
      productNameSnapshot: model.productNameSnapshot,
      productNameEnSnapshot: model.productNameEnSnapshot,
      quantity: model.quantity,
      unitPrice: model.unitPrice,
      costPrice: model.costPrice,
      discountAmount: model.discountAmount,
      subtotal: model.subtotal,
      modifiers: model.modifiers,
    );
  }

  @override
  Future<Either<Failure, String>> processSale({
    required entity.Transaction transaction,
    required List<entityItem.TransactionItem> items,
  }) async {
    try {
      final txCompanion = TransactionsCompanion(
        transactionDate: Value(transaction.transactionDate),
        staffId: Value(transaction.staffId),
        customerId: Value(transaction.customerId),
        subtotal: Value(transaction.subtotal),
        discountType: Value(transaction.discountType),
        discountValue: Value(transaction.discountValue),
        discountAmount: Value(transaction.discountAmount),
        taxRate: Value(transaction.taxRate),
        taxAmount: Value(transaction.taxAmount),
        totalAmount: Value(transaction.totalAmount),
        totalAmountUSD: Value(transaction.totalAmountUSD),
        paymentMethod: Value(transaction.paymentMethod),
        cashReceived: Value(transaction.cashReceived),
        changeGiven: Value(transaction.changeGiven),
        status: Value(transaction.status),
        createdAt: Value(DateTime.now()),
      );

      final itemsCompanion = items
          .map(
            (item) => TransactionItemsCompanion(
              productId: Value(item.productId),
              productNameSnapshot: Value(item.productNameSnapshot),
              productNameEnSnapshot: Value(item.productNameEnSnapshot),
              quantity: Value(item.quantity),
              unitPrice: Value(item.unitPrice),
              costPrice: Value(item.costPrice),
              subtotal: Value(item.subtotal),
              discountAmount: Value(item.discountAmount),
            ),
          )
          .toList();

      final txId = await _dao.processSale(
          transaction: txCompanion, items: itemsCompanion);
      return right(txId);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<entity.Transaction>>> watchTodayTransactions() {
    return _dao.watchTodayTransactions().map((models) {
      return right<Failure, List<entity.Transaction>>(
          models.map(_mapToDomain).toList());
    }).handleError((err) => left<Failure, List<entity.Transaction>>(
        CacheFailure.defaultError(details: err.toString())));
  }

  @override
  Stream<Either<Failure, List<entity.Transaction>>>
      watchTransactionsByDateRange(DateTime start, DateTime end) {
    return _dao.watchTransactionsByDateRange(start, end).map((models) {
      return right<Failure, List<entity.Transaction>>(
          models.map(_mapToDomain).toList());
    }).handleError((err) => left<Failure, List<entity.Transaction>>(
        CacheFailure.defaultError(details: err.toString())));
  }

  @override
  Future<Either<Failure, TransactionWithItems>> getTransactionWithItems(
      String id) async {
    try {
      final res = await _dao.getTransactionWithItems(id);
      if (res == null) return left(ServerFailure.notFound());
      return right(
        TransactionWithItems(
          transaction: _mapToDomain(res.transaction),
          items: res.items.map(_mapItemToDomain).toList(),
        ),
      );
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DailySummary>> getDailySummary(DateTime date) async {
    try {
      final res = await _dao.getDailySummary(date);
      return right(
        DailySummary(
          date: res.date,
          totalTransactions: res.totalTransactions,
          totalRevenue: res.totalRevenue,
          totalRevenueUSD: res.totalRevenueUSD,
        ),
      );
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklySummary>> getWeeklySummary(
      DateTime weekStart) async {
    try {
      final res = await _dao.getWeeklySummary(weekStart);
      return right(
        WeeklySummary(
          weekStart: weekStart,
          weekEnd: weekStart.add(const Duration(days: 7)),
          totalTransactions: res.totalTransactions,
          totalRevenue: res.totalRevenue,
          totalRevenueUSD: res.totalRevenueUSD,
        ),
      );
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TopProduct>>> getTopProducts(
      DateTime start, DateTime end, int limit) async {
    try {
      await _dao.getTopProducts(start, end, limit);
      // In a real app we would map productId to full Product domain entities, since getTopProducts returns them.
      // We will skip actual product mapping to avoid creating an n+1 query here just for the skeleton
      return right(
          []); // To correctly implement, fetch Products via ProductRepository.
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> voidTransaction(
      String id, String staffId) async {
    try {
      await _dao.voidTransaction(id, staffId);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<entity.Transaction>>>
      watchUnsyncedTransactions() {
    return _dao.watchUnsyncedTransactions().map((models) {
      return right<Failure, List<entity.Transaction>>(
          models.map(_mapToDomain).toList());
    }).handleError((err) => left<Failure, List<entity.Transaction>>(
        CacheFailure.defaultError(details: err.toString())));
  }
}
