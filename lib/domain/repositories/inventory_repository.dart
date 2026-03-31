import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/inventory_log.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

/// Repository interface for inventory management and stock tracking.
abstract class InventoryRepository {
  /// Watch inventory history for a specific product.
  Stream<Either<Failure, List<InventoryLog>>> watchProductHistory(
      String productId,);

  /// Load inventory logs with optional filters.
  Future<Either<Failure, List<InventoryLog>>> getInventoryLogs({
    String? productId,
    DateTime? startDate,
    DateTime? endDate,
  });

  /// Adjust stock for a product with reason tracking.
  Future<Either<Failure, void>> adjustStock({
    required String productId,
    required double quantity,
    required String reason,
    required String staffId,
    String? notes,
  });

  /// Get all products that are at or below their low stock threshold.
  Future<Either<Failure, List<Product>>> getLowStockProducts();
}
