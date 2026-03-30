import 'package:get_it/get_it.dart';

import 'package:khmerbiz_pos/core/network/network_info.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/products_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/inventory_dao.dart';
import 'package:khmerbiz_pos/data/repositories/product_repository_impl.dart';
import 'package:khmerbiz_pos/data/repositories/inventory_repository_impl.dart';
import 'package:khmerbiz_pos/data/repositories/auth_repository_impl.dart';
import 'package:khmerbiz_pos/data/repositories/exchange_rate_repository_impl.dart';
import 'package:khmerbiz_pos/data/repositories/khqr_repository_impl.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/inventory_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/khqr_repository.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_bloc.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initialize dependency injection.
Future<void> configureDependencies() async {
  _registerCoreDependencies();
  await _registerDatabase();
  _registerDAOs();
  _registerRepositories();
  _registerBlocs();
}

/// Register core dependencies.
void _registerCoreDependencies() {
  sl.registerLazySingleton<NetworkInfo>(
    NetworkInfoImpl.new,
  );

  sl.registerLazySingleton<NetworkMonitor>(
    () => NetworkMonitor(sl<NetworkInfo>()),
  );
}

/// Register database singleton.
Future<void> _registerDatabase() async {
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());
}

/// Register DAOs.
void _registerDAOs() {
  sl.registerLazySingleton<ProductsDao>(
    () => ProductsDao(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<InventoryDao>(
    () => InventoryDao(sl<AppDatabase>()),
  );
}

/// Register repositories.
void _registerRepositories() {
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<ProductsDao>()),
  );
  sl.registerLazySingleton<InventoryRepository>(
    () => InventoryRepositoryImpl(sl<InventoryDao>()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<ExchangeRateRepository>(
    () => ExchangeRateRepositoryImpl(sl<AppDatabase>()),
  );
  sl.registerLazySingleton<KhqrRepository>(
    () => KhqrRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
      exchangeRateRepository: sl<ExchangeRateRepository>(),
    ),
  );
}

/// Register BLoCs as factories (new instance per screen).
void _registerBlocs() {
  sl.registerFactory<ProductBloc>(
    () => ProductBloc(productRepository: sl<ProductRepository>()),
  );
  sl.registerFactory<InventoryBloc>(
    () => InventoryBloc(
      inventoryRepository: sl<InventoryRepository>(),
      productRepository: sl<ProductRepository>(),
      authRepository: sl<AuthRepository>(),
    ),
  );
  sl.registerFactory<PaymentBloc>(
    () => PaymentBloc(
      khqrRepository: sl<KhqrRepository>(),
      exchangeRateRepository: sl<ExchangeRateRepository>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );
}
