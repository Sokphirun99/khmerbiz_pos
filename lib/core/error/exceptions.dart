/// Base exception class for all custom exceptions in the application.
abstract class AppException implements Exception {
  const AppException({
    required this.message,
    this.details,
  });
  final String message;
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
  const ServerException({
    required super.message,
    super.details,
    this.statusCode,
  });
  final int? statusCode;
}

/// Cache/Database exceptions
final class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.details,
  });
}

/// Network connectivity exceptions
final class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.details,
  });
}

/// Validation exceptions
final class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.details,
    this.field,
  });
  final String? field;
}

/// Printer exceptions
final class PrinterException extends AppException {
  const PrinterException({
    required super.message,
    super.details,
  });
}

/// Payment processing exceptions
final class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.details,
  });
}

/// Synchronization exceptions
final class SyncException extends AppException {
  const SyncException({
    required super.message,
    super.details,
  });
}

/// Authentication exceptions
final class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.details,
  });
}

/// Token expired exception
final class TokenExpiredException extends AppException {
  const TokenExpiredException({
    super.message = 'Token has expired',
    super.details,
  });
}

/// Unauthorized exception
final class UnauthorizedException extends AppException {
  const UnauthorizedException({
    super.message = 'Unauthorized access',
    super.details,
  });
}

/// Database operation exceptions
final class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.details,
  });
}

/// File operation exceptions
final class FileException extends AppException {
  const FileException({
    required super.message,
    super.details,
  });
}

/// Permission denied exceptions
final class PermissionDeniedException extends AppException {
  const PermissionDeniedException({
    super.message = 'Permission denied',
    super.details,
  });
}
