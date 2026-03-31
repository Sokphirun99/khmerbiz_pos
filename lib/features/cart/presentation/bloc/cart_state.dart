import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/cart_item.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';

/// Base class for all cart-related states.
sealed class CartState extends Equatable {
  /// Creates a [CartState].
  const CartState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the cart.
final class CartInitial extends CartState {
  /// Creates a [CartInitial] state.
  const CartInitial();
}

/// State indicating that the cart has items and calculations are performed.
final class CartLoaded extends CartState {
  /// Creates a [CartLoaded] state.
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

  /// The list of items currently in the cart.
  final List<CartItem> items;

  /// The subtotal before discounts and taxes.
  final double subtotal;

  /// The total discount amount applied.
  final double discountAmount;

  /// The total tax amount applied.
  final double taxAmount;

  /// The final total amount in KHR.
  final double total;

  /// The final total amount in USD.
  final double totalUSD;

  /// The change amount to be returned to the customer.
  final double changeAmount;

  /// The customer associated with the cart, if any.
  final Customer? customer;

  /// The type of discount applied.
  final DiscountType? discountType;

  /// The value of the discount (percentage or fixed amount).
  final double? discountValue;

  /// Whether a checkout operation is currently in progress.
  final bool isCheckingOut;

  /// A map of product IDs to stock warning messages.
  final Map<String, String>? stockWarnings;

  /// Creates a copy of this [CartLoaded] with the given fields replaced.
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
      discountValue:
          clearDiscount ? null : (discountValue ?? this.discountValue),
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

/// State indicating that the checkout was successful.
final class CartCheckoutSuccess extends CartState {
  /// Creates a [CartCheckoutSuccess] state.
  const CartCheckoutSuccess({
    required this.transactionId,
    required this.receiptNumber,
    required this.totalAmount,
    required this.totalAmountUSD,
    required this.paymentMethod,
    required this.completedAt,
    required this.staffName,
  });

  /// The unique ID of the processed transaction.
  final String transactionId;

  /// The human-readable receipt number.
  final String receiptNumber;

  /// The final total amount paid in KHR.
  final double totalAmount;

  /// The final total amount paid in USD.
  final double totalAmountUSD;

  /// The payment method used for the checkout.
  final PaymentMethod paymentMethod;

  /// The timestamp when the checkout was completed.
  final DateTime completedAt;

  /// The name of the staff member who processed the sale.
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

/// State indicating that the checkout process failed.
final class CartCheckoutFailure extends CartState {
  /// Creates a [CartCheckoutFailure] state.
  const CartCheckoutFailure({required this.failure});

  /// The failure that caused the checkout to fail.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
