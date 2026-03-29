import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/inventory_log.dart';

abstract class InventoryRepository {
  Stream<Either<Failure, List<InventoryLog>>> watchProductHistory(String productId);
  Future<Either<Failure, void>> adjustStock({
    required String productId,
    required double quantity,
    required String reason,
    required String staffId,
    String? notes,
  });
}
