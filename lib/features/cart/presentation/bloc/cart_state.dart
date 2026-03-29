import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/cart_item.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {}

final class CartLoaded extends CartState {

  const CartLoaded({
    required this.items,
    required this.subtotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.total,
    required this.totalUSD,
    required this.changeAmount,
    this.customer,
    this.discountType,
    this.discountValue,
    this.isCheckingOut = false,
    this.stockWarnings,
  });
  final List<CartItem> items;
  final double subtotal;
  final double discountAmount;
  final double taxAmount;
  final double total;
  final double totalUSD;
  final double changeAmount;
  final Customer? customer;
  final DiscountType? discountType;
  final double? discountValue;
  final bool isCheckingOut;
  final Map<String, String>? stockWarnings;

  CartLoaded copyWith({
    List<CartItem>? items,
    double? subtotal,
    double? discountAmount,
    double? taxAmount,
    double? total,
    double? totalUSD,
    double? changeAmount,
    Customer? customer,
    DiscountType? discountType,
    double? discountValue,
    bool? isCheckingOut,
    Map<String, String>? stockWarnings,
    bool clearCustomer = false,
    bool clearDiscount = false,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      total: total ?? this.total,
      totalUSD: totalUSD ?? this.totalUSD,
      changeAmount: changeAmount ?? this.changeAmount,
      customer: clearCustomer ? null : (customer ?? this.customer),
      discountType: clearDiscount ? null : (discountType ?? this.discountType),
      discountValue: clearDiscount ? null : (discountValue ?? this.discountValue),
      isCheckingOut: isCheckingOut ?? this.isCheckingOut,
      stockWarnings: stockWarnings ?? this.stockWarnings,
    );
  }

  @override
  List<Object?> get props => [
        items,
        subtotal,
        discountAmount,
        taxAmount,
        total,
        totalUSD,
        changeAmount,
        customer,
        discountType,
        discountValue,
        isCheckingOut,
        stockWarnings,
      ];
}

final class CartCheckoutSuccess extends CartState {

  const CartCheckoutSuccess({
    required this.transactionId,
    required this.receiptNumber,
    required this.totalAmount,
    required this.totalAmountUSD,
    required this.paymentMethod,
    required this.completedAt,
    required this.staffName,
  });
  final String transactionId;
  final String receiptNumber;
  final double totalAmount;
  final double totalAmountUSD;
  final PaymentMethod paymentMethod;
  final DateTime completedAt;
  final String staffName;

  @override
  List<Object?> get props => [
        transactionId,
        receiptNumber,
        totalAmount,
        totalAmountUSD,
        paymentMethod,
        completedAt,
        staffName,
      ];
}

final class CartCheckoutFailure extends CartState {

  const CartCheckoutFailure({required this.failure});
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
