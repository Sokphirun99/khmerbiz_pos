import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/adjustment_reason.dart';

/// Base class for all inventory-related events.
sealed class InventoryEvent extends Equatable {
  /// Creates an [InventoryEvent].
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load inventory transaction logs.
final class LoadInventoryLog extends InventoryEvent {
  /// Creates a [LoadInventoryLog] event.
  const LoadInventoryLog({this.productId, this.startDate, this.endDate});

  /// Optional filter by product ID.
  final String? productId;

  /// Optional start date filter.
  final DateTime? startDate;

  /// Optional end date filter.
  final DateTime? endDate;

  @override
  List<Object?> get props => [productId, startDate, endDate];
}

/// Event to manually adjust the stock level of a product.
final class AdjustStock extends InventoryEvent {
  /// Creates an [AdjustStock] event.
  const AdjustStock({
    required this.productId,
    required this.quantity,
    required this.reason,
    this.staffId,
    this.notes,
  });

  /// The unique ID of the product.
  final String productId;

  /// The quantity of stock to add or subtract.
  final double quantity;

  /// The reason for the adjustment.
  final AdjustmentReason reason;

  /// The ID of the staff member performing the adjustment.
  final String? staffId;

  /// Optional notes regarding the adjustment.
  final String? notes;

  @override
  List<Object?> get props => [productId, quantity, reason, staffId, notes];
}

/// Event to fetch a report of all products currently below their minimum stock level.
final class LoadLowStockReport extends InventoryEvent {}

/// Event to perform a bulk stock adjustment from a list of items.
final class BulkImportStock extends InventoryEvent {
  /// Creates a [BulkImportStock] event.
  const BulkImportStock({required this.items});

  /// The list of items to import.
  final List<StockImportItem> items;

  @override
  List<Object?> get props => [items];
}

/// Represents a single item in a bulk stock import operation.
class StockImportItem extends Equatable {
  /// Creates a [StockImportItem].
  const StockImportItem({
    required this.barcode,
    required this.quantity,
  });

  /// The barcode of the product.
  final String barcode;

  /// The quantity to adjust.
  final double quantity;

  @override
  List<Object?> get props => [barcode, quantity];
}
