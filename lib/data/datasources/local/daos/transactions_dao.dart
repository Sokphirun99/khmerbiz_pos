import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:uuid/uuid.dart';

part 'transactions_dao.g.dart';

class TransactionWithItems {

  TransactionWithItems({required this.transaction, required this.items});
  final TransactionModel transaction;
  final List<TransactionItemModel> items;
}

class DailySummaryResult {

  DailySummaryResult({
    required this.date,
    required this.totalTransactions,
    required this.totalRevenue,
    required this.totalRevenueUSD,
  });
  final DateTime date;
  final int totalTransactions;
  final double totalRevenue;
  final double totalRevenueUSD;
}

class WeeklySummaryResult {

  WeeklySummaryResult({
    required this.totalTransactions,
    required this.totalRevenue,
    required this.totalRevenueUSD,
  });
  final int totalTransactions;
  final double totalRevenue;
  final double totalRevenueUSD;
}

class TopProductResult {

  TopProductResult({
    required this.productId,
    required this.quantitySold,
    required this.totalRevenue,
  });
  final String productId;
  final double quantitySold;
  final double totalRevenue;
}

@DriftAccessor(
  tables: [Transactions, TransactionItems, Products, InventoryLogs, Customers, SyncQueue],
)
class TransactionsDao extends DatabaseAccessor<AppDatabase> with _$TransactionsDaoMixin {
  TransactionsDao(super.db);
  
  final Uuid _uuid = const Uuid();

  Future<String> processSale({
    required TransactionsCompanion transaction,
    required List<TransactionItemsCompanion> items,
  }) async {
    return db.transaction<String>(() async {
      // a. Generate receiptNumber
      final now = DateTime.now();
      final todayStr =
          '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      final todayCount = await (select(transactions)
            ..where(
              (tbl) => tbl.createdAt.isBetweenValues(startOfDay, endOfDay),
            ))
          .get()
          .then((l) => l.length);
      final sequence = (todayCount + 1).toString().padLeft(4, '0');
      final receiptNumber = 'TXN-$todayStr-$sequence';

      final txId = _uuid.v4();
      
      // b. Insert transactions record
      final txToInsert = transaction.copyWith(
        id: Value(txId),
        receiptNumber: Value(receiptNumber),
      );
      await into(transactions).insert(txToInsert);

      // c, d, e. Iterate items
      for (final item in items) {
        final itemId = _uuid.v4();
        await into(transactionItems).insert(item.copyWith(
          id: Value(itemId),
          transactionId: Value(txId),
        ),);

        // d. Update product stock (atomic decrement)
        final productId = item.productId.value;
        final qty = item.quantity.value;
        await customUpdate(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          variables: [Variable.withReal(qty), Variable.withString(productId)],
          updates: {products},
        );

        // Fetch new stock for the log (it gets tricky to do it without an extra read,
        // but since we just decremented, we can read the product or calculate before vs after)
        // Since we need exact 'before' and 'after' for InventoryLog:
        final p = await (select(products)..where((tbl) => tbl.id.equals(productId))).getSingle();
        final stockAfter = p.stock;
        final stockBefore = stockAfter + qty; // derive before stock based on delta
        
        // e. Insert inventory log
        await into(inventoryLogs).insert(InventoryLogsCompanion(
          id: Value(_uuid.v4()),
          productId: Value(productId),
          changeAmount: Value(-qty),
          stockBefore: Value(stockBefore),
          stockAfter: Value(stockAfter),
          reason: const Value('sale'),
          referenceId: Value(txId),
          staffId: transaction.staffId,
        ),);
      }

      // f. If customerId update loyalty
      if (transaction.customerId.present && transaction.customerId.value != null) {
        final cId = transaction.customerId.value!;
        final amount = transaction.totalAmount.value;
        await customUpdate(
          'UPDATE customers SET loyaltyPoints = loyaltyPoints + ?, totalSpent = totalSpent + ?, totalTransactions = totalTransactions + 1 WHERE id = ?',
          variables: [
            Variable.withReal(amount * 0.01), // dummy logic 1 point per 100 spent
            Variable.withReal(amount),
            Variable.withString(cId),
          ],
          updates: {customers},
        );
      }

      // g. Insert to sync_queue
      await into(syncQueue).insert(SyncQueueCompanion(
        id: Value(_uuid.v4()),
        operationType: const Value('create'),
        entityType: const Value('transaction'),
        entityId: Value(txId),
        payload: const Value(''), // This will be handled by the Repository layer
        priority: const Value(1),
        createdAt: Value(DateTime.now()),
      ),);

      return txId;
    });
  }

  Stream<List<TransactionModel>> watchTodayTransactions() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    return (select(transactions)
          ..where((tbl) => tbl.transactionDate.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  Stream<List<TransactionModel>> watchTransactionsByDateRange(DateTime start, DateTime end) {
    return (select(transactions)
          ..where((tbl) => tbl.transactionDate.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.transactionDate)]))
        .watch();
  }

  Future<TransactionWithItems?> getTransactionWithItems(String id) async {
    final tx = await (select(transactions)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (tx == null) return null;
    final items = await (select(transactionItems)..where((tbl) => tbl.transactionId.equals(id))).get();
    return TransactionWithItems(transaction: tx, items: items);
  }

  Future<DailySummaryResult> getDailySummary(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    
    final txList = await (select(transactions)
          ..where((tbl) => tbl.transactionDate.isBetweenValues(start, end) & tbl.status.equals('completed')))
        .get();
        
    double rev = 0;
    double revUSD = 0;
    for (final tx in txList) {
      rev += tx.totalAmount;
      revUSD += tx.totalAmountUSD;
    }
    
    return DailySummaryResult(
      date: date,
      totalTransactions: txList.length,
      totalRevenue: rev,
      totalRevenueUSD: revUSD,
    );
  }

  Future<WeeklySummaryResult> getWeeklySummary(DateTime weekStart) async {
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = start.add(const Duration(days: 7));
    
    final txList = await (select(transactions)
          ..where((tbl) => tbl.transactionDate.isBetweenValues(start, end) & tbl.status.equals('completed')))
        .get();
        
    double rev = 0;
    double revUSD = 0;
    for (final tx in txList) {
      rev += tx.totalAmount;
      revUSD += tx.totalAmountUSD;
    }
    
    return WeeklySummaryResult(
      totalTransactions: txList.length,
      totalRevenue: rev,
      totalRevenueUSD: revUSD,
    );
  }

  Future<List<TopProductResult>> getTopProducts(DateTime start, DateTime end, int limit) async {
    // Basic implementation since drift custom queries require more complex setup:
    final query = customSelect(
      '''
      SELECT productId, SUM(quantity) as qty, SUM(subtotal) as rev
      FROM transaction_items
      INNER JOIN transactions ON transactions.id = transaction_items.transactionId
      WHERE transactions.transactionDate BETWEEN ? AND ?
        AND transactions.status = 'completed'
      GROUP BY productId
      ORDER BY qty DESC
      LIMIT ?
      ''',
      variables: [
        Variable.withDateTime(start),
        Variable.withDateTime(end),
        Variable.withInt(limit),
      ],
      readsFrom: {transactionItems, transactions},
    );
    
    final rows = await query.get();
    return rows.map((row) {
      return TopProductResult(
        productId: row.read<String>('productId'),
        quantitySold: row.read<double>('qty'),
        totalRevenue: row.read<double>('rev'),
      );
    }).toList();
  }

  Future<void> voidTransaction(String id, String staffId) async {
    return db.transaction(() async {
      await (update(transactions)..where((t) => t.id.equals(id)))
          .write(const TransactionsCompanion(status: Value('voided'), isSynced: Value(false)));
      
      final items = await (select(transactionItems)..where((t) => t.transactionId.equals(id))).get();
      for (final item in items) {
        // Reverse stock
        await customUpdate(
          'UPDATE products SET stock = stock + ? WHERE id = ?',
          variables: [Variable.withReal(item.quantity), Variable.withString(item.productId)],
          updates: {products},
        );
        
        final p = await (select(products)..where((tbl) => tbl.id.equals(item.productId))).getSingle();
        // Insert log
        await into(inventoryLogs).insert(InventoryLogsCompanion(
          id: Value(_uuid.v4()),
          productId: Value(item.productId),
          changeAmount: Value(item.quantity),
          stockBefore: Value(p.stock - item.quantity),
          stockAfter: Value(p.stock),
          reason: const Value('return'),
          referenceId: Value(id),
          staffId: Value(staffId),
        ),);
      }
    });
  }

  Stream<List<TransactionModel>> watchUnsyncedTransactions() {
    return (select(transactions)..where((tbl) => tbl.isSynced.equals(false))).watch();
  }
}
