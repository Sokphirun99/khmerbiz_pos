import 'package:equatable/equatable.dart';

/// Audit log for inventory changes.
///
/// Tracks stock adjustments, reasons, and associated staff.
class InventoryLog extends Equatable {
  /// Creates an [InventoryLog] record.
  const InventoryLog({
    required this.id,
    required this.productId,
    required this.changeAmount,
    required this.stockBefore,
    required this.stockAfter,
    required this.reason,
    required this.staffId,
    required this.timestamp,
    this.referenceId,
    this.notes,
  });

  /// Unique identifier for the log entry.
  final String id;

  /// ID of the product being adjusted.
  final String productId;

  /// The amount changed (positive for stock-in, negative for stock-out).
  final double changeAmount;

  /// Quantity before the adjustment.
  final double stockBefore;

  /// Quantity after the adjustment.
  final double stockAfter;

  /// The recorded reason/category for adjustment.
  final String reason;

  /// Optional reference to a transaction or order ID.
  final String? referenceId;

  /// ID of the staff member who performed the adjustment.
  final String staffId;

  /// Optional notes about the adjustment.
  final String? notes;

  /// Timestamp when the adjustment occurred.
  final DateTime timestamp;

  @override
  List<Object?> get props => [
        id,
        productId,
        changeAmount,
        stockBefore,
        stockAfter,
        reason,
        referenceId,
        staffId,
        notes,
        timestamp,
      ];
}
