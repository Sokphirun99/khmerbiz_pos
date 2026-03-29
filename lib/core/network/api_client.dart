import 'package:dio/dio.dart';

import 'package:khmerbiz_pos/core/config/app_config.dart';
import 'package:khmerbiz_pos/core/config/constants.dart';

/// API client for making HTTP requests.
final class ApiClient {
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
  final Dio _dio;

  Dio get dio => _dio;

  void updateAuthToken(String? token) {
    if (token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  void _setupInterceptors() {
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (obj) => print('🌐 $obj'),
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['X-Request-ID'] =
              DateTime.now().millisecondsSinceEpoch.toString();
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (AppConfig.enableLogging) {
            print('✅ ${response.requestOptions.path} - ${response.statusCode}');
          }
          return handler.next(response);
        },
        onError: (error, handler) async {
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
}

/// Retry interceptor for handling transient failures.
final class RetryInterceptor extends Interceptor {
  RetryInterceptor({
    required this.dio,
    this.retries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.logPrint = print,
  });
  final Dio dio;
  final int retries;
  final Duration retryDelay;
  final void Function(Object object) logPrint;

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
    if (err.response?.statusCode != null) {
      final statusCode = err.response!.statusCode!;
      if (statusCode >= 400 && statusCode < 500) {
        return statusCode == 408 || statusCode == 429;
      }
    }

    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
