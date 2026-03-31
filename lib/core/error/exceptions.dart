/// Base exception class for all custom exceptions in the application.
abstract class AppException implements Exception {
  /// Creates an [AppException] with a [message] and optional [details].
  const AppException({
    required this.message,
    this.details,
  });

  /// A human-readable description of the error
  final String message;

  /// Optional technical details or error context
  final String? details;

  @override
  String toString() {
    if (details != null) {
      return '$runtimeType: $message (Details: $details)';
    }
    return '$runtimeType: $message';
  }
}

/// Server-related exceptions
final class ServerException extends AppException {
  /// Creates a [ServerException].
  const ServerException({
    required super.message,
    super.details,
    this.statusCode,
  });

  /// The HTTP status code returned by the server
  final int? statusCode;
}

/// Cache/Database exceptions
final class CacheException extends AppException {
  /// Creates a [CacheException].
  const CacheException({
    required super.message,
    super.details,
  });
}

/// Network connectivity exceptions
final class NetworkException extends AppException {
  /// Creates a [NetworkException].
  const NetworkException({
    required super.message,
    super.details,
  });
}

/// Validation exceptions
final class ValidationException extends AppException {
  /// Creates a [ValidationException].
  const ValidationException({
    required super.message,
    super.details,
    this.field,
  });

  /// The specific input field that failed validation
  final String? field;
}

/// Printer exceptions
final class PrinterException extends AppException {
  /// Creates a [PrinterException].
  const PrinterException({
    required super.message,
    super.details,
  });
}

/// Payment processing exceptions
final class PaymentException extends AppException {
  /// Creates a [PaymentException].
  const PaymentException({
    required super.message,
    super.details,
  });
}

/// Synchronization exceptions
final class SyncException extends AppException {
  /// Creates a [SyncException].
  const SyncException({
    required super.message,
    super.details,
  });
}

/// Authentication exceptions
final class AuthException extends AppException {
  /// Creates an [AuthException].
  const AuthException({
    required super.message,
    super.details,
  });
}

/// Token expired exception
final class TokenExpiredException extends AppException {
  /// Creates a [TokenExpiredException].
  const TokenExpiredException({
    super.message = 'Token has expired',
    super.details,
  });
}

/// Unauthorized exception
final class UnauthorizedException extends AppException {
  /// Creates an [UnauthorizedException].
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.details,
  });
}

/// Database operation exceptions
final class DatabaseException extends AppException {
  /// Creates a [DatabaseException].
  const DatabaseException({
    required super.message,
    super.details,
  });
}

/// File operation exceptions
final class FileException extends AppException {
  /// Creates a [FileException].
  const FileException({
    required super.message,
    super.details,
  });
}

/// Permission denied exceptions
final class PermissionDeniedException extends AppException {
  /// Creates a [PermissionDeniedException].
  const PermissionDeniedException({
    super.message = 'Permission denied',
    super.details,
  });
}
