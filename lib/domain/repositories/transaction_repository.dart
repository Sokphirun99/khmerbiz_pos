import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/transaction.dart';
import '../entities/transaction_item.dart';
import '../entities/daily_summary.dart';
import '../entities/weekly_summary.dart';
import '../entities/top_product.dart';

class TransactionWithItems {
  final Transaction transaction;
  final List<TransactionItem> items;
  TransactionWithItems({required this.transaction, required this.items});
}

abstract class TransactionRepository {
  Future<Either<Failure, String>> processSale({
    required Transaction transaction,
    required List<TransactionItem> items,
  });
  Stream<Either<Failure, List<Transaction>>> watchTodayTransactions();
  Stream<Either<Failure, List<Transaction>>> watchTransactionsByDateRange(DateTime start, DateTime end);
  Future<Either<Failure, TransactionWithItems>> getTransactionWithItems(String id);
  Future<Either<Failure, DailySummary>> getDailySummary(DateTime date);
  Future<Either<Failure, WeeklySummary>> getWeeklySummary(DateTime weekStart);
  Future<Either<Failure, List<TopProduct>>> getTopProducts(DateTime start, DateTime end, int limit);
  Future<Either<Failure, void>> voidTransaction(String id, String staffId);
  Stream<Either<Failure, List<Transaction>>> watchUnsyncedTransactions();
}
