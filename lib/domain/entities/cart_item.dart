import 'package:equatable/equatable.dart';
import 'product.dart';
import 'modifier.dart';

class CartItem extends Equatable {
  final String id;
  final String productId;
  final Product product;
  final double quantity;
  final double unitPrice;
  final double costPrice;
  final List<Modifier> modifiers;

  const CartItem({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    this.modifiers = const [],
  });
  
  double get modifierTotal => modifiers.fold(0.0, (sum, m) => sum + m.price);
  double get lineTotal => (unitPrice * quantity) + modifierTotal;

  CartItem copyWith({
    String? id,
    String? productId,
    Product? product,
    double? quantity,
    double? unitPrice,
    double? costPrice,
    List<Modifier>? modifiers,
  }) {
    return CartItem(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      costPrice: costPrice ?? this.costPrice,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  @override
  List<Object?> get props => [
        id,
        productId,
        product,
        quantity,
        unitPrice,
        costPrice,
        modifiers,
      ];
}
