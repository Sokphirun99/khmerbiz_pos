import 'package:equatable/equatable.dart';

class TransactionItem extends Equatable {

  const TransactionItem({
    required this.id,
    required this.transactionId,
    required this.productId,
    required this.productNameSnapshot,
    required this.productNameEnSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    required this.subtotal, this.discountAmount = 0,
    this.modifiers,
  });
  final String id;
  final String transactionId;
  final String productId;
  final String productNameSnapshot;
  final String productNameEnSnapshot;
  final double quantity;
  final double unitPrice;
  final double costPrice;
  final double discountAmount;
  final double subtotal;
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
