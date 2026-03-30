import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/adjustment_reason.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();

  @override
  List<Object?> get props => [];
}

/// Load inventory log, optionally filtered by product and/or date range.
final class LoadInventoryLog extends InventoryEvent {
  const LoadInventoryLog({this.productId, this.startDate, this.endDate});
  final String? productId;
  final DateTime? startDate;
  final DateTime? endDate;

  @override
  List<Object?> get props => [productId, startDate, endDate];
}

/// Adjust stock for a product.
final class AdjustStock extends InventoryEvent {
  const AdjustStock({
    required this.productId,
    required this.quantity,
    required this.reason,
    this.notes,
  });
  final String productId;
  final double quantity;
  final AdjustmentReason reason;
  final String? notes;

  @override
  List<Object?> get props => [productId, quantity, reason, notes];
}

/// Load the low stock report.
final class LoadLowStockReport extends InventoryEvent {}

/// Bulk import stock adjustments.
final class BulkImportStock extends InventoryEvent {
  const BulkImportStock({required this.items});
  final List<StockImportItem> items;

  @override
  List<Object?> get props => [items];
}

/// A single item in a bulk stock import.
class StockImportItem extends Equatable {
  const StockImportItem({
    required this.productId,
    required this.quantity,
    required this.reason,
    this.notes,
  });
  final String productId;
  final double quantity;
  final AdjustmentReason reason;
  final String? notes;

  @override
  List<Object?> get props => [productId, quantity, reason, notes];
}
