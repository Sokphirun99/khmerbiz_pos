import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';

import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_event.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_state.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/user.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart' as entity_tx;

class MockTransactionRepository extends Mock implements TransactionRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockExchangeRateRepository extends Mock
    implements ExchangeRateRepository {}

class FakeTransaction extends Fake implements entity_tx.Transaction {}

void main() {
  late CartBloc cartBloc;
  late MockTransactionRepository mockTransactionRepository;
  late MockProductRepository mockProductRepository;
  late MockAuthRepository mockAuthRepository;
  late MockExchangeRateRepository mockExchangeRateRepository;

  final testProduct = Product(
    id: 'p1',
    nameKh: 'កាហ្វេ',
    nameEn: 'Coffee',
    retailPrice: 10000,
    costPrice: 5000,
    stock: 10,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  );

  final outOfStockProduct = Product(
    id: 'p2',
    nameKh: 'តែ',
    nameEn: 'Tea',
    retailPrice: 8000,
    costPrice: 4000,
    updatedAt: DateTime.now(),
    createdAt: DateTime.now(),
  );

  final testUser = User(
    id: 'u1',
    username: 'admin',
    fullNameKh: 'រដ្ឋបាល',
    fullNameEn: 'Admin User',
    role: 'admin',
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(FakeTransaction());
  });

  setUp(() {
    mockTransactionRepository = MockTransactionRepository();
    mockProductRepository = MockProductRepository();
    mockAuthRepository = MockAuthRepository();
    mockExchangeRateRepository = MockExchangeRateRepository();

    when(() => mockExchangeRateRepository.getCachedRate()).thenReturn(4000);

    cartBloc = CartBloc(
      transactionRepository: mockTransactionRepository,
      productRepository: mockProductRepository,
      authRepository: mockAuthRepository,
      exchangeRateRepository: mockExchangeRateRepository,
    );
  });

  tearDown(() {
    cartBloc.close();
  });

  group('AddToCart', () {
    blocTest<CartBloc, CartState>(
      'emits [CartLoaded] with new item on happy path',
      build: () => cartBloc,
      act: (bloc) => bloc.add(AddToCart(product: testProduct)),
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.items.length, 'items count', 1)
            .having((s) => s.items.first.productId, 'product id', 'p1')
            .having((s) => s.subtotal, 'subtotal', 10000.0)
            .having(
                (s) => s.stockWarnings?.isEmpty ?? true, 'no warnings', true),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits [CartLoaded] with stock warning when out of stock',
      build: () => cartBloc,
      act: (bloc) => bloc.add(AddToCart(product: outOfStockProduct)),
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.items.length, 'items count', 1)
            .having(
                (s) => s.stockWarnings?.containsKey('p2'), 'has warning', true)
            .having(
                (s) => s.stockWarnings?['p2'], 'warning text', 'Out of stock'),
      ],
    );
  });

  group('ApplyDiscount', () {
    blocTest<CartBloc, CartState>(
      'applies percent discount correctly',
      build: () => cartBloc,
      seed: () {
        // We have to seed a CartLoaded state manually
        // But since seed needs exact state, we'll just act twice
        return CartInitial();
      },
      act: (bloc) {
        bloc.add(AddToCart(product: testProduct)); // 10000
        bloc.add(const ApplyDiscount(
            type: DiscountType.percent, value: 10)); // 10% -> 1000
      },
      skip: 1, // Skip AddToCart state
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.discountAmount, 'discount amount', 1000.0)
            .having((s) => s.taxAmount, 'tax on remaining',
                900.0) // (10000 - 1000) * 0.1
            .having((s) => s.total, 'total', 9900.0),
      ],
    );

    blocTest<CartBloc, CartState>(
      'applies fixed discount correctly',
      build: () => cartBloc,
      act: (bloc) {
        bloc.add(AddToCart(product: testProduct)); // 10000
        bloc.add(const ApplyDiscount(type: DiscountType.fixed, value: 2000));
      },
      skip: 1,
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.discountAmount, 'discount amount', 2000.0)
            .having((s) => s.taxAmount, 'tax', 800.0)
            .having((s) => s.total, 'total', 8800.0),
      ],
    );
  });

  group('ProcessCheckout', () {
    blocTest<CartBloc, CartState>(
      'emits success when all validations pass',
      build: () {
        when(() => mockProductRepository.getProductsByIds(['p1']))
            .thenAnswer((_) async => Right([testProduct]));
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => Right(testUser));
        when(
          () => mockTransactionRepository.processSale(
            transaction: any(named: 'transaction'),
            items: any(named: 'items'),
          ),
        ).thenAnswer((_) async => const Right('txn-123'));

        return cartBloc;
      },
      act: (bloc) {
        bloc.add(AddToCart(product: testProduct));
        bloc.add(const ProcessCheckout(method: PaymentMethod.khqr));
      },
      skip: 1, // Skip AddToCart
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.isCheckingOut, 'is checking out', true),
        isA<CartCheckoutSuccess>()
            .having((s) => s.transactionId, 'txn id', 'txn-123')
            .having((s) => s.totalAmount, 'total amount',
                11000.0), // 10000 + 1000 tax
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits failure when product stock is insufficient during checkout',
      build: () {
        when(() => mockProductRepository.getProductsByIds(['p1'])).thenAnswer(
            (_) async =>
                Right([testProduct.copyWithStock(0)])); // Stale cart vs DB
        return cartBloc;
      },
      act: (bloc) {
        bloc.add(AddToCart(product: testProduct));
        bloc.add(const ProcessCheckout(method: PaymentMethod.khqr));
      },
      skip: 1,
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.isCheckingOut, 'is checking out', true),
        isA<CartCheckoutFailure>(),
        isA<CartLoaded>()
            .having((s) => s.isCheckingOut, 'is checking out', false),
      ],
    );

    blocTest<CartBloc, CartState>(
      'emits failure on DB error during processSale',
      build: () {
        when(() => mockProductRepository.getProductsByIds(['p1']))
            .thenAnswer((_) async => Right([testProduct]));
        when(() => mockAuthRepository.getCurrentUser())
            .thenAnswer((_) async => Right(testUser));
        when(
          () => mockTransactionRepository.processSale(
            transaction: any(named: 'transaction'),
            items: any(named: 'items'),
          ),
        ).thenAnswer(
            (_) async => Left(CacheFailure.defaultError(details: 'DB Crash')));

        return cartBloc;
      },
      act: (bloc) {
        bloc.add(AddToCart(product: testProduct));
        bloc.add(const ProcessCheckout(method: PaymentMethod.khqr));
      },
      skip: 1,
      expect: () => [
        isA<CartLoaded>()
            .having((s) => s.isCheckingOut, 'is checking out', true),
        isA<CartCheckoutFailure>(),
        isA<CartLoaded>()
            .having((s) => s.isCheckingOut, 'is checking out', false),
      ],
    );
  });
}

extension ProductX on Product {
  Product copyWithStock(double newStock) {
    return Product(
      id: id,
      barcode: barcode,
      nameKh: nameKh,
      nameEn: nameEn,
      categoryId: categoryId,
      unit: this.unit,
      costPrice: costPrice,
      retailPrice: retailPrice,
      wholesalePrice: wholesalePrice,
      stock: newStock,
      reservedStock: reservedStock,
      lowStockThreshold: lowStockThreshold,
      imagePath: imagePath,
      isActive: isActive,
      isFeatured: isFeatured,
      sortOrder: sortOrder,
      updatedAt: updatedAt,
      createdAt: createdAt,
      remoteId: remoteId,
      isSynced: isSynced,
    );
  }
}
