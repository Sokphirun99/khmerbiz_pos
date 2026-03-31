import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/inventory_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/inventory_log.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/repositories/inventory_repository.dart';

/// Implementation of [InventoryRepository] using [InventoryDao].
///
/// Handles stock adjustments, history tracking, and low stock alerts.
@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  /// Creates a new [InventoryRepositoryImpl] with the given [InventoryDao].
  InventoryRepositoryImpl(this._dao);
  final InventoryDao _dao;

  InventoryLog _mapLogToDomain(InventoryLogModel model) {
    return InventoryLog(
      id: model.id,
      productId: model.productId,
      changeAmount: model.changeAmount,
      stockBefore: model.stockBefore,
      stockAfter: model.stockAfter,
      reason: model.reason,
      referenceId: model.referenceId,
      staffId: model.staffId,
      notes: model.notes,
      timestamp: model.timestamp,
    );
  }

  Product _mapProductToDomain(ProductModel model) {
    return Product(
      id: model.id,
      barcode: model.barcode,
      nameKh: model.nameKh,
      nameEn: model.nameEn,
      categoryId: model.categoryId,
      unit: model.unit,
      costPrice: model.costPrice,
      retailPrice: model.retailPrice,
      wholesalePrice: model.wholesalePrice,
      stock: model.stock,
      reservedStock: model.reservedStock,
      lowStockThreshold: model.lowStockThreshold,
      imagePath: model.imagePath,
      isActive: model.isActive,
      isFeatured: model.isFeatured,
      sortOrder: model.sortOrder,
      updatedAt: model.updatedAt,
      createdAt: model.createdAt,
      remoteId: model.remoteId,
      isSynced: model.isSynced,
    );
  }

  @override
  Stream<Either<Failure, List<InventoryLog>>> watchProductHistory(
      String productId,) {
    return _dao.watchProductHistory(productId).map((models) {
      return right<Failure, List<InventoryLog>>(
          models.map(_mapLogToDomain).toList(),);
    }).handleError((Object err) => left<Failure, List<InventoryLog>>(
        CacheFailure.defaultError(details: err.toString()),),);
  }

  @override
  Future<Either<Failure, List<InventoryLog>>> getInventoryLogs({
    String? productId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final logs = await _dao.getInventoryLogs(
        productId: productId,
        startDate: startDate,
        endDate: endDate,
      );
      return right(logs.map(_mapLogToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> adjustStock({
    required String productId,
    required double quantity,
    required String reason,
    required String staffId,
    String? notes,
  }) async {
    try {
      await _dao.adjustStock(
        productId: productId,
        quantity: quantity,
        reason: reason,
        staffId: staffId,
        notes: notes,
      );
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts() async {
    try {
      final list = await _dao.getLowStockProducts();
      return right(list.map(_mapProductToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }
}
