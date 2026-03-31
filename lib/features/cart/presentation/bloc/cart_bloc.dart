import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/cart_item.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart' as entity_tx;
import 'package:khmerbiz_pos/domain/entities/transaction_item.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_event.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_state.dart';
import 'package:uuid/uuid.dart';

/// Bloc responsible for managing the shopping cart state.
///
/// Handles adding/removing items, updating quantities, applying discounts,
/// and processing the checkout transaction.
class CartBloc extends Bloc<CartEvent, CartState> {
  /// Creates a [CartBloc] with the required repositories.
  CartBloc({
    required TransactionRepository transactionRepository,
    required ProductRepository productRepository,
    required AuthRepository authRepository,
    required ExchangeRateRepository exchangeRateRepository,
  })  : _transactionRepository = transactionRepository,
        _productRepository = productRepository,
        _authRepository = authRepository,
        _exchangeRateRepository = exchangeRateRepository,
        super(const CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<UpdateModifiers>(_onUpdateModifiers);
    on<ApplyDiscount>(_onApplyDiscount);
    on<RemoveDiscount>(_onRemoveDiscount);
    on<SetCustomer>(_onSetCustomer);
    on<ClearCart>(_onClearCart);
    on<ProcessCheckout>(_onProcessCheckout);
  }
  final TransactionRepository _transactionRepository;
  final ProductRepository _productRepository;
  final AuthRepository _authRepository;
  final ExchangeRateRepository _exchangeRateRepository;
  final Uuid _uuid = const Uuid();

  void _onAddToCart(AddToCart event, Emitter<CartState> emit) {
    final currentState =
        state is CartLoaded ? state as CartLoaded : _getEmptyCart();

    final updatedItems = List<CartItem>.from(currentState.items);
    final updatedWarnings =
        Map<String, String>.from(currentState.stockWarnings ?? {});

    final existingIndex =
        updatedItems.indexWhere((item) => item.productId == event.product.id);
    var newQuantity = event.quantity;

    if (existingIndex >= 0) {
      newQuantity += updatedItems[existingIndex].quantity;
      updatedItems[existingIndex] = updatedItems[existingIndex].copyWith(
        quantity: newQuantity,
      );
    } else {
      updatedItems.add(
        CartItem(
          id: _uuid.v4(),
          productId: event.product.id,
          product: event.product,
          quantity: newQuantity,
          unitPrice: event.product.retailPrice,
          costPrice: event.product.costPrice,
        ),
      );
    }

    if (event.product.stock == 0) {
      updatedWarnings[event.product.id] = 'Out of stock';
    } else if (event.product.stock < newQuantity) {
      updatedWarnings[event.product.id] = 'Only ${event.product.stock} left';
    } else {
      updatedWarnings.remove(event.product.id);
    }

    _emitRecalculatedCart(emit, currentState, updatedItems, updatedWarnings);
  }

  void _onRemoveFromCart(RemoveFromCart event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    final updatedItems = currentState.items
        .where((item) => item.productId != event.productId)
        .toList();
    final updatedWarnings =
        Map<String, String>.from(currentState.stockWarnings ?? {});
    updatedWarnings.remove(event.productId);

    if (updatedItems.isEmpty) {
      emit(const CartInitial());
      return;
    }

    _emitRecalculatedCart(emit, currentState, updatedItems, updatedWarnings);
  }

  void _onUpdateQuantity(UpdateQuantity event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    if (event.quantity <= 0) {
      add(RemoveFromCart(productId: event.productId));
      return;
    }

    final updatedItems = List<CartItem>.from(currentState.items);
    final updatedWarnings =
        Map<String, String>.from(currentState.stockWarnings ?? {});

    final index =
        updatedItems.indexWhere((item) => item.productId == event.productId);
    if (index >= 0) {
      final product = updatedItems[index].product;
      updatedItems[index] =
          updatedItems[index].copyWith(quantity: event.quantity);

      if (product.stock == 0) {
        updatedWarnings[product.id] = 'Out of stock';
      } else if (product.stock < event.quantity) {
        updatedWarnings[product.id] = 'Only ${product.stock} left';
      } else {
        updatedWarnings.remove(product.id);
      }
    }

    _emitRecalculatedCart(emit, currentState, updatedItems, updatedWarnings);
  }

  void _onUpdateModifiers(UpdateModifiers event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    final updatedItems = List<CartItem>.from(currentState.items);
    final index =
        updatedItems.indexWhere((item) => item.productId == event.productId);
    if (index >= 0) {
      updatedItems[index] =
          updatedItems[index].copyWith(modifiers: event.modifiers);
    }

    _emitRecalculatedCart(
        emit, currentState, updatedItems, currentState.stockWarnings,);
  }

  void _onApplyDiscount(ApplyDiscount event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    _emitRecalculatedCart(
      emit,
      currentState.copyWith(
        discountType: event.type,
        discountValue: event.value,
      ),
      currentState.items,
      currentState.stockWarnings,
    );
  }

  void _onRemoveDiscount(RemoveDiscount event, Emitter<CartState> emit) {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    _emitRecalculatedCart(
      emit,
      currentState.copyWith(clearDiscount: true),
      currentState.items,
      currentState.stockWarnings,
    );
  }

  void _onSetCustomer(SetCustomer event, Emitter<CartState> emit) {
    if (state is! CartLoaded) {
      if (event.customer == null) return;
      emit(_getEmptyCart().copyWith(customer: event.customer));
      return;
    }
    final currentState = state as CartLoaded;
    emit(currentState.copyWith(
        customer: event.customer, clearCustomer: event.customer == null,),);
  }

  void _onClearCart(ClearCart event, Emitter<CartState> emit) {
    emit(const CartInitial());
  }

  Future<void> _onProcessCheckout(
      ProcessCheckout event, Emitter<CartState> emit,) async {
    if (state is! CartLoaded) return;
    final currentState = state as CartLoaded;

    if (currentState.items.isEmpty) {
      emit(CartCheckoutFailure(
          failure: ValidationFailure.custom(
              messageEn: 'Cart is empty', messageKm: 'រទេះទទេ',),),);
      return;
    }

    if (event.method == PaymentMethod.cash) {
      if (event.cashReceived == null ||
          event.cashReceived! < currentState.total) {
        emit(CartCheckoutFailure(
            failure: ValidationFailure.custom(
                messageEn: 'Insufficient cash received',
                messageKm: 'ប្រាក់ទទួលមិនគ្រប់គ្រាន់',),),);
        return;
      }
    }

    emit(currentState.copyWith(isCheckingOut: true));

    // Re-verify stock
    final productIds = currentState.items.map((item) => item.productId).toList();
    final productsResult =
        await _productRepository.getProductsByIds(productIds);

    final errorMessagesEn = <String>[];
    final errorMessagesKm = <String>[];

    productsResult.fold(
      (failure) {
        errorMessagesEn.add('Error verifying stock');
        errorMessagesKm.add('មានបញ្ហាក្នុងការត្រួតពិនិត្យស្តុក');
      },
      (products) {
        final productMap = {for (final p in products) p.id: p};

        for (final item in currentState.items) {
          final product = productMap[item.productId];
          final stockSufficient = product != null && product.stock >= item.quantity;

          if (!stockSufficient) {
            errorMessagesEn.add('Insufficient stock for ${item.product.nameEn}');
            errorMessagesKm.add('ស្តុកមិនគ្រប់គ្រាន់សម្រាប់ ${item.product.nameKh}');
          }
        }
      },
    );

    if (errorMessagesEn.isNotEmpty) {
      emit(
        CartCheckoutFailure(
          failure: ValidationFailure.custom(
            messageEn: errorMessagesEn.join(', '),
            messageKm: errorMessagesKm.join(', '),
          ),
        ),
      );
      emit(currentState.copyWith(isCheckingOut: false));
      return;
    }

    // Get current user for staff info
    final userResult = await _authRepository.getCurrentUser();
    final staffId = userResult.fold((l) => 'unknown', (u) => u.id);
    final staffName =
        userResult.fold((l) => 'Unknown Staff', (u) => u.fullNameEn);

    final transactionId = _uuid.v4();
    final receiptNumber = _generateReceiptNumber();
    final now = DateTime.now();

    final tx = entity_tx.Transaction(
      id: transactionId,
      receiptNumber: receiptNumber,
      transactionDate: now,
      staffId: staffId,
      customerId: currentState.customer?.id,
      subtotal: currentState.subtotal,
      discountType: currentState.discountType?.name,
      discountValue: currentState.discountValue ?? 0,
      discountAmount: currentState.discountAmount,
      taxAmount: currentState.taxAmount,
      totalAmount: currentState.total,
      totalAmountUSD: currentState.totalUSD,
      paymentMethod: event.method.name,
      cashReceived: event.cashReceived,
      changeGiven:
          currentState.changeAmount > 0 ? currentState.changeAmount : 0,
      createdAt: now,
    );

    final txItems = currentState.items.map((item) {
      return TransactionItem(
        id: _uuid.v4(),
        transactionId: transactionId,
        productId: item.productId,
        productNameSnapshot: item.product.nameKh,
        productNameEnSnapshot: item.product.nameEn,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        costPrice: item.costPrice,
        subtotal: item.lineTotal,
        modifiers: item.modifiers.isEmpty
            ? null
            : jsonEncode(item.modifiers.map((m) => m.toJson()).toList()),
      );
    }).toList();

    final result = await _transactionRepository.processSale(
        transaction: tx, items: txItems,);

    result.fold((failure) {
      emit(CartCheckoutFailure(failure: failure));
      emit(currentState.copyWith(isCheckingOut: false));
    }, (id) {
      emit(
        CartCheckoutSuccess(
          transactionId: id,
          receiptNumber: receiptNumber,
          totalAmount: currentState.total,
          totalAmountUSD: currentState.totalUSD,
          paymentMethod: event.method,
          completedAt: now,
          staffName: staffName,
        ),
      );
    });
  }

  void _emitRecalculatedCart(
    Emitter<CartState> emit,
    CartLoaded stateToCalculateFrom,
    List<CartItem> items,
    Map<String, String>? warnings,
  ) {
    double subtotal = 0;
    for (final item in items) {
      subtotal += item.lineTotal;
    }

    double discountAmount = 0;
    if (stateToCalculateFrom.discountType != null &&
        stateToCalculateFrom.discountValue != null) {
      if (stateToCalculateFrom.discountType == DiscountType.percent) {
        discountAmount = subtotal * (stateToCalculateFrom.discountValue! / 100);
      } else {
        discountAmount = stateToCalculateFrom.discountValue!;
      }
    }

    if (discountAmount > subtotal) discountAmount = subtotal;

    final taxable = subtotal - discountAmount;
    final taxAmount = taxable * 0.10; // 10% tax rate
    var total = taxable + taxAmount;

    // Round to 0 decimal places for KHR
    total = total.roundToDouble();

    var exchangeRate = _exchangeRateRepository.getCachedRate();
    if (exchangeRate <= 0) exchangeRate = 4000; // fallback
    final totalUSD = total / exchangeRate;

    // Recalculate change if any cash received is part of state? We don't store cashReceived in state.
    // It's only passed during ProcessCheckout. We will default changeAmount to 0.

    emit(
      stateToCalculateFrom.copyWith(
        items: items,
        subtotal: subtotal,
        discountAmount: discountAmount,
        taxAmount: taxAmount,
        total: total,
        totalUSD: totalUSD,
        changeAmount: 0,
        stockWarnings: warnings,
      ),
    );
  }

  CartLoaded _getEmptyCart() {
    return const CartLoaded(
      items: [],
      subtotal: 0,
      discountAmount: 0,
      taxAmount: 0,
      total: 0,
      totalUSD: 0,
      changeAmount: 0,
    );
  }

  String _generateReceiptNumber() {
    final now = DateTime.now();
    final formatter = DateFormat('yyMMddHHmmss');
    final randomPart = _uuid.v4().substring(0, 4).toUpperCase();
    return 'RCP-${formatter.format(now)}-$randomPart';
  }
}
