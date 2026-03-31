/// Mixins for shared functionality.
library;

import 'package:flutter/foundation.dart';

/// Mixin for form validation helpers.
mixin FormValidationMixin {
  /// Validates that the [value] is not empty.
  /// Returns a [fieldName] specific error message if invalid.
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validates that the [value] is a correctly formatted email address.
  String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Invalid email format';
    }

    return null;
  }

  /// Validates that the [value] is a valid Khmer phone number.
  String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final localPattern = RegExp(r'^0[16789]\d{7}$');
    final intlPattern = RegExp(r'^(\+855|855)[16789]\d{7}$');

    if (!localPattern.hasMatch(cleaned) && !intlPattern.hasMatch(cleaned)) {
      return 'Invalid phone number';
    }

    return null;
  }

  /// Validates that the [value] meets minimum password strength requirements.
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!value.contains(RegExp('[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!value.contains(RegExp('[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!value.contains(RegExp('[0-9]'))) {
      return 'Password must contain at least one number';
    }

    return null;
  }

  /// Validates that the [value] matches the provided [password].
  String? validatePasswordConfirm(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validates that the [value] is a valid numeric string.
  String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (num.tryParse(value.trim()) == null) {
      return 'Invalid $fieldName';
    }

    return null;
  }

  /// Validates that the [value] is a positive numeric string.
  String? validatePositiveNumber(String? value, String fieldName) {
    final error = validateNumber(value, fieldName);
    if (error != null) return error;

    if (num.parse(value!) <= 0) {
      return '$fieldName must be positive';
    }

    return null;
  }

  /// Validates that the [value] is a valid price (non-negative number).
  String? validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Price is required';
    }

    final price = num.tryParse(value.trim());
    if (price == null) {
      return 'Invalid price';
    }

    if (price < 0) {
      return 'Price cannot be negative';
    }

    return null;
  }

  /// Validates that the [value] is a valid quantity (non-negative integer).
  String? validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required';
    }

    final quantity = int.tryParse(value.trim());
    if (quantity == null) {
      return 'Invalid quantity';
    }

    if (quantity < 0) {
      return 'Quantity cannot be negative';
    }

    return null;
  }
}

/// Mixin for logging helpers.
mixin LoggerMixin {
  /// Logs a debug message with an optional [tag].
  void debugLog(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('🐛 $timestamp $tagStr $message');
    }
  }

  /// Logs an info message with an optional [tag].
  void infoLog(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('ℹ️ $timestamp $tagStr $message');
    }
  }

  /// Logs a warning message with an optional [tag].
  void warningLog(String message, {String? tag}) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('⚠️ $timestamp $tagStr $message');
    }
  }

  /// Logs an error message with [tag], optional [error] and [stackTrace].
  void errorLog(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final tagStr = tag != null ? '[$tag]' : '';
      debugPrint('❌ $timestamp $tagStr $message');
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }
}
