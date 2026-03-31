import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/inventory_log.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

/// Base class for all inventory-related states.
sealed class InventoryState extends Equatable {
  /// Creates an [InventoryState].
  const InventoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the inventory feature.
final class InventoryInitial extends InventoryState {}

/// State indicating that inventory data is being loaded.
final class InventoryLoading extends InventoryState {}

/// State when inventory data has been successfully loaded.
final class InventoryLoaded extends InventoryState {
  /// Creates an [InventoryLoaded] state.
  const InventoryLoaded({
    required this.logs,
    required this.lowStockItems,
    this.selectedProduct,
  });

  /// The list of inventory logs/history.
  final List<InventoryLog> logs;

  /// The list of products that are currently low on stock.
  final List<Product> lowStockItems;

  /// The currently selected product for stock adjustment.
  final Product? selectedProduct;

  @override
  List<Object?> get props => [logs, lowStockItems, selectedProduct];

  /// Creates a copy of this state with the given fields replaced by the new values.
  InventoryLoaded copyWith({
    List<InventoryLog>? logs,
    List<Product>? lowStockItems,
    Product? selectedProduct,
    bool clearSelectedProduct = false,
  }) {
    return InventoryLoaded(
      logs: logs ?? this.logs,
      lowStockItems: lowStockItems ?? this.lowStockItems,
      selectedProduct: clearSelectedProduct ? null : (selectedProduct ?? this.selectedProduct),
    );
  }
}

/// State indicating that a stock adjustment was successful.
final class StockAdjusted extends InventoryState {
  /// Creates a [StockAdjusted] state.
  const StockAdjusted({required this.updatedProduct, required this.previousStock});

  /// The product with updated stock values.
  final Product updatedProduct;

  /// The stock level before the adjustment.
  final double previousStock;

  @override
  List<Object?> get props => [updatedProduct, previousStock];
}

/// State indicating an error occurred in the inventory feature.
final class InventoryError extends InventoryState {
  /// Creates an [InventoryError] state.
  const InventoryError({required this.failure});

  /// The failure that caused the error.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
