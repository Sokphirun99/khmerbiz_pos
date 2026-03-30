import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:uuid/uuid.dart';

part 'inventory_dao.g.dart';

@DriftAccessor(tables: [InventoryLogs, Products])
class InventoryDao extends DatabaseAccessor<AppDatabase>
    with _$InventoryDaoMixin {
  InventoryDao(super.db);

  final Uuid _uuid = const Uuid();

  Stream<List<InventoryLogModel>> watchProductHistory(String productId) {
    return (select(inventoryLogs)
          ..where((tbl) => tbl.productId.equals(productId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  Future<List<InventoryLogModel>> getInventoryLogs({
    String? productId,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final query = select(inventoryLogs)
      ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]);

    if (productId != null) {
      query.where((tbl) => tbl.productId.equals(productId));
    }
    if (startDate != null) {
      query.where(
          (tbl) => tbl.timestamp.isBiggerOrEqualValue(startDate));
    }
    if (endDate != null) {
      query.where(
          (tbl) => tbl.timestamp.isSmallerOrEqualValue(endDate));
    }

    return query.get();
  }

  Future<List<ProductModel>> getLowStockProducts() {
    return (select(products)
          ..where(
            (tbl) =>
                tbl.isActive.equals(true) &
                tbl.stock.isSmallerOrEqual(tbl.lowStockThreshold),
          ))
        .get();
  }

  Future<void> adjustStock({
    required String productId,
    required double quantity,
    required String reason,
    required String staffId,
    String? notes,
  }) async {
    return db.transaction(() async {
      final currentProduct = await (select(products)
            ..where((tbl) => tbl.id.equals(productId)))
          .getSingle();

      final stockBefore = currentProduct.stock;
      final stockAfter = stockBefore + quantity;

      await (update(products)..where((tbl) => tbl.id.equals(productId)))
          .write(ProductsCompanion(
        stock: Value(stockAfter),
        updatedAt: Value(DateTime.now()),
      ));

      await into(inventoryLogs).insert(
        InventoryLogsCompanion(
          id: Value(_uuid.v4()),
          productId: Value(productId),
          changeAmount: Value(quantity),
          stockBefore: Value(stockBefore),
          stockAfter: Value(stockAfter),
          reason: Value(reason),
          staffId: Value(staffId),
          notes: Value(notes),
          timestamp: Value(DateTime.now()),
        ),
      );
    });
  }
}
