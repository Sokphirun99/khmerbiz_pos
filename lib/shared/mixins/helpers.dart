/// Mixins for shared functionality.
library;

/// Mixin for form validation helpers.
mixin FormValidationMixin {
  /// Validate that field is not empty
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate email format
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

  /// Validate phone number (Khmer format)
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

  /// Validate password strength
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

  /// Validate password confirmation
  String? validatePasswordConfirm(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Validate number
  String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    if (num.tryParse(value.trim()) == null) {
      return 'Invalid $fieldName';
    }

    return null;
  }

  /// Validate positive number
  String? validatePositiveNumber(String? value, String fieldName) {
    final error = validateNumber(value, fieldName);
    if (error != null) return error;

    if (num.parse(value!) <= 0) {
      return '$fieldName must be positive';
    }

    return null;
  }

  /// Validate price
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

  /// Validate quantity
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
  /// Log a debug message
  void debugLog(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    print('🐛 $timestamp $tagStr $message');
  }

  /// Log an info message
  void infoLog(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    print('ℹ️ $timestamp $tagStr $message');
  }

  /// Log a warning message
  void warningLog(String message, {String? tag}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    print('⚠️ $timestamp $tagStr $message');
  }

  /// Log an error message
  void errorLog(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    final timestamp = DateTime.now().toIso8601String();
    final tagStr = tag != null ? '[$tag]' : '';
    print('❌ $timestamp $tagStr $message');
    if (error != null) {
      print('Error: $error');
    }
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
}
