import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:khmerbiz_pos/core/theme/app_theme.dart';
import 'package:khmerbiz_pos/features/pos/presentation/screens/pos_screen.dart';

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

  runApp(const KhmerBizPosApp());
}

/// Root widget for KhmerBiz POS application.
class KhmerBizPosApp extends StatelessWidget {
  const KhmerBizPosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KhmerBiz POS',
      debugShowCheckedModeBanner: false,

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

      // Home screen - POS Demo
      home: const POSScreen(),
    );
  }
}
