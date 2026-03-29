import 'package:equatable/equatable.dart';
import '../../../../domain/entities/product.dart';
import '../../../../domain/entities/modifier.dart';
import '../../../../domain/entities/customer.dart';
import '../../../../domain/entities/checkout_enums.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class AddToCart extends CartEvent {
  final Product product;
  final double quantity;

  const AddToCart({required this.product, this.quantity = 1.0});

  @override
  List<Object?> get props => [product, quantity];
}

final class RemoveFromCart extends CartEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final class UpdateQuantity extends CartEvent {
  final String productId;
  final double quantity;

  const UpdateQuantity({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

final class UpdateModifiers extends CartEvent {
  final String productId;
  final List<Modifier> modifiers;

  const UpdateModifiers({required this.productId, required this.modifiers});

  @override
  List<Object?> get props => [productId, modifiers];
}

final class ApplyDiscount extends CartEvent {
  final DiscountType type;
  final double value;

  const ApplyDiscount({required this.type, required this.value});

  @override
  List<Object?> get props => [type, value];
}

final class RemoveDiscount extends CartEvent {}

final class SetCustomer extends CartEvent {
  final Customer? customer;

  const SetCustomer({this.customer});

  @override
  List<Object?> get props => [customer];
}

final class ClearCart extends CartEvent {}

final class ProcessCheckout extends CartEvent {
  final PaymentMethod method;
  final double? cashReceived;

  const ProcessCheckout({required this.method, this.cashReceived});

  @override
  List<Object?> get props => [method, cashReceived];
}
