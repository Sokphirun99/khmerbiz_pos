import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart' show Transaction;

/// Represents a line item within a [Transaction].
///
/// Contains a snapshot of product details at the time of sale.
class TransactionItem extends Equatable {
  /// Creates a [TransactionItem] record.
  const TransactionItem({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.productNameSnapshot,
    required this.productNameEnSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    required this.subtotal,
    this.discountAmount = 0,
    this.modifiers,
  });

  /// Unique identifier for the transaction line item.
  final String id;

  /// ID of the parent transaction.
  final String transactionId;

  /// ID of the product sold.
  final String productId;

  /// Snapshot of the Khmer product name at time of sale.
  final String productNameSnapshot;

  /// Snapshot of the English product name at time of sale.
  final String productNameEnSnapshot;

  /// Quantity sold.
  final double quantity;

  /// The unit price charged (in KHR).
  final double unitPrice;

  /// The cost price recorded (in KHR).
  final double costPrice;

  /// Amount of discount applied to this specific line item.
  final double discountAmount;

  /// Total for this line item (quantity * unitPrice - discountAmount).
  final double subtotal;

  /// JSON-encoded string of modifiers applied to this item.
  final String? modifiers;

  @override
  List<Object?> get props => [
        id,
        transactionId,
        productId,
        productNameSnapshot,
        productNameEnSnapshot,
        quantity,
        unitPrice,
        costPrice,
        discountAmount,
        subtotal,
        modifiers,
      ];
}
