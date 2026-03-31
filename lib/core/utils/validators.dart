import 'package:khmerbiz_pos/core/error/failures.dart';

/// Form field validators for KhmerBiz POS.
///
/// All validators return a [ValidationFailure] if validation fails,
/// or `null` if validation passes.
///
/// Example usage:
/// ```dart
/// final error = Validators.email(_controller.text);
/// if (error != null) {
///   showError(error.messageEn);
/// }
/// ```
final class Validators {
  const Validators._();

  /// Validate that field is not empty.
  ///
  /// [value] - The value to validate
  /// [fieldName] - Name of the field for error message
  /// Returns [ValidationFailure] if empty, null otherwise
  static ValidationFailure? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure.requiredField(fieldName);
    }
    return null;
  }

  /// Validate email format.
  ///
  /// [value] - The email to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure.requiredField('Email');
    }

    // Basic email regex pattern
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value.trim())) {
      return ValidationFailure.invalidFormat('email');
    }

    return null;
  }

  /// Validate phone number (Cambodia format).
  ///
  /// Accepts formats:
  /// - 012345678
  /// - 01 234 567
  /// - +855 12 345 678
  /// - 85512345678
  ///
  /// [value] - The phone number to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? phoneKhmer(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure.requiredField('Phone number');
    }

    // Remove spaces, dashes, and parentheses
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Cambodia phone patterns
    // Starting with 01, 06, 07, 08, 09 followed by 7 digits
    final localPattern = RegExp(r'^0[16789]\d{7}$');
    // International format: +855 or 855 followed by 9 digits
    final intlPattern = RegExp(r'^(\+855|855)[16789]\d{7}$');

    if (!localPattern.hasMatch(cleaned) && !intlPattern.hasMatch(cleaned)) {
      return ValidationFailure.invalidFormat('phone number');
    }

    return null;
  }

  /// Validate password strength.
  ///
  /// Requirements:
  /// - Minimum 8 characters
  /// - At least one uppercase letter
  /// - At least one lowercase letter
  /// - At least one number
  ///
  /// [value] - The password to validate
  /// Returns [ValidationFailure] if weak, null otherwise
  static ValidationFailure? password(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationFailure.requiredField('Password');
    }

    if (value.length < 8) {
      return ValidationFailure.custom(
        messageEn: 'Password must be at least 8 characters',
        messageKm: 'ពាក្យសម្ងាត់ត្រូវតែមានយ៉ាងតិច ៨ តួអក្សរ',
        field: 'password',
      );
    }

    if (!value.contains(RegExp('[A-Z]'))) {
      return ValidationFailure.custom(
        messageEn: 'Password must contain at least one uppercase letter',
        messageKm: 'ពាក្យសម្ងាត់ត្រូវតែមានអក្សរធំយ៉ាងតិច ១',
        field: 'password',
      );
    }

    if (!value.contains(RegExp('[a-z]'))) {
      return ValidationFailure.custom(
        messageEn: 'Password must contain at least one lowercase letter',
        messageKm: 'ពាក្យសម្ងាត់ត្រូវតែមានអក្សរតូចយ៉ាងតិច ១',
        field: 'password',
      );
    }

    if (!value.contains(RegExp('[0-9]'))) {
      return ValidationFailure.custom(
        messageEn: 'Password must contain at least one number',
        messageKm: 'ពាក្យសម្ងាត់ត្រូវតែមានលេខយ៉ាងតិច ១',
        field: 'password',
      );
    }

    return null;
  }

  /// Validate password confirmation matches.
  ///
  /// [value] - The confirmation password
  /// [originalPassword] - The original password to match
  /// Returns [ValidationFailure] if not matching, null otherwise
  static ValidationFailure? passwordConfirm(
    String? value,
    String originalPassword,
  ) {
    if (value == null || value.isEmpty) {
      return ValidationFailure.requiredField('Password confirmation');
    }

    if (value != originalPassword) {
      return ValidationFailure.custom(
        messageEn: 'Passwords do not match',
        messageKm: 'ពាក្យសម្ងាត់មិនដូចគ្នា',
        field: 'password_confirmation',
      );
    }

    return null;
  }

  /// Validate numeric value.
  ///
  /// [value] - The value to validate
  /// [fieldName] - Name of the field for error message
  /// [min] - Minimum allowed value (optional)
  /// [max] - Maximum allowed value (optional)
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? number(
    String? value,
    String fieldName, {
    num? min,
    num? max,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure.requiredField(fieldName);
    }

    final numValue = num.tryParse(value.trim());
    if (numValue == null) {
      return ValidationFailure.invalidFormat(fieldName);
    }

    if (min != null && numValue < min) {
      return ValidationFailure.custom(
        messageEn: '$fieldName must be at least $min',
        messageKm: '$fieldName ត្រូវតែមានយ៉ាងតិច $min',
        field: fieldName,
      );
    }

    if (max != null && numValue > max) {
      return ValidationFailure.custom(
        messageEn: '$fieldName must be at most $max',
        messageKm: '$fieldName ត្រូវតែមានយ៉ាងច្រើន $max',
        field: fieldName,
      );
    }

    return null;
  }

  /// Validate positive number.
  ///
  /// [value] - The value to validate
  /// [fieldName] - Name of the field for error message
  /// [allowZero] - Whether zero is allowed
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? positiveNumber(
    String? value,
    String fieldName, {
    bool allowZero = false,
  }) {
    if (value == null || value.trim().isEmpty) {
      return ValidationFailure.requiredField(fieldName);
    }

    final numValue = num.tryParse(value.trim());
    if (numValue == null) {
      return ValidationFailure.invalidFormat(fieldName);
    }

    if (allowZero && numValue < 0) {
      return ValidationFailure.custom(
        messageEn: '$fieldName must be zero or positive',
        messageKm: '$fieldName ត្រូវតែជាលេខវិជ្ជមាន ឬសូន្យ',
        field: fieldName,
      );
    }

    if (!allowZero && numValue <= 0) {
      return ValidationFailure.custom(
        messageEn: '$fieldName must be positive',
        messageKm: '$fieldName ត្រូវតែជាលេខវិជ្ជមាន',
        field: fieldName,
      );
    }

    return null;
  }

  /// Validate price value.
  ///
  /// [value] - The price to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? price(String? value) {
    return positiveNumber(value, 'Price', allowZero: true);
  }

  /// Validate quantity value.
  ///
  /// [value] - The quantity to validate
  /// [max] - Maximum allowed quantity
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? quantity(String? value, {int? max}) {
    return number(value, 'Quantity', min: 0, max: max);
  }

  /// Validate discount percentage.
  ///
  /// [value] - The discount percentage to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? discount(String? value) {
    return number(value, 'Discount', min: 0, max: 100);
  }

  /// Validate string length.
  ///
  /// [value] - The value to validate
  /// [fieldName] - Name of the field for error message
  /// [minLength] - Minimum length (optional)
  /// [maxLength] - Maximum length (optional)
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? stringLength(
    String? value,
    String fieldName, {
    int? minLength,
    int? maxLength,
  }) {
    if (value == null || value.isEmpty) {
      if (minLength != null && minLength > 0) {
        return ValidationFailure.requiredField(fieldName);
      }
      return null;
    }

    final length = value.length;

    if (minLength != null && length < minLength) {
      return ValidationFailure.custom(
        messageEn: '$fieldName must be at least $minLength characters',
        messageKm: '$fieldName ត្រូវតែមានយ៉ាងតិច $minLength តួអក្សរ',
        field: fieldName,
      );
    }

    if (maxLength != null && length > maxLength) {
      return ValidationFailure.custom(
        messageEn: '$fieldName must be at most $maxLength characters',
        messageKm: '$fieldName ត្រូវតែមានយ៉ាងច្រើន $maxLength តួអក្សរ',
        field: fieldName,
      );
    }

    return null;
  }

  /// Validate product name.
  ///
  /// [value] - The product name to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? productName(String? value) {
    final requiredError = required(value, 'Product name');
    if (requiredError != null) return requiredError;

    return stringLength(value, 'Product name', minLength: 2, maxLength: 200);
  }

  /// Validate customer name.
  ///
  /// [value] - The customer name to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? customerName(String? value) {
    final requiredError = required(value, 'Customer name');
    if (requiredError != null) return requiredError;

    return stringLength(value, 'Customer name', minLength: 2, maxLength: 100);
  }

  /// Validate business name.
  ///
  /// [value] - The business name to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? businessName(String? value) {
    final requiredError = required(value, 'Business name');
    if (requiredError != null) return requiredError;

    return stringLength(value, 'Business name', minLength: 2, maxLength: 150);
  }

  /// Validate VAT number (Cambodia format).
  ///
  /// [value] - The VAT number to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? vatNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // VAT is optional
    }

    final cleaned = value.replaceAll(RegExp(r'[\s\-]'), '');

    // Cambodia VAT format: 10 digits
    final vatPattern = RegExp(r'^\d{10}$');

    if (!vatPattern.hasMatch(cleaned)) {
      return ValidationFailure.invalidFormat('VAT number');
    }

    return null;
  }

  /// Validate date is not in the past.
  ///
  /// [date] - The date to validate
  /// [fieldName] - Name of the field for error message
  /// Returns [ValidationFailure] if in the past, null otherwise
  static ValidationFailure? notInPast(DateTime date, String fieldName) {
    final now = DateTime.now();

    if (date.isBefore(now)) {
      return ValidationFailure.custom(
        messageEn: '$fieldName cannot be in the past',
        messageKm: '$fieldName មិនអាចនៅអតីតកាល',
        field: fieldName,
      );
    }

    return null;
  }

  /// Validate date range.
  ///
  /// [startDate] - Start date
  /// [endDate] - End date
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? dateRange(DateTime startDate, DateTime endDate) {
    if (endDate.isBefore(startDate)) {
      return ValidationFailure.custom(
        messageEn: 'End date must be after start date',
        messageKm: 'កាលបរិច្ឆេទបញ្ចប់ត្រូវតែនៅក្រោយកាលបរិច្ឆេទចាប់ផ្តើម',
        field: 'date_range',
      );
    }

    return null;
  }

  /// Validate PIN code (4-6 digits).
  ///
  /// [value] - The PIN to validate
  /// Returns [ValidationFailure] if invalid, null otherwise
  static ValidationFailure? pin(String? value) {
    if (value == null || value.isEmpty) {
      return ValidationFailure.requiredField('PIN');
    }

    final pinPattern = RegExp(r'^\d{4,6}$');

    if (!pinPattern.hasMatch(value)) {
      return ValidationFailure.custom(
        messageEn: 'PIN must be 4-6 digits',
        messageKm: 'លេខសម្ងាត់ត្រូវតែជាលេខ ៤-៦ ខ្ទង់',
        field: 'pin',
      );
    }

    return null;
  }
}

/// Extension on String? for convenient validation.
///
/// Example:
/// ```dart
/// final emailError = _emailController.text.validateEmail();
/// final passwordError = _passwordController.text.validatePassword();
/// ```
extension ValidationExtension on String? {
  /// Validate that field is not empty.
  ValidationFailure? validateRequired(String fieldName) =>
      Validators.required(this, fieldName);

  /// Validate email format.
  ValidationFailure? validateEmail() => Validators.email(this);

  /// Validate phone number (Cambodia format).
  ValidationFailure? validatePhoneKhmer() => Validators.phoneKhmer(this);

  /// Validate password strength.
  ValidationFailure? validatePassword() => Validators.password(this);

  /// Validate password confirmation matches.
  ValidationFailure? validatePasswordConfirm(String original) =>
      Validators.passwordConfirm(this, original);

  /// Validate price value.
  ValidationFailure? validatePrice() => Validators.price(this);

  /// Validate quantity value.
  ValidationFailure? validateQuantity({int? max}) =>
      Validators.quantity(this, max: max);

  /// Validate discount percentage.
  ValidationFailure? validateDiscount() => Validators.discount(this);

  /// Validate product name.
  ValidationFailure? validateProductName() => Validators.productName(this);

  /// Validate customer name.
  ValidationFailure? validateCustomerName() => Validators.customerName(this);

  /// Validate business name.
  ValidationFailure? validateBusinessName() => Validators.businessName(this);

  /// Validate VAT number (Cambodia format).
  ValidationFailure? validateVATNumber() => Validators.vatNumber(this);

  /// Validate PIN code (4-6 digits).
  ValidationFailure? validatePin() => Validators.pin(this);
}
