import 'package:equatable/equatable.dart';

/// Base sealed class for all failures in the application.
/// Used for error handling across Clean Architecture layers.
sealed class Failure extends Equatable {
  const Failure({
    required this.messageEn,
    required this.messageKm,
    this.details,
  });

  /// The error message in English
  final String messageEn;

  /// The error message in Khmer
  final String messageKm;

  /// Optional technical details or stack trace context
  final String? details;

  @override
  List<Object?> get props => [messageEn, messageKm, details];
}

/// Server-related failures (API errors, timeouts, etc.)
final class ServerFailure extends Failure {
  /// Creates a [ServerFailure].
  const ServerFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
    this.statusCode,
  });

  /// Default server error with optional status code
  factory ServerFailure.defaultError({int? statusCode, String? details}) {
    return ServerFailure(
      messageEn: 'Server error occurred. Please try again later.',
      messageKm: 'មានកំហុសកើតឡើង។ សូមព្យាយាមម្តងទៀតនៅពេលក្រោយ។',
      statusCode: statusCode,
      details: details,
    );
  }

  /// Authentication/Authorization error
  factory ServerFailure.unauthorized() {
    return const ServerFailure(
      messageEn: 'Session expired. Please login again.',
      messageKm: 'សម្គាល់ឈ្មោះបានផុតកំណត់។ សូមចូលម្តងទៀត។',
      statusCode: 401,
    );
  }

  /// Resource not found
  factory ServerFailure.notFound() {
    return const ServerFailure(
      messageEn: 'Requested resource not found.',
      messageKm: 'មិនអាចរកឃើញទិន្នន័យដែលត្រូវការ។',
      statusCode: 404,
    );
  }

  /// Server unavailable
  factory ServerFailure.unavailable() {
    return const ServerFailure(
      messageEn: 'Service temporarily unavailable.',
      messageKm: 'សេវាកម្មមិនអាចប្រើប្រាស់បានបណ្តោះអាសន្ន។',
      statusCode: 503,
    );
  }

  /// The HTTP status code returned by the server, if any
  final int? statusCode;

  @override
  List<Object?> get props => [messageEn, messageKm, details, statusCode];
}

/// Local cache/database failures
final class CacheFailure extends Failure {
  /// Creates a [CacheFailure].
  const CacheFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
  });

  /// Default cache error
  factory CacheFailure.defaultError({String? details}) {
    return CacheFailure(
      messageEn: 'Failed to access local data.',
      messageKm: 'បរាជ័យក្នុងការចូលប្រើទិន្នន័យក្នុងគ្រឿង។',
      details: details,
    );
  }

  /// Database corruption
  factory CacheFailure.corrupted() {
    return const CacheFailure(
      messageEn: 'Database corrupted. Please reinstall the app.',
      messageKm: 'មូលដ្ឋានទិន្នន័យខូច។ សូមដំឡើងកម្មវិធីឡើងវិញ។',
    );
  }

  /// Storage full
  factory CacheFailure.storageFull() {
    return const CacheFailure(
      messageEn: 'Device storage is full.',
      messageKm: 'ទំហំផ្ទុកក្នុងគ្រឿងពេញ។',
    );
  }

  @override
  List<Object?> get props => [messageEn, messageKm, details];
}

/// Network connectivity failures
final class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const NetworkFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
  });

  /// No internet connection
  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      messageEn: 'No internet connection. Please check your network.',
      messageKm: 'គ្មានការតភ្ជាប់អ៊ីនធឺណិត។ សូមពិនិត្យមើលបណ្តាញរបស់អ្នក។',
    );
  }

  /// Connection timeout
  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      messageEn: 'Connection timed out. Please try again.',
      messageKm: 'ការតភ្ជាប់បានផុតកំណត់។ សូមព្យាយាមម្តងទៀត។',
    );
  }

  /// Weak connection
  factory NetworkFailure.weakConnection() {
    return const NetworkFailure(
      messageEn: 'Weak network connection.',
      messageKm: 'សញ្ញាបណ្តាញខ្សោយ។',
    );
  }

  @override
  List<Object?> get props => [messageEn, messageKm, details];
}

/// Input validation failures
final class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure].
  const ValidationFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
    this.field,
  });

  /// Required field empty
  factory ValidationFailure.requiredField(String fieldName) {
    return ValidationFailure(
      messageEn: '$fieldName is required.',
      messageKm: '$fieldName គឺចាំបាច់។',
      field: fieldName,
    );
  }

  /// Invalid format
  factory ValidationFailure.invalidFormat(String fieldName) {
    return ValidationFailure(
      messageEn: 'Invalid $fieldName format.',
      messageKm: 'ទម្រង់ $fieldName មិនត្រឹមត្រូវ។',
      field: fieldName,
    );
  }

  /// Custom validation error
  factory ValidationFailure.custom({
    required String messageEn,
    required String messageKm,
    String? field,
  }) {
    return ValidationFailure(
      messageEn: messageEn,
      messageKm: messageKm,
      field: field,
    );
  }

  /// The specific input field that failed validation
  final String? field;

  @override
  List<Object?> get props => [messageEn, messageKm, details, field];
}

/// Bluetooth/Thermal printer failures
final class PrinterFailure extends Failure {
  /// Creates a [PrinterFailure].
  const PrinterFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
  });

  /// Printer not found
  factory PrinterFailure.notFound() {
    return const PrinterFailure(
      messageEn: 'No printer connected. Please connect a Bluetooth printer.',
      messageKm: 'គ្មានម៉ាស៊ីនបោះពុម្ព។ សូមតភ្ជាប់ម៉ាស៊ីនបោះពុម្ព Bluetooth។',
    );
  }

  /// Printer not connected when trying to print
  factory PrinterFailure.notConnected() {
    return const PrinterFailure(
      messageEn: 'Printer is not connected. Please connect a printer first.',
      messageKm: 'ម៉ាស៊ីនបោះពុម្ពមិនបានតភ្ជាប់ទេ។ សូមតភ្ជាប់ម៉ាស៊ីនបោះពុម្ពជាមុនសិន។',
    );
  }

  /// Print failed
  factory PrinterFailure.printFailed() {
    return const PrinterFailure(
      messageEn: 'Failed to print receipt.',
      messageKm: 'បរាជ័យក្នុងការបោះពុម្ពវិក្កយបត្រ។',
    );
  }

  /// Printer out of range
  factory PrinterFailure.outOfRange() {
    return const PrinterFailure(
      messageEn: 'Printer out of range.',
      messageKm: 'ម៉ាស៊ីនបោះពុម្ពនៅឆ្ងាយ។',
    );
  }

  @override
  List<Object?> get props => [messageEn, messageKm, details];
}

/// Payment processing failures
final class PaymentFailure extends Failure {
  /// Creates a [PaymentFailure].
  const PaymentFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
  });

  /// Payment declined
  factory PaymentFailure.declined() {
    return const PaymentFailure(
      messageEn: 'Payment was declined. Please try another payment method.',
      messageKm: 'ការទូទាត់ត្រូវបានបដិសេធ។ សូមប្រើវិធីទូទាត់ផ្សេង។',
    );
  }

  /// KHQR scan failed
  factory PaymentFailure.qrScanFailed() {
    return const PaymentFailure(
      messageEn: 'Failed to scan KHQR code.',
      messageKm: 'បរាជ័យក្នុងការស្កែន KHQR។',
    );
  }

  /// Payment timeout
  factory PaymentFailure.timeout() {
    return const PaymentFailure(
      messageEn: 'Payment verification timed out.',
      messageKm: 'ការផ្ទៀងផ្ទាត់ការទូទាត់បានផុតកំណត់។',
    );
  }

  @override
  List<Object?> get props => [messageEn, messageKm, details];
}

/// Data synchronization failures
final class SyncFailure extends Failure {
  /// Creates a [SyncFailure].
  const SyncFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
  });

  /// Sync conflict
  factory SyncFailure.conflict() {
    return const SyncFailure(
      messageEn: 'Data conflict detected. Manual resolution required.',
      messageKm: 'មានជម្លោះទិន្នន័យ។ ត្រូវការការដោះស្រាយដោយដៃ។',
    );
  }

  /// Sync failed
  factory SyncFailure.failed() {
    return const SyncFailure(
      messageEn: 'Data synchronization failed.',
      messageKm: 'ការធ្វើសមកាលកម្មទិន្នន័យបរាជ័យ។',
    );
  }

  /// Partial sync
  factory SyncFailure.partial() {
    return const SyncFailure(
      messageEn: 'Some data failed to sync.',
      messageKm: 'ទិន្នន័យមួយចំនួនមិនអាចធ្វើសមកាលកម្មបាន។',
    );
  }

  @override
  List<Object?> get props => [messageEn, messageKm, details];
}

/// System-level failures (Bluetooth, permissions, hardware, etc.)
final class SystemFailure extends Failure {
  /// Creates a [SystemFailure].
  const SystemFailure({
    required super.messageEn,
    required super.messageKm,
    super.details,
  });

  /// Bluetooth related failure
  factory SystemFailure.bluetooth(String reason) {
    return SystemFailure(
      messageEn: 'Bluetooth error: $reason',
      messageKm: 'កំហុស Bluetooth៖ $reason',
      details: reason,
    );
  }

  /// Permission denied
  factory SystemFailure.permissionDenied(String feature) {
    return SystemFailure(
      messageEn: '$feature permission denied. Please enable in settings.',
      messageKm: 'ការអនុញ្ញាត $feature ត្រូវបានបដិសេធ។ សូមបើកនៅក្នុងការកំណត់។',
    );
  }

  @override
  List<Object?> get props => [...super.props];
}
