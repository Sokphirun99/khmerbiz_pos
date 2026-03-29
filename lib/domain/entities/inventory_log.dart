import 'package:equatable/equatable.dart';

class InventoryLog extends Equatable {
  final String id;
  final String productId;
  final double changeAmount;
  final double stockBefore;
  final double stockAfter;
  final String reason;
  final String? referenceId;
  final String staffId;
  final String? notes;
  final DateTime timestamp;

  const InventoryLog({
    required this.id,
    required this.productId,
    required this.changeAmount,
    required this.stockBefore,
    required this.stockAfter,
    required this.reason,
    this.referenceId,
    required this.staffId,
    this.notes,
    required this.timestamp,
  });

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
