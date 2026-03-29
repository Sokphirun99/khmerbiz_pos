import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/features/products/domain/product.dart';

/// Cart item representing a product added to the cart.
final class CartItem extends Equatable {
  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    required this.addedAt,
    this.priceOverride,
    this.discountAmount = 0,
    this.notes,
  });

  /// Unique cart item identifier
  final String id;

  /// Product in the cart
  final Product product;

  /// Quantity of this product
  final int quantity;

  /// Custom price override (optional)
  final double? priceOverride;

  /// Discount amount in KHR
  final double discountAmount;

  /// Notes for this item (e.g., "no ice", "extra sugar")
  final String? notes;

  /// When the item was added to cart
  final DateTime addedAt;

  /// Get the unit price (override or product price)
  double get unitPrice => priceOverride ?? product.priceKhr;

  /// Get total price for this item (before discount)
  double get subtotal => unitPrice * quantity;

  /// Get total price after discount
  double get total => subtotal - discountAmount;

  /// Get effective price per unit after discount
  double get effectiveUnitPrice => total / quantity;

  /// Check if item has discount
  bool get hasDiscount => discountAmount > 0;

  /// Create a copy with updated quantity
  CartItem withQuantity(int newQuantity) {
    return copyWith(quantity: newQuantity);
  }

  /// Create a copy with updated notes
  CartItem withNotes(String? newNotes) {
    return copyWith(notes: newNotes);
  }

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    double? priceOverride,
    double? discountAmount,
    String? notes,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      priceOverride: priceOverride ?? this.priceOverride,
      discountAmount: discountAmount ?? this.discountAmount,
      notes: notes ?? this.notes,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        product,
        quantity,
        priceOverride,
        discountAmount,
        notes,
        addedAt,
      ];
}

/// Shopping cart containing items for current transaction.
final class Cart extends Equatable {
  const Cart({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.updatedAt,
    this.customerId,
    this.discountAmount = 0,
    this.discountPercent,
    this.taxRate,
    this.notes,
  });

  /// Unique cart identifier
  final String id;

  /// Items in the cart
  final List<CartItem> items;

  /// Customer ID (optional)
  final String? customerId;

  /// Cart-wide discount in KHR
  final double discountAmount;

  /// Discount percentage (optional)
  final double? discountPercent;

  /// Tax rate percentage
  final double? taxRate;

  /// Notes for the order
  final String? notes;

  /// When the cart was created
  final DateTime createdAt;

  /// When the cart was last updated
  final DateTime updatedAt;

  /// Get total number of items
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get unique item count
  int get uniqueItemCount => items.length;

  /// Check if cart is empty
  bool get isEmpty => items.isEmpty;

  /// Check if cart is not empty
  bool get isNotEmpty => items.isNotEmpty;

  /// Get subtotal (sum of all item totals)
  double get subtotal {
    return items.fold(0, (sum, item) => sum + item.total);
  }

  double get totalDiscount {
    final itemDiscounts =
        items.fold<double>(0, (sum, item) => sum + item.discountAmount);
    final percentDiscount =
        discountPercent != null ? subtotal * (discountPercent! / 100) : 0.0;
    return itemDiscounts + percentDiscount + discountAmount;
  }

  /// Get taxable amount
  double get taxableAmount {
    return subtotal - totalDiscount;
  }

  /// Get tax amount
  double get taxAmount {
    final rate = taxRate ?? 0.10; // Default 10%
    return taxableAmount * rate;
  }

  /// Get grand total
  double get grandTotal {
    return subtotal - totalDiscount + taxAmount;
  }

  /// Get cart total in USD
  double get grandTotalUsd {
    // Using default exchange rate - will be updated from settings
    return grandTotal / 4100.0;
  }

  /// Find item by product ID
  CartItem? findItemByProductId(String productId) {
    try {
      return items.firstWhere((item) => item.product.id == productId);
    } catch (_) {
      return null;
    }
  }

  /// Check if product is in cart
  bool containsProduct(String productId) {
    return items.any((item) => item.product.id == productId);
  }

  /// Get quantity of product in cart
  int getProductQuantity(String productId) {
    try {
      final item = items.firstWhere((item) => item.product.id == productId);
      return item.quantity;
    } catch (_) {
      return 0;
    }
  }

  /// Add item to cart
  Cart addItem(CartItem newItem) {
    final existingIndex = items.indexWhere(
      (item) => item.product.id == newItem.product.id,
    );

    if (existingIndex >= 0) {
      // Update existing item quantity
      final existingItem = items[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + newItem.quantity,
      );
      final updatedItems = List<CartItem>.from(items)
        ..[existingIndex] = updatedItem;
      return copyWith(
        items: updatedItems,
      );
    } else {
      // Add new item
      return copyWith(
        items: [...items, newItem],
      );
    }
  }

  /// Update item quantity
  Cart updateItemQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      return removeItem(productId);
    }

    final updatedItems = items.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    return copyWith(
      items: updatedItems,
    );
  }

  /// Remove item from cart
  Cart removeItem(String productId) {
    return copyWith(
      items: items.where((item) => item.product.id != productId).toList(),
    );
  }

  /// Clear all items from cart
  Cart clear() {
    return copyWith(
      items: [],
      discountAmount: 0,
    );
  }

  Cart copyWith({
    String? id,
    List<CartItem>? items,
    String? customerId,
    double? discountAmount,
    double? discountPercent,
    double? taxRate,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Cart(
      id: id ?? this.id,
      items: items ?? this.items,
      customerId: customerId ?? this.customerId,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercent: discountPercent ?? this.discountPercent,
      taxRate: taxRate ?? this.taxRate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        items,
        customerId,
        discountAmount,
        discountPercent,
        taxRate,
        notes,
        createdAt,
        updatedAt,
      ];
}
