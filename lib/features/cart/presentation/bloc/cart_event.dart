import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/modifier.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

final class AddToCart extends CartEvent {

  const AddToCart({required this.product, this.quantity = 1.0});
  final Product product;
  final double quantity;

  @override
  List<Object?> get props => [product, quantity];
}

final class RemoveFromCart extends CartEvent {

  const RemoveFromCart({required this.productId});
  final String productId;

  @override
  List<Object?> get props => [productId];
}

final class UpdateQuantity extends CartEvent {

  const UpdateQuantity({required this.productId, required this.quantity});
  final String productId;
  final double quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

final class UpdateModifiers extends CartEvent {

  const UpdateModifiers({required this.productId, required this.modifiers});
  final String productId;
  final List<Modifier> modifiers;

  @override
  List<Object?> get props => [productId, modifiers];
}

final class ApplyDiscount extends CartEvent {

  const ApplyDiscount({required this.type, required this.value});
  final DiscountType type;
  final double value;

  @override
  List<Object?> get props => [type, value];
}

final class RemoveDiscount extends CartEvent {}

final class SetCustomer extends CartEvent {

  const SetCustomer({this.customer});
  final Customer? customer;

  @override
  List<Object?> get props => [customer];
}

final class ClearCart extends CartEvent {}

final class ProcessCheckout extends CartEvent {

  const ProcessCheckout({required this.method, this.cashReceived});
  final PaymentMethod method;
  final double? cashReceived;

  @override
  List<Object?> get props => [method, cashReceived];
}
