import 'package:get_it/get_it.dart';

import 'package:khmerbiz_pos/core/network/network_info.dart';

/// Global service locator instance.
final GetIt sl = GetIt.instance;

/// Initialize dependency injection.
Future<void> configureDependencies() async {
  // Register core instances
  _registerCoreDependencies();

  // Register features
  _registerFeatures();
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

/// Register feature dependencies.
void _registerFeatures() {
  // TODO: Implement feature dependencies
}
