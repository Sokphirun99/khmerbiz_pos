import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:uuid/uuid.dart';

part 'inventory_dao.g.dart';

@DriftAccessor(tables: [InventoryLogs, Products])
class InventoryDao extends DatabaseAccessor<AppDatabase> with _$InventoryDaoMixin {
  InventoryDao(super.db);
  
  final Uuid _uuid = const Uuid();

  Stream<List<InventoryLogModel>> watchProductHistory(String productId) {
    return (select(inventoryLogs)
          ..where((tbl) => tbl.productId.equals(productId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  Future<void> adjustStock({
    required String productId,
    required double quantity, // delta
    required String reason,
    required String staffId,
    String? notes,
  }) async {
    return db.transaction(() async {
      // atomic: fetch current stock, insert log, update product stock
      final currentProduct = await (select(products)..where((tbl) => tbl.id.equals(productId))).getSingle();
      
      final stockBefore = currentProduct.stock;
      final stockAfter = stockBefore + quantity;
      
      // Update
      await (update(products)..where((tbl) => tbl.id.equals(productId)))
          .write(ProductsCompanion(stock: Value(stockAfter)));
          
      // Log
      await into(inventoryLogs).insert(InventoryLogsCompanion(
        id: Value(_uuid.v4()),
        productId: Value(productId),
        changeAmount: Value(quantity),
        stockBefore: Value(stockBefore),
        stockAfter: Value(stockAfter),
        reason: Value(reason),
        staffId: Value(staffId),
        notes: Value(notes),
        timestamp: Value(DateTime.now()),
      ),);
    });
  }
}
