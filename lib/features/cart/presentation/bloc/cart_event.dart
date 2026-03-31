import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';
import 'package:khmerbiz_pos/domain/entities/modifier.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

/// Base class for all cart-related events.
sealed class CartEvent extends Equatable {
  /// Creates a [CartEvent].
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Event to add a product to the cart.
final class AddToCart extends CartEvent {
  /// Creates an [AddToCart] event.
  const AddToCart({required this.product, this.quantity = 1.0});

  /// The product to be added.
  final Product product;

  /// The initial quantity of the product.
  final double quantity;

  @override
  List<Object?> get props => [product, quantity];
}

/// Event to remove a specific product from the cart.
final class RemoveFromCart extends CartEvent {
  /// Creates a [RemoveFromCart] event.
  const RemoveFromCart({required this.productId});

  /// The unique ID of the product to remove.
  final String productId;

  @override
  List<Object?> get props => [productId];
}

/// Event to update the quantity of an item already in the cart.
final class UpdateQuantity extends CartEvent {
  /// Creates an [UpdateQuantity] event.
  const UpdateQuantity({required this.productId, required this.quantity});

  /// The unique ID of the product.
  final String productId;

  /// The new quantity value.
  final double quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

/// Event to update applied modifiers for a cart item.
final class UpdateModifiers extends CartEvent {
  /// Creates an [UpdateModifiers] event.
  const UpdateModifiers({required this.productId, required this.modifiers});

  /// The unique ID of the product.
  final String productId;

  /// The list of selected modifiers.
  final List<Modifier> modifiers;

  @override
  List<Object?> get props => [productId, modifiers];
}

/// Event to apply a discount to the entire cart.
final class ApplyDiscount extends CartEvent {
  /// Creates an [ApplyDiscount] event.
  const ApplyDiscount({required this.type, required this.value});

  /// The type of discount (percentage or fixed).
  final DiscountType type;

  /// The discount value.
  final double value;

  @override
  List<Object?> get props => [type, value];
}

/// Event to remove any applied discount from the cart.
final class RemoveDiscount extends CartEvent {}

/// Event to associate a customer with the current cart.
final class SetCustomer extends CartEvent {
  /// Creates a [SetCustomer] event.
  const SetCustomer({this.customer});

  /// The customer to associate. If null, the customer is removed.
  final Customer? customer;

  @override
  List<Object?> get props => [customer];
}

/// Event to clear all items and reset the cart.
final class ClearCart extends CartEvent {}

/// Event to trigger the checkout process.
final class ProcessCheckout extends CartEvent {
  /// Creates a [ProcessCheckout] event.
  const ProcessCheckout({
    required this.method,
    this.cashReceived,
    this.khqrReference,
    this.khqrMd5,
  });

  /// The chosen payment method.
  final PaymentMethod method;

  /// The amount of physical cash received from the customer (for cash payments).
  final double? cashReceived;

  /// The reference code for a KHQR transaction.
  final String? khqrReference;

  /// The MD5 hash of the KHQR transaction payload, used for verification.
  final String? khqrMd5;

  @override
  List<Object?> get props => [method, cashReceived, khqrReference, khqrMd5];
}
