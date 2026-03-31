import 'package:flutter/foundation.dart';

/// Production-safe logging utility.
///
/// All debug prints should go through this class to ensure
/// no sensitive information leaks in production builds.
///
/// Usage:
/// ```dart
/// AppLogger.d('Debug message', tag: 'MyTag');
/// AppLogger.e('Error occurred', error: e, stackTrace: stack);
/// ```
class AppLogger {
  AppLogger._();

  /// Whether logging is enabled.
  ///
  /// Automatically disabled in release builds.
  static bool get _enabled => kDebugMode;

  /// Debug log - only shown in debug builds.
  ///
  /// [message] - The log message
  /// [tag] - Optional tag for categorizing logs (defaults to class name)
  /// [error] - Optional error object
  static void d(
    String message, {
    String tag = 'App',
    Object? error,
  }) {
    if (!_enabled) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final errorStr = error != null ? ' | Error: $error' : '';
    debugPrint('[$timestamp] D/$tag: $message$errorStr');
  }

  /// Info log - only shown in debug builds.
  static void i(
    String message, {
    String tag = 'App',
  }) {
    if (!_enabled) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('[$timestamp] I/$tag: $message');
  }

  /// Warning log - only shown in debug builds.
  static void w(
    String message, {
    String tag = 'App',
    Object? error,
  }) {
    if (!_enabled) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final errorStr = error != null ? ' | Error: $error' : '';
    debugPrint('[$timestamp] W/$tag: $message$errorStr');
  }

  /// Error log - only shown in debug builds.
  ///
  /// In production, errors should be sent to Crashlytics instead.
  static void e(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!_enabled) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    final errorStr = error != null ? '\nError: $error' : '';
    final stackStr = stackTrace != null ? '\nStack: $stackTrace' : '';
    debugPrint('[$timestamp] E/$tag: $message$errorStr$stackStr');
  }

  /// Network log - only shown in debug builds.
  ///
  /// Use for HTTP request/response logging.
  /// NEVER log sensitive data like tokens, passwords, or PII.
  static void network(
    String message, {
    String tag = 'Network',
  }) {
    if (!_enabled) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('[$timestamp] N/$tag: $message');
  }

  /// Database log - only shown in debug builds.
  static void database(
    String message, {
    String tag = 'DB',
  }) {
    if (!_enabled) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23);
    debugPrint('[$timestamp] D/$tag: $message');
  }

  /// Security-sensitive log - NEVER logs in any build.
  ///
  /// Use this for sensitive operations like PIN verification,
  /// token handling, etc. These are never logged even in debug.
  static void secure(
    String operation, {
    String tag = 'Security',
  }) {
    // Intentionally empty - never log security operations
    // This method exists to prevent accidental logging of sensitive data
  }
}
