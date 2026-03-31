import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:khmerbiz_pos/core/config/app_config.dart';
import 'package:khmerbiz_pos/core/config/constants.dart';

/// API client for making HTTP requests.
final class ApiClient {

  /// Creates a new [ApiClient] instance.
  ///
  /// [baseUrl] - The base URL for all API requests
  /// [authToken] - Optional initial authentication token
  ApiClient({
    required String baseUrl,
    String? authToken,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(
              milliseconds: AppConstants.apiConnectionTimeoutMs,
            ),
            receiveTimeout: const Duration(
              milliseconds: AppConstants.apiReceiveTimeoutMs,
            ),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              if (authToken != null) 'Authorization': 'Bearer $authToken',
            },
          ),
        ) {
    _setupInterceptors();
  }
  static const String _redactedValue = '<redacted>';
  static const String _omittedValue = '<omitted>';
  final Dio _dio;

  /// Returns the underlying [Dio] instance for custom configuration.
  Dio get dio => _dio;

  /// Updates the authentication token used in request headers.
  ///
  /// If [token] is null, the Authorization header is removed.
  void updateAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  /// Clears the authentication token from request headers.
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['X-Request-ID'] =
              DateTime.now().millisecondsSinceEpoch.toString();
          if (AppConfig.enableLogging) {
            _logRequest(options);
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.enableLogging) {
            _logResponse(response);
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
          if (AppConfig.enableLogging) {
            _logError(error);
          }
          final exception = _handleError(error);
          return handler.reject(exception);
        },
      ),
    );
  }

  DioException _handleError(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout =>
        DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
          error: error.error,
          response: error.response,
        ),
      DioExceptionType.badResponse => _handleBadResponse(error),
      DioExceptionType.cancel => error,
      DioExceptionType.connectionError => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.connectionError,
          message: 'No internet connection',
          error: error.error,
          response: error.response,
        ),
      DioExceptionType.badCertificate => error,
      DioExceptionType.unknown => DioException(
          requestOptions: error.requestOptions,
          message: 'An unexpected error occurred',
          error: error.error,
        ),
    };
  }

  DioException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;

    return switch (statusCode) {
      400 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Bad request',
          response: error.response,
        ),
      401 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Unauthorized',
          response: error.response,
        ),
      403 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Forbidden',
          response: error.response,
        ),
      404 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Not found',
          response: error.response,
        ),
      409 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Conflict',
          response: error.response,
        ),
      422 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Validation error',
          response: error.response,
        ),
      500 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Internal server error',
          response: error.response,
        ),
      502 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Bad gateway',
          response: error.response,
        ),
      503 => DioException(
          requestOptions: error.requestOptions,
          type: DioExceptionType.badResponse,
          message: 'Service unavailable',
          response: error.response,
        ),
      _ => error,
    };
  }

  void _logRequest(RequestOptions options) {
    _debugLog(
      '🌐 ${_formatLogEntry({
            'type': 'request',
            'method': options.method,
            'path': options.path,
            'headers': _sanitizeHeaders(options.headers),
            'query': _sanitizeData(options.queryParameters),
            'body': _sanitizeData(options.data),
          })}',
    );
  }

  void _logResponse(Response<dynamic> response) {
    _debugLog(
      '✅ ${_formatLogEntry({
            'type': 'response',
            'method': response.requestOptions.method,
            'path': response.requestOptions.path,
            'statusCode': response.statusCode,
            'body': _sanitizeData(response.data),
          })}',
    );
  }

  void _logError(DioException error) {
    _debugLog(
      '❌ ${_formatLogEntry({
            'type': 'error',
            'method': error.requestOptions.method,
            'path': error.requestOptions.path,
            'statusCode': error.response?.statusCode,
            'message': error.message,
            'body': _sanitizeData(error.response?.data),
          })}',
    );
  }

  void _debugLog(String message) {
    debugPrint(message);
  }

  String _formatLogEntry(Map<String, Object?> payload) {
    try {
      return jsonEncode(payload);
    } catch (_) {
      return payload.toString();
    }
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> headers) {
    return headers.map(
      (key, value) => MapEntry(
        key,
        _isSensitiveKey(key) ? _redactedValue : value,
      ),
    );
  }

  dynamic _sanitizeData(dynamic data) {
    if (data == null) {
      return null;
    }

    if (data is FormData) {
      return {
        'fields': Map<String, dynamic>.fromEntries(
          data.fields.map(
            (field) => MapEntry(
              field.key,
              _isSensitiveKey(field.key) ? _redactedValue : field.value,
            ),
          ),
        ),
        if (data.files.isNotEmpty) 'files': _omittedValue,
      };
    }

    if (data is Map) {
      return data.map<String, dynamic>(
        (key, value) => MapEntry(
          key.toString(),
          _isSensitiveKey(key.toString())
              ? _redactedValue
              : _sanitizeData(value),
        ),
      );
    }

    if (data is List) {
      return data.map(_sanitizeData).toList(growable: false);
    }

    if (data is num || data is bool) {
      return data;
    }

    return _omittedValue;
  }

  bool _isSensitiveKey(String key) {
    final normalizedKey = key.toLowerCase();

    return normalizedKey.contains('authorization') ||
        normalizedKey.contains('cookie') ||
        normalizedKey.contains('token') ||
        normalizedKey.contains('secret') ||
        normalizedKey.contains('password') ||
        normalizedKey.contains('pin') ||
        normalizedKey.contains('api-key') ||
        normalizedKey.contains('apikey');
  }
}

/// Retry interceptor for handling transient failures.
final class RetryInterceptor extends Interceptor {
  /// Creates a new [RetryInterceptor].
  ///
  /// [dio] - The Dio instance to use for retrying requests
  /// [retries] - Maximum number of retry attempts (default: 3)
  /// [retryDelay] - Delay between retry attempts (default: 1 second)
  /// [logPrint] - Optional callback for logging retry attempts
  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.logPrint,
  });

  /// The Dio instance used to retry failed requests
  final Dio dio;

  /// Maximum number of retry attempts before giving up
  final int retries;

  /// Duration to wait before attempting a retry
  final Duration retryDelay;

  /// Optional logging function, defaults to [debugPrint] compatible signatures
  final void Function(Object object)? logPrint;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    var retryCount = 0;
    var shouldRetry = true;

    while (retryCount < retries && shouldRetry) {
      try {
        await Future<void>.delayed(retryDelay * (retryCount + 1));

        final response = await dio.fetch<ResponseBody>(
          err.requestOptions.copyWith(
            headers: {
              ...err.requestOptions.headers,
              'X-Retry-Count': (retryCount + 1).toString(),
            },
          ),
        );

        return handler.resolve(response);
      } catch (e) {
        retryCount++;
        shouldRetry = _shouldRetry(err) && retryCount < retries;

        if (!shouldRetry) {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }

  bool _shouldRetry(DioException err) {
      final statusCode = err.response?.statusCode;
      if (statusCode != null && statusCode >= 400 && statusCode < 500) {
        return statusCode == 408 || statusCode == 429;
      }

    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
