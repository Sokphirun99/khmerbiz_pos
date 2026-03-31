import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/daily_summary.dart';
import 'package:khmerbiz_pos/domain/entities/top_product.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';
import 'package:khmerbiz_pos/domain/entities/transaction_item.dart';
import 'package:khmerbiz_pos/domain/entities/weekly_summary.dart';

/// Container for a [Transaction] and its associated [TransactionItem]s.
class TransactionWithItems {
  /// Creates a [TransactionWithItems] container.
  TransactionWithItems({required this.transaction, required this.items});

  /// The root transaction record.
  final Transaction transaction;

  /// The list of items belonging to this transaction.
  final List<TransactionItem> items;
}

/// Repository interface for handling sales, reports, and analytics.
abstract class TransactionRepository {
  /// Processes a complete sale, updating stock and recording the transaction.
  Future<Either<Failure, String>> processSale({
    required Transaction transaction,
    required List<TransactionItem> items,
  });

  /// Watches all successful transactions recorded today.
  Stream<Either<Failure, List<Transaction>>> watchTodayTransactions();

  /// Watches transactions within a specific [start] and [end] date range.
  Stream<Either<Failure, List<Transaction>>> watchTransactionsByDateRange(
    DateTime start,
    DateTime end,
  );

  /// Retrieves a specific transaction and its items by [id].
  Future<Either<Failure, TransactionWithItems>> getTransactionWithItems(
    String id,
  );

  /// Retrieves the sales summary for a specific [date].
  Future<Either<Failure, DailySummary>> getDailySummary(DateTime date);

  /// Retrieves the sales summary for the week starting at [weekStart].
  Future<Either<Failure, WeeklySummary>> getWeeklySummary(DateTime weekStart);

  /// Retrieves a list of top-selling products between [start] and [end].
  Future<Either<Failure, List<TopProduct>>> getTopProducts(
    DateTime start,
    DateTime end,
    int limit,
  );

  /// Voids a transaction for a specific reason (requires [staffId]).
  Future<Either<Failure, void>> voidTransaction(String id, String staffId);

  /// Watches transactions that have not yet been synced to the remote server.
  Stream<Either<Failure, List<Transaction>>> watchUnsyncedTransactions();
}
