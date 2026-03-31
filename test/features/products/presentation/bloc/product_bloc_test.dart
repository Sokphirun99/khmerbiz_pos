import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_event.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_state.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ──────────────────────────────────────────────────────────────────

class MockProductRepository extends Mock implements ProductRepository {}

class FakeProductInput extends Fake implements ProductInput {}

// ── Test Fixtures ──────────────────────────────────────────────────────────

final _now = DateTime(2026, 3, 30);

final _testProduct = Product(
  id: 'p1',
  nameKh: 'កាហ្វេ',
  nameEn: 'Coffee',
  barcode: '1234567890',
  categoryId: 'cat1',
  retailPrice: 10000,
  costPrice: 5000,
  stock: 10,
  updatedAt: _now,
  createdAt: _now,
);

final _lowStockProduct = Product(
  id: 'p2',
  nameKh: 'តែ',
  nameEn: 'Tea',
  retailPrice: 8000,
  costPrice: 4000,
  stock: 2,
  updatedAt: _now,
  createdAt: _now,
);

const _testCategory = Category(
  id: 'cat1',
  nameKh: 'ភេសជ្ជៈ',
  nameEn: 'Beverages',
);

const _validInput = ProductInput(
  nameKh: 'កាហ្វេថ្មី',
  nameEn: 'New Coffee',
  retailPrice: 12000,
  costPrice: 6000,
  stock: 20,
);

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  late ProductBloc productBloc;
  late MockProductRepository mockRepo;

  setUpAll(() {
    registerFallbackValue(FakeProductInput());
  });

  setUp(() {
    mockRepo = MockProductRepository();
    productBloc = ProductBloc(productRepository: mockRepo);
  });

  tearDown(() {
    productBloc.close();
  });

  group('ProductBloc initial state', () {
    test('initial state is ProductsInitial', () {
      expect(productBloc.state, isA<ProductsInitial>());
    });
  });

  group('BarcodeDetected', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductScanned] when barcode matches a product',
      build: () {
        when(() => mockRepo.getProductByBarcode('1234567890'))
            .thenAnswer((_) async => Right(_testProduct));
        return productBloc;
      },
      act: (bloc) =>
          bloc.add(const BarcodeDetected(barcode: '1234567890')),
      expect: () => [
        isA<ProductScanned>()
            .having((s) => s.product.id, 'product id', 'p1'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [BarcodeNotFound] when barcode has no match',
      build: () {
        when(() => mockRepo.getProductByBarcode('9999999999'))
            .thenAnswer((_) async => const Right(null));
        return productBloc;
      },
      act: (bloc) =>
          bloc.add(const BarcodeDetected(barcode: '9999999999')),
      expect: () => [
        isA<BarcodeNotFound>()
            .having((s) => s.barcode, 'barcode', '9999999999'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [BarcodeNotFound] when repository returns failure',
      build: () {
        when(() => mockRepo.getProductByBarcode('0000000000'))
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return productBloc;
      },
      act: (bloc) =>
          bloc.add(const BarcodeDetected(barcode: '0000000000')),
      expect: () => [
        isA<BarcodeNotFound>()
            .having((s) => s.barcode, 'barcode', '0000000000'),
      ],
    );
  });

  group('ScanBarcode', () {
    blocTest<ProductBloc, ProductState>(
      'emits [BarcodeScanning] when scan initiated',
      build: () => productBloc,
      act: (bloc) => bloc.add(const ScanBarcode()),
      expect: () => [isA<BarcodeScanning>()],
    );
  });

  group('AddProduct', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductSaved] on successful creation',
      build: () {
        when(() => mockRepo.createProduct(any()))
            .thenAnswer((_) async => const Right('p-new'));
        when(() => mockRepo.getProductById('p-new'))
            .thenAnswer((_) async => Right(_testProduct));
        return productBloc;
      },
      act: (bloc) => bloc.add(const AddProduct(input: _validInput)),
      expect: () => [
        isA<ProductSaved>()
            .having((s) => s.product.id, 'product id', 'p1'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductsError] when creation fails',
      build: () {
        when(() => mockRepo.createProduct(any()))
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return productBloc;
      },
      act: (bloc) => bloc.add(const AddProduct(input: _validInput)),
      expect: () => [isA<ProductsError>()],
    );
  });

  group('UpdateProduct', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductSaved] on successful update',
      build: () {
        when(() => mockRepo.updateProduct('p1', any()))
            .thenAnswer((_) async => const Right(null));
        when(() => mockRepo.getProductById('p1'))
            .thenAnswer((_) async => Right(_testProduct));
        return productBloc;
      },
      act: (bloc) =>
          bloc.add(const UpdateProduct(id: 'p1', input: _validInput)),
      expect: () => [
        isA<ProductSaved>()
            .having((s) => s.product.id, 'product id', 'p1'),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductsError] when update fails',
      build: () {
        when(() => mockRepo.updateProduct('p1', any()))
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return productBloc;
      },
      act: (bloc) =>
          bloc.add(const UpdateProduct(id: 'p1', input: _validInput)),
      expect: () => [isA<ProductsError>()],
    );
  });

  group('DeleteProduct', () {
    blocTest<ProductBloc, ProductState>(
      'emits nothing on successful delete (stream will update)',
      build: () {
        when(() => mockRepo.deleteProduct('p1'))
            .thenAnswer((_) async => const Right(null));
        return productBloc;
      },
      act: (bloc) => bloc.add(const DeleteProduct(id: 'p1')),
      expect: () => <ProductState>[],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductsError] when delete fails',
      build: () {
        when(() => mockRepo.deleteProduct('p1'))
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return productBloc;
      },
      act: (bloc) => bloc.add(const DeleteProduct(id: 'p1')),
      expect: () => [isA<ProductsError>()],
    );
  });

  group('ToggleProductActive', () {
    blocTest<ProductBloc, ProductState>(
      'emits nothing on successful toggle (stream will update)',
      build: () {
        when(() => mockRepo.toggleProductActive('p1'))
            .thenAnswer((_) async => const Right(null));
        return productBloc;
      },
      act: (bloc) => bloc.add(const ToggleProductActive(id: 'p1')),
      expect: () => <ProductState>[],
    );

    blocTest<ProductBloc, ProductState>(
      'emits [ProductsError] when toggle fails',
      build: () {
        when(() => mockRepo.toggleProductActive('p1'))
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return productBloc;
      },
      act: (bloc) => bloc.add(const ToggleProductActive(id: 'p1')),
      expect: () => [isA<ProductsError>()],
    );
  });

  group('LoadProducts', () {
    blocTest<ProductBloc, ProductState>(
      'emits [ProductsLoading] then subscribes to streams',
      build: () {
        when(() => mockRepo.watchAllActiveProducts())
            .thenAnswer((_) => Stream.value(Right([_testProduct, _lowStockProduct])));
        when(() => mockRepo.watchActiveCategories())
            .thenAnswer((_) => Stream.value(const Right([_testCategory])));
        return productBloc;
      },
      act: (bloc) => bloc.add(const LoadProducts()),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>()
            .having((s) => s.products.length, 'product count', 2)
            .having((s) => s.categories.length, 'category count', 1)
            .having(
                (s) => s.lowStockAlerts.length, 'low stock count', 1,),
      ],
    );

    blocTest<ProductBloc, ProductState>(
      'filters by category when categoryId is provided',
      build: () {
        when(() => mockRepo.watchProductsByCategory('cat1'))
            .thenAnswer((_) => Stream.value(Right([_testProduct])));
        when(() => mockRepo.watchActiveCategories())
            .thenAnswer((_) => Stream.value(const Right([_testCategory])));
        return productBloc;
      },
      act: (bloc) => bloc.add(const LoadProducts(categoryId: 'cat1')),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<ProductsLoading>(),
        isA<ProductsLoaded>()
            .having((s) => s.products.length, 'product count', 1)
            .having(
                (s) => s.selectedCategoryId, 'selected category', 'cat1',),
      ],
    );
  });
}
