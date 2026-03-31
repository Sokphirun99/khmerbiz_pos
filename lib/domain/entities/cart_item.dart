import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/modifier.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

/// Represents an item in the shopping cart.
///
/// Includes quantities, prices, and applied modifiers.
class CartItem extends Equatable {
  /// Creates a [CartItem].
  const CartItem({
    required this.id,
    required this.productId,
    required this.product,
    required this.quantity,
    required this.unitPrice,
    required this.costPrice,
    this.modifiers = const [],
  });

  /// Unique temporary ID for the cart line item.
  final String id;

  /// ID of the associated product.
  final String productId;

  /// Full product entity for easy access to names and images.
  final Product product;

  /// Quantity of the product in the cart.
  final double quantity;

  /// The unit price at the time of adding to cart (may differ from current price).
  final double unitPrice;

  /// The cost price at the time of adding to cart.
  final double costPrice;

  /// List of modifiers (e.g., "extra ice", "no sugar") applied to this item.
  final List<Modifier> modifiers;

  /// Calculates the total cost of all applied [modifiers].
  double get modifierTotal => modifiers.fold(0, (sum, m) => sum + m.price);

  /// Calculates the total line amount including base price and modifiers.
  double get lineTotal => (unitPrice * quantity) + modifierTotal;

  /// Creates a copy of this [CartItem] with the given fields replaced.
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
