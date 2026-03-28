/// Extensions on num, int, and double for formatting.
library;

import 'dart:math' as math;

import 'package:khmerbiz_pos/core/utils/currency_formatter.dart';
import 'package:khmerbiz_pos/core/utils/date_formatter.dart';

/// Extensions on num for formatting.
extension NumFormattingExtension on num {
  /// Format as KHR currency
  String get formatKHR => currencyFormatter.formatKHR(toDouble());

  /// Format as dual currency (KHR primary, USD secondary)
  String get formatDual => currencyFormatter.formatDual(toDouble());

  /// Format as USD currency
  String get formatUSD => currencyFormatter.formatUSD(toDouble());

  /// Convert to USD from KHR
  double get toUSD => currencyFormatter.khqrToUSD(toDouble());

  /// Convert to KHR from USD
  double get toKHR => currencyFormatter.usdToKHR(toDouble());

  /// Format as percentage
  String get asPercentage => '${(this * 100).toStringAsFixed(1)}%';

  /// Format with thousand separators
  String get withSeparators {
    return toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  /// Clamp value between min and max
  num clampTo(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Round to decimal places
  double toDecimalPlaces(int places) {
    final mod = math.pow(10, places).toDouble();
    return (this * mod).round() / mod;
  }
}

/// Extensions on int for formatting.
extension IntFormattingExtension on int {
  /// Format as KHR currency
  String get formatKHR => currencyFormatter.formatKHR(toDouble());

  /// Format as dual currency
  String get formatDual => currencyFormatter.formatDual(toDouble());

  /// Format as quantity with abbreviation for large numbers
  String get formattedQuantity {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  /// Format as time duration (hours:minutes)
  String get asDuration {
    final hours = this ~/ 60;
    final minutes = this % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Format as day name (0 = Sunday, 6 = Saturday)
  String get asDayName {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[this % 7];
  }

  /// Format as Khmer day name
  String get asDayNameKhmer {
    const days = ['អាទិត្យ', 'ច័ន្ទ', 'អង្គារ', 'ពុធ', 'ព្រហស្បតិ៍', 'សុក្រ', 'សៅរ៍'];
    return days[this % 7];
  }
}

/// Extensions on DateTime for formatting.
extension DateTimeFormattingExtension on DateTime {
  /// Format as display date
  String get formatDisplay => dateFormatter.formatDisplay(this);

  /// Format as Khmer date
  String get formatKhmer => dateFormatter.formatKhmer(this);

  /// Format as dual language
  String get formatDual => dateFormatter.formatDual(this);

  /// Format date and time display
  String get formatDateTimeDisplay => dateFormatter.formatDateTimeDisplay(this);

  /// Format date and time Khmer
  String get formatDateTimeKhmer => dateFormatter.formatDateTimeKhmer(this);

  /// Format date and time dual
  String get formatDateTimeDual => dateFormatter.formatDateTimeDual(this);

  /// Format as ISO string
  String get formatISO => dateFormatter.formatISO(this);

  /// Format as relative time (English)
  String get formatRelative => dateFormatter.formatRelative(this);

  /// Format as relative time (Khmer)
  String get formatRelativeKhmer => dateFormatter.formatRelativeKhmer(this);

  /// Format time only
  String get formatTime => dateFormatter.formatTime(this);

  /// Format time in Khmer
  String get formatTimeKhmer => dateFormatter.formatTimeKhmer(this);

  /// Check if is today
  bool get isToday => dateFormatter.isToday(this);

  /// Check if is yesterday
  bool get isYesterday => dateFormatter.isYesterday(this);

  /// Get day name in Khmer
  String get dayNameKhmer => dateFormatter.getDayNameKhmer(this);

  /// Get day name in English (short)
  String get dayNameEnglish => dateFormatter.getDayNameEnglish(this);

  /// Get start of day
  DateTime get startOfDay => DateTime(year, month, day);

  /// Get end of day
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Get start of week (Monday)
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  /// Get end of week (Sunday)
  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  /// Get start of month
  DateTime get startOfMonth => DateTime(year, month);

  /// Get end of month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  /// Check if is in the past
  bool get isPast => isBefore(DateTime.now());

  /// Check if is in the future
  bool get isFuture => isAfter(DateTime.now());

  /// Check if is same day as another date
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Check if is same month as another date
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Add days
  DateTime addDays(int days) => add(Duration(days: days));

  /// Subtract days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Add months (handles month overflow)
  DateTime addMonths(int months) {
    final newMonth = month + months;
    final newYear = year + (newMonth - 1) ~/ 12;
    final adjustedMonth = ((newMonth - 1) % 12) + 1;
    final lastDayOfMonth = DateTime(newYear, adjustedMonth + 1, 0).day;
    final newDay = day > lastDayOfMonth ? lastDayOfMonth : day;
    return DateTime(newYear, adjustedMonth, newDay, hour, minute, second);
  }

  /// Get age from birthdate
  int get age {
    final now = DateTime.now();
    var age = now.year - year;
    if (now.month < month || (now.month == month && now.day < day)) {
      age--;
    }
    return age;
  }
}

/// Extensions on String for parsing and validation.
extension StringParsingExtension on String {
  /// Parse to int
  int? tryParseInt() => int.tryParse(this);

  /// Parse to double
  double? tryParseDouble() => double.tryParse(this);

  /// Parse to DateTime from ISO format
  DateTime? tryParseISO() => dateFormatter.parseISO(this);

  /// Parse to DateTime from display format
  DateTime? tryParseDisplay() => dateFormatter.parseDisplay(this);

  /// Check if string is null or empty
  bool get isNullOrEmpty => trim().isEmpty;

  /// Check if string is not null or empty
  bool get isNotNullOrEmpty => trim().isNotEmpty;

  /// Check if string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(this);
  }

  /// Check if string is a valid Khmer phone number
  bool get isValidKhmerPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final localPattern = RegExp(r'^0[16789]\d{7}$');
    final intlPattern = RegExp(r'^(\+855|855)[16789]\d{7}$');
    return localPattern.hasMatch(cleaned) || intlPattern.hasMatch(cleaned);
  }

  /// Check if string contains only Khmer characters
  bool get isKhmer {
    return RegExp(r'[\u1780-\u17FF]').hasMatch(this);
  }

  /// Check if string contains Khmer characters
  bool get containsKhmer {
    return RegExp(r'[\u1780-\u17FF]').hasMatch(this);
  }

  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Title case
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Remove all non-numeric characters
  String get onlyDigits => replaceAll(RegExp(r'\D'), '');

  /// Format as phone number (Khmer format)
  String get formatAsKhmerPhone {
    final digits = onlyDigits;
    if (digits.startsWith('855') && digits.length == 11) {
      return '+855 ${digits.substring(3, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    } else if (digits.startsWith('0') && digits.length == 10) {
      return '0${digits[1]} ${digits.substring(2, 5)} ${digits.substring(5)}';
    }
    return this;
  }

  /// Safe trim (handles null)
  String safeTrim() => trim();

  /// Or default value if empty
  String or(String defaultValue) => isNullOrEmpty ? defaultValue : this;

  /// Or null if empty
  String? orNull() => isNullOrEmpty ? null : this;
}
