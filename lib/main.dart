import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:khmerbiz_pos/core/di/injection.dart';
import 'package:khmerbiz_pos/core/router/app_router.dart';
import 'package:khmerbiz_pos/core/theme/app_theme.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_bloc.dart';

/// Main entry point for KhmerBiz POS application.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection
  await configureDependencies();

  runApp(const KhmerBizPosApp());
}

/// Root widget for KhmerBiz POS application.
class KhmerBizPosApp extends StatefulWidget {
  const KhmerBizPosApp({super.key});

  @override
  State<KhmerBizPosApp> createState() => _KhmerBizPosAppState();
}

class _KhmerBizPosAppState extends State<KhmerBizPosApp> {
  late final _router = AppRouter.createRouter(
    initialLocation: AppRouter.products,
  );

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>.value(
          value: sl<ProductRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(create: (_) => sl<ProductBloc>()),
          BlocProvider<InventoryBloc>(create: (_) => sl<InventoryBloc>()),
        ],
        child: MaterialApp.router(
          title: 'KhmerBiz POS',
          debugShowCheckedModeBanner: false,

          // Router configuration
          routerConfig: _router,

          // Theme configuration
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: ThemeMode.light,

          // Localization configuration
          locale: const Locale('en', 'US'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('km', 'KH'),
          ],

          // Builder for global overlays
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }
}
