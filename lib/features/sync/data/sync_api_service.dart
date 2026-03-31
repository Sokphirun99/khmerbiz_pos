import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:dio/dio.dart';

/// API service for synchronization operations.
///
/// Handles all HTTP communication with the sync server.
@LazySingleton()
class SyncApiService {
  /// Creates a [SyncApiService].
  SyncApiService({
    @factoryParam Dio? dio,
  }) : _dio = dio ?? Dio();

  final Dio _dio;

  /// Base URL for sync API
  static const String baseUrl = 'https://api.khmerbizkh.com';

  /// Sync transactions to server.
  ///
  /// POST /api/v1/transactions/batch
  Future<Either<Failure, void>> syncTransactions(List<Map<String, dynamic>> transactions) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/transactions/batch',
        data: {'transactions': transactions},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return _handleError(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to sync transactions: $e',
        messageKm: 'បរាជ័យក្នុងការធ្វើសមកាលកម្មប្រតិបត្តិការ៖ $e',
      ));
    }
  }

  /// Sync inventory logs to server.
  ///
  /// POST /api/v1/inventory-logs/batch
  Future<Either<Failure, void>> syncInventoryLogs(List<Map<String, dynamic>> logs) async {
    try {
      final response = await _dio.post(
        '$baseUrl/api/v1/inventory-logs/batch',
        data: {'logs': logs},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return _handleError(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to sync inventory logs: $e',
        messageKm: 'បរាជ័យក្នុងការធ្វើសមកាលកម្មកំណត់ហេតុស្តុក៖ $e',
      ));
    }
  }

  /// Update product on server.
  ///
  /// PUT /api/v1/products/{id}
  Future<Either<Failure, void>> updateProduct(
    String id,
    Map<String, dynamic> product,
  ) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/v1/products/$id',
        data: product,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return _handleError(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to update product: $e',
        messageKm: 'បរាជ័យក្នុងការធ្វើបច្ចុប្បន្នភាពផលិតផល៖ $e',
      ));
    }
  }

  /// Update customer on server.
  ///
  /// PUT /api/v1/customers/{id}
  Future<Either<Failure, void>> updateCustomer(
    String id,
    Map<String, dynamic> customer,
  ) async {
    try {
      final response = await _dio.put(
        '$baseUrl/api/v1/customers/$id',
        data: customer,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return const Right(null);
      } else {
        return _handleError(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to update customer: $e',
        messageKm: 'បរាជ័យក្នុងការធ្វើបច្ចុប្បន្នភាពអតិថិជន៖ $e',
      ));
    }
  }

  /// Get product updates from server.
  ///
  /// GET /api/v1/products/updates?since={timestamp}&deviceId={id}
  Future<Either<Failure, List<Map<String, dynamic>>>> getProductUpdates({
    required String since,
    required String deviceId,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/v1/products/updates',
        queryParameters: {
          'since': since,
          'deviceId': deviceId,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final products = data['products'] as List;
        return right(products.cast<Map<String, dynamic>>());
      } else {
        return _handleError(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to fetch product updates: $e',
        messageKm: 'បរាជ័យក្នុងការទាញយកបច្ចុប្បន្នភាពផលិតផល៖ $e',
      ));
    }
  }

  /// Get latest exchange rate.
  ///
  /// GET /api/v1/exchange-rates/latest
  Future<Either<Failure, Map<String, dynamic>>> getLatestExchangeRate() async {
    try {
      final response = await _dio.get(
        '$baseUrl/api/v1/exchange-rates/latest',
      );

      if (response.statusCode == 200) {
        return right(response.data as Map<String, dynamic>);
      } else {
        return _handleError(response);
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to fetch exchange rate: $e',
        messageKm: 'បរាជ័យក្នុងការទាញយកអត្រាប្តូរ៖ $e',
      ));
    }
  }

  // ── Error Handling ───────────────────────────────────────────────────────

  Either<Failure, T> _handleError<T>(Response response) {
    final statusCode = response.statusCode ?? 500;
    final data = response.data as Map<String, dynamic>?;
    final message = data?['message'] as String? ?? 'Unknown error';

    if (statusCode == 409) {
      return left<Failure, T>(ServerFailure(
        messageEn: 'Conflict: $message',
        messageKm: 'ជម្លោះ៖ $message',
        statusCode: statusCode,
      ));
    } else if (statusCode >= 400 && statusCode < 500) {
      return left<Failure, T>(ServerFailure(
        messageEn: 'Client error: $message',
        messageKm: 'កំហុសអតិថិជន៖ $message',
        statusCode: statusCode,
      ));
    } else {
      return left<Failure, T>(ServerFailure.defaultError(
        statusCode: statusCode,
        details: message,
      ));
    }
  }

  Either<Failure, T> _handleDioError<T>(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return left<Failure, T>(NetworkFailure.timeout());
      case DioExceptionType.connectionError:
        return left<Failure, T>(const NetworkFailure(
          messageEn: 'Connection error. Please check your internet.',
          messageKm: 'កំហុសតភ្ជាប់។ សូមពិនិត្យអ៊ីនធឺណិតរបស់អ្នក។',
        ));
      case DioExceptionType.badResponse:
        return _handleError<T>(e.response!);
      case DioExceptionType.cancel:
        return left<Failure, T>(const NetworkFailure(
          messageEn: 'Request cancelled',
          messageKm: 'សំណើត្រូវបានបោះបង់',
        ));
      default:
        return left<Failure, T>(SystemFailure(
          messageEn: 'Network error: ${e.message}',
          messageKm: 'កំហុសបណ្តាញ៖ ${e.message}',
        ));
    }
  }
}
