import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/adjustment_reason.dart';
import 'package:khmerbiz_pos/domain/entities/inventory_log.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/user.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/inventory_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:mocktail/mocktail.dart';

// ── Mocks ──────────────────────────────────────────────────────────────────

class MockInventoryRepository extends Mock implements InventoryRepository {}

class MockProductRepository extends Mock implements ProductRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

// ── Test Fixtures ──────────────────────────────────────────────────────────

final _now = DateTime(2026, 3, 30);

final _testProduct = Product(
  id: 'p1',
  nameKh: 'កាហ្វេ',
  nameEn: 'Coffee',
  retailPrice: 10000,
  costPrice: 5000,
  stock: 10,
  updatedAt: _now,
  createdAt: _now,
);

final _updatedProduct = Product(
  id: 'p1',
  nameKh: 'កាហ្វេ',
  nameEn: 'Coffee',
  retailPrice: 10000,
  costPrice: 5000,
  stock: 15,
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

final _testUser = User(
  id: 'u1',
  username: 'admin',
  fullNameKh: 'រដ្ឋបាល',
  fullNameEn: 'Admin User',
  role: 'admin',
  createdAt: _now,
);

final _testLog = InventoryLog(
  id: 'log1',
  productId: 'p1',
  changeAmount: 5,
  stockBefore: 10,
  stockAfter: 15,
  reason: 'received_stock',
  staffId: 'u1',
  notes: 'Restocked',
  timestamp: _now,
);

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  late InventoryBloc inventoryBloc;
  late MockInventoryRepository mockInventoryRepo;
  late MockProductRepository mockProductRepo;
  late MockAuthRepository mockAuthRepo;

  setUp(() {
    mockInventoryRepo = MockInventoryRepository();
    mockProductRepo = MockProductRepository();
    mockAuthRepo = MockAuthRepository();

    inventoryBloc = InventoryBloc(
      inventoryRepository: mockInventoryRepo,
      productRepository: mockProductRepo,
      authRepository: mockAuthRepo,
    );
  });

  tearDown(() {
    inventoryBloc.close();
  });

  group('InventoryBloc initial state', () {
    test('initial state is InventoryInitial', () {
      expect(inventoryBloc.state, isA<InventoryInitial>());
    });
  });

  group('LoadInventoryLog', () {
    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryLoaded] on success',
      build: () {
        when(() => mockInventoryRepo.getInventoryLogs())
            .thenAnswer((_) async => Right([_testLog]));
        when(() => mockInventoryRepo.getLowStockProducts())
            .thenAnswer((_) async => Right([_lowStockProduct]));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const LoadInventoryLog()),
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryLoaded>()
            .having((s) => s.logs.length, 'log count', 1)
            .having((s) => s.lowStockItems.length, 'low stock count', 1),
      ],
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryError] when logs fail',
      build: () {
        when(() => mockInventoryRepo.getInventoryLogs())
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        when(() => mockInventoryRepo.getLowStockProducts())
            .thenAnswer((_) async => Right([_lowStockProduct]));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const LoadInventoryLog()),
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryError>(),
      ],
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryError] when low stock fails',
      build: () {
        when(() => mockInventoryRepo.getInventoryLogs())
            .thenAnswer((_) async => Right([_testLog]));
        when(() => mockInventoryRepo.getLowStockProducts())
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const LoadInventoryLog()),
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryError>(),
      ],
    );

    blocTest<InventoryBloc, InventoryState>(
      'passes productId and date filters to repository',
      build: () {
        final start = DateTime(2026, 3);
        final end = DateTime(2026, 3, 31);
        when(() => mockInventoryRepo.getInventoryLogs(
              productId: 'p1',
              startDate: start,
              endDate: end,
            ),).thenAnswer((_) async => Right([_testLog]));
        when(() => mockInventoryRepo.getLowStockProducts())
            .thenAnswer((_) async => const Right([]));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(LoadInventoryLog(
        productId: 'p1',
        startDate: DateTime(2026, 3),
        endDate: DateTime(2026, 3, 31),
      ),),
      verify: (_) {
        verify(() => mockInventoryRepo.getInventoryLogs(
              productId: 'p1',
              startDate: DateTime(2026, 3),
              endDate: DateTime(2026, 3, 31),
            ),).called(1);
      },
    );
  });

  group('AdjustStock', () {
    blocTest<InventoryBloc, InventoryState>(
      'emits [StockAdjusted] on successful stock adjustment',
      build: () {
        when(() => mockProductRepo.getProductById('p1'))
            .thenAnswer((_) async => Right(_testProduct));
        when(() => mockAuthRepo.getCurrentUser())
            .thenAnswer((_) async => Right(_testUser));
        when(() => mockInventoryRepo.adjustStock(
              productId: 'p1',
              quantity: 5,
              reason: 'received_stock',
              staffId: 'u1',
            ),).thenAnswer((_) async => const Right(null));
        // After adjustment, fetch updated product
        when(() => mockProductRepo.getProductById('p1'))
            .thenAnswer((_) async => Right(_updatedProduct));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const AdjustStock(
        productId: 'p1',
        quantity: 5,
        reason: AdjustmentReason.receivedStock,
      ),),
      expect: () => [
        isA<StockAdjusted>()
            .having(
                (s) => s.previousStock, 'previous stock', 10.0,)
            .having(
                (s) => s.updatedProduct.stock, 'new stock', 15.0,),
      ],
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryError] when product lookup fails',
      build: () {
        when(() => mockProductRepo.getProductById('p1'))
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const AdjustStock(
        productId: 'p1',
        quantity: 5,
        reason: AdjustmentReason.receivedStock,
      ),),
      expect: () => [isA<InventoryError>()],
    );

    blocTest<InventoryBloc, InventoryState>(
      'uses "unknown" staffId when getCurrentUser fails',
      build: () {
        when(() => mockProductRepo.getProductById('p1'))
            .thenAnswer((_) async => Right(_testProduct));
        when(() => mockAuthRepo.getCurrentUser())
            .thenAnswer(
                (_) async => Left(ServerFailure.notFound()),);
        when(() => mockInventoryRepo.adjustStock(
              productId: 'p1',
              quantity: 5,
              reason: 'received_stock',
              staffId: 'unknown',
            ),).thenAnswer((_) async => const Right(null));
        when(() => mockProductRepo.getProductById('p1'))
            .thenAnswer((_) async => Right(_updatedProduct));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const AdjustStock(
        productId: 'p1',
        quantity: 5,
        reason: AdjustmentReason.receivedStock,
      ),),
      verify: (_) {
        verify(() => mockInventoryRepo.adjustStock(
              productId: 'p1',
              quantity: 5,
              reason: 'received_stock',
              staffId: 'unknown',
            ),).called(1);
      },
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryError] when adjustStock repository call fails',
      build: () {
        when(() => mockProductRepo.getProductById('p1'))
            .thenAnswer((_) async => Right(_testProduct));
        when(() => mockAuthRepo.getCurrentUser())
            .thenAnswer((_) async => Right(_testUser));
        when(() => mockInventoryRepo.adjustStock(
              productId: 'p1',
              quantity: 5,
              reason: 'received_stock',
              staffId: 'u1',
            ),).thenAnswer(
                (_) async => Left(CacheFailure.defaultError()),);
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(const AdjustStock(
        productId: 'p1',
        quantity: 5,
        reason: AdjustmentReason.receivedStock,
      ),),
      expect: () => [isA<InventoryError>()],
    );
  });

  group('LoadLowStockReport', () {
    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryLoaded] with low stock items',
      build: () {
        when(() => mockInventoryRepo.getLowStockProducts())
            .thenAnswer((_) async => Right([_lowStockProduct]));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(LoadLowStockReport()),
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryLoaded>()
            .having((s) => s.lowStockItems.length, 'low stock count', 1)
            .having((s) => s.lowStockItems.first.id, 'product id', 'p2'),
      ],
    );

    blocTest<InventoryBloc, InventoryState>(
      'emits [InventoryLoading, InventoryError] when report fails',
      build: () {
        when(() => mockInventoryRepo.getLowStockProducts())
            .thenAnswer((_) async => Left(CacheFailure.defaultError()));
        return inventoryBloc;
      },
      act: (bloc) => bloc.add(LoadLowStockReport()),
      expect: () => [
        isA<InventoryLoading>(),
        isA<InventoryError>(),
      ],
    );
  });
}
