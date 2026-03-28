import 'package:flutter/foundation.dart';

import 'package:khmerbiz_pos/core/config/env.dart';
import 'package:khmerbiz_pos/core/config/constants.dart';

/// Application configuration class.
/// Provides environment-aware configuration values.
///
/// Initialize this at app startup with the appropriate environment.
/// Example:
/// ```dart
/// AppConfig.init(
///   environment: Environment.dev,
///   apiBaseUrl: 'https://api-dev.khmerbiz.com',
/// );
/// ```
final class AppConfig {
  AppConfig._();

  static Environment _environment = Environment.dev;
  static String _apiBaseUrl = '';
  static bool _isInitialized = false;

  /// Whether the app config has been initialized
  static bool get isInitialized => _isInitialized;

  /// Current environment
  static Environment get environment => _environment;

  /// API base URL
  static String get apiBaseUrl {
    _checkInitialized();
    return _apiBaseUrl;
  }

  /// Whether logging is enabled
  static bool get enableLogging => _environment.enableLogging;

  /// Whether debug features are enabled
  static bool get enableDebugFeatures => _environment.enableDebugFeatures;

  /// Whether this is a development environment
  static bool get isDevelopment => _environment.isDevelopment;

  /// Whether this is a staging environment
  static bool get isStaging => _environment.isStaging;

  /// Whether this is a production environment
  static bool get isProduction => _environment.isProduction;

  /// Initialize the application configuration.
  ///
  /// [environment] - The target environment (dev, staging, prod)
  /// [apiBaseUrl] - The base URL for API calls
  ///
  /// This should be called once at app startup, typically in main().
  static void init({
    required Environment environment,
    required String apiBaseUrl,
  }) {
    if (_isInitialized) {
      throw StateError('AppConfig is already initialized');
    }

    _environment = environment;
    _apiBaseUrl = apiBaseUrl;
    _isInitialized = true;

    if (_environment.enableLogging) {
      print('🏗️ AppConfig initialized');
      print('   Environment: ${_environment.name}');
      print('   API Base URL: $_apiBaseUrl');
    }
  }

  /// Initialize from command-line arguments.
  ///
  /// Supports the following dart-defines:
  /// - ENVIRONMENT: dev, staging, prod (default: dev)
  /// - API_BASE_URL: The API base URL (required for prod, optional for others)
  ///
  /// Example:
  /// ```bash
  /// flutter run --dart-define=ENVIRONMENT=prod --dart-define=API_BASE_URL=https://api.khmerbiz.com
  /// ```
  static void initFromArgs({
    String? environmentArg,
    String? apiBaseUrlArg,
  }) {
    if (_isInitialized) {
      throw StateError('AppConfig is already initialized');
    }

    // Parse environment
    final envString = environmentArg ?? 'dev';
    _environment = Environment.values.firstWhere(
      (e) => e.name == envString.toLowerCase(),
      orElse: () => Environment.dev,
    );

    // Parse API base URL
    var apiUrl = apiBaseUrlArg ?? '';

    // Use defaults if not provided based on environment
    if (apiUrl.isEmpty) {
      apiUrl = _getDefaultApiUrl(_environment);
    }

    init(environment: _environment, apiBaseUrl: apiUrl);
  }

  /// Get default API URL based on environment
  static String _getDefaultApiUrl(Environment env) {
    return switch (env) {
      Environment.dev => 'http://10.0.2.2:8080/api', // Android emulator localhost
      Environment.staging => 'https://api-staging.khmerbiz.com',
      Environment.prod => 'https://api.khmerbiz.com',
    };
  }

  /// Reset configuration (for testing purposes only)
  @visibleForTesting
  static void resetForTesting() {
    _isInitialized = false;
    _environment = Environment.dev;
    _apiBaseUrl = '';
  }

  static void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError(
        'AppConfig has not been initialized. Call AppConfig.init() in main().',
      );
    }
  }

  /// Get configuration summary for debugging
  static Map<String, dynamic> get debugInfo {
    return {
      'environment': _environment.name,
      'apiBaseUrl': _apiBaseUrl,
      'enableLogging': enableLogging,
      'enableDebugFeatures': enableDebugFeatures,
      'isDevelopment': isDevelopment,
      'isStaging': isStaging,
      'isProduction': isProduction,
      'exchangeRate': AppConstants.defaultExchangeRate,
      'taxRate': AppConstants.defaultTaxRate,
      'lowStockThreshold': AppConstants.lowStockThreshold,
      'syncIntervalMinutes': AppConstants.syncIntervalMinutes,
    };
  }
}
