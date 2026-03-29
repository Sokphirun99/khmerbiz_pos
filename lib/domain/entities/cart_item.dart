import 'package:equatable/equatable.dart';
import 'product.dart';
import 'modifier.dart';

class CartItem extends Equatable {
  final String id;
  final Product product;
  final double quantity;
  final double discountAmount;
  final List<Modifier> modifiers;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.discountAmount = 0,
    this.modifiers = const [],
  });
  
  double get unitPrice => product.retailPrice;
  double get subtotal => (unitPrice * quantity) - discountAmount + modifiers.fold(0.0, (sum, m) => sum + m.price);

  @override
  List<Object?> get props => [
        id,
        product,
        quantity,
        discountAmount,
        modifiers,
      ];
}
