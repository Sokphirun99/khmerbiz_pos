import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/inventory_log.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/local/database.dart';
import '../datasources/local/daos/inventory_dao.dart';

@LazySingleton(as: InventoryRepository)
class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryDao _dao;

  InventoryRepositoryImpl(this._dao);

  InventoryLog _mapToDomain(InventoryLogModel model) {
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

  @override
  Stream<Either<Failure, List<InventoryLog>>> watchProductHistory(String productId) {
    return _dao.watchProductHistory(productId).map((models) {
      return right<Failure, List<InventoryLog>>(models.map(_mapToDomain).toList());
    }).handleError((err) => left<Failure, List<InventoryLog>>(CacheFailure.defaultError(details: err.toString())));
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
}
