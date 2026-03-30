import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/inventory_log.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();

  @override
  List<Object?> get props => [];
}

final class InventoryInitial extends InventoryState {}

final class InventoryLoading extends InventoryState {}

final class InventoryLoaded extends InventoryState {
  const InventoryLoaded({
    required this.logs,
    required this.lowStockItems,
    this.selectedProduct,
  });
  final List<InventoryLog> logs;
  final List<Product> lowStockItems;
  final Product? selectedProduct;

  InventoryLoaded copyWith({
    List<InventoryLog>? logs,
    List<Product>? lowStockItems,
    Product? selectedProduct,
    bool clearSelectedProduct = false,
  }) {
    return InventoryLoaded(
      logs: logs ?? this.logs,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      selectedProduct: clearSelectedProduct
          ? null
          : (selectedProduct ?? this.selectedProduct),
    );
  }

  @override
  List<Object?> get props => [logs, lowStockItems, selectedProduct];
}

final class StockAdjusted extends InventoryState {
  const StockAdjusted({
    required this.updatedProduct,
    required this.previousStock,
  });
  final Product updatedProduct;
  final double previousStock;

  @override
  List<Object?> get props => [updatedProduct, previousStock];
}

final class InventoryError extends InventoryState {
  const InventoryError({required this.failure});
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
