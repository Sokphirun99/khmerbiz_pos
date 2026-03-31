/// Extensions on num, int, and double for formatting.
library;

import 'dart:math' as math;

import 'package:khmerbiz_pos/core/utils/currency_formatter.dart';
import 'package:khmerbiz_pos/core/utils/date_formatter.dart';

/// Extensions on num for formatting.
extension NumFormattingExtension on num {
  /// Formats the number as a Khmer Riel (KHR) currency string.
  String get formatKHR => currencyFormatter.formatKHR(toDouble());

  /// Formats as dual currency, showing KHR primary and USD secondary.
  String get formatDual => currencyFormatter.formatDual(toDouble());

  /// Formats the number as a US Dollar (USD) currency string.
  String get formatUSD => currencyFormatter.formatUSD(toDouble());

  /// Converts the value from KHR to USD based on the current exchange rate.
  double get toUSD => currencyFormatter.khqrToUSD(toDouble());

  /// Converts the value from USD to KHR based on the current exchange rate.
  double get toKHR => currencyFormatter.usdToKHR(toDouble());

  /// Formats the number as a percentage string (e.g., 0.1 -> "10.0%").
  String get asPercentage => '${(this * 100).toStringAsFixed(1)}%';

  /// Formats the number with thousand separators (e.g., 1000 -> "1,000").
  String get withSeparators {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Clamps the value between [min] and [max].
  num clampTo(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }

  /// Rounds the number to the specified number of [places].
  double toDecimalPlaces(int places) {
    final mod = math.pow(10, places).toDouble();
    return (this * mod).round() / mod;
  }
}

/// Extensions on int for formatting.
extension IntFormattingExtension on int {
  /// Formats the integer as a Khmer Riel (KHR) currency string.
  String get formatKHR => currencyFormatter.formatKHR(toDouble());

  /// Formats the integer as dual currency (primary KHR, secondary USD).
  String get formatDual => currencyFormatter.formatDual(toDouble());

  /// Formats as quantity with abbreviations for large numbers (e.g., 1500 -> "1.5K").
  String get formattedQuantity {
    if (this >= 1000000) {
      return '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }

  /// Formats the integer as a duration string (e.g., 90 -> "01:30").
  /// Assumes the integer represents total minutes.
  String get asDuration {
    final hours = this ~/ 60;
    final minutes = this % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Returns the day abbreviation in English (0 = Sun, 6 = Sat).
  String get asDayName {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[this % 7];
  }

  /// Returns the day name in Khmer.
  String get asDayNameKhmer {
    const days = [
      'អាទិត្យ',
      'ច័ន្ទ',
      'អង្គារ',
      'ពុធ',
      'ព្រហស្បតិ៍',
      'សុក្រ',
      'សៅរ៍',
    ];
    return days[this % 7];
  }
}

/// Extensions on DateTime for formatting.
extension DateTimeFormattingExtension on DateTime {
  /// Formats as display date (dd MMM yyyy).
  String get formatDisplay => dateFormatter.formatDisplay(this);

  /// Formats as Khmer date.
  String get formatKhmer => dateFormatter.formatKhmer(this);

  /// Formats in both English and Khmer.
  String get formatDual => dateFormatter.formatDual(this);

  /// Formats date and time for display.
  String get formatDateTimeDisplay => dateFormatter.formatDateTimeDisplay(this);

  /// Formats date and time in Khmer.
  String get formatDateTimeKhmer => dateFormatter.formatDateTimeKhmer(this);

  /// Formats date and time in both languages.
  String get formatDateTimeDual => dateFormatter.formatDateTimeDual(this);

  /// Formats in ISO 8601 string.
  String get formatISO => dateFormatter.formatISO(this);

  /// Returns relative time in English (e.g., "5 minutes ago").
  String get formatRelative => dateFormatter.formatRelative(this);

  /// Returns relative time in Khmer.
  String get formatRelativeKhmer => dateFormatter.formatRelativeKhmer(this);

  /// Formats time portion only (HH:mm).
  String get formatTime => dateFormatter.formatTime(this);

  /// Formats time in Khmer.
  String get formatTimeKhmer => dateFormatter.formatTimeKhmer(this);

  /// Whether the date is today.
  bool get isToday => dateFormatter.isToday(this);

  /// Whether the date is yesterday.
  bool get isYesterday => dateFormatter.isYesterday(this);

  /// Returns day name in Khmer.
  String get dayNameKhmer => dateFormatter.getDayNameKhmer(this);

  /// Returns day name in English.
  String get dayNameEnglish => dateFormatter.getDayNameEnglish(this);

  /// Returns the start of the day (00:00:00).
  DateTime get startOfDay => DateTime(year, month, day);

  /// Returns the end of the day (23:59:59).
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  /// Returns the start of the week (Monday).
  DateTime get startOfWeek {
    return subtract(Duration(days: weekday - 1)).startOfDay;
  }

  /// Returns the end of the week (Sunday).
  DateTime get endOfWeek {
    return add(Duration(days: 7 - weekday)).endOfDay;
  }

  /// Returns the start of the month.
  DateTime get startOfMonth => DateTime(year, month);

  /// Returns the end of the month.
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59);

  /// Whether the date is in the past.
  bool get isPast => isBefore(DateTime.now());

  /// Whether the date is in the future.
  bool get isFuture => isAfter(DateTime.now());

  /// Whether this date is on the same day as [other].
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Whether this date is in the same month as [other].
  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  /// Returns a new [DateTime] with [days] added.
  DateTime addDays(int days) => add(Duration(days: days));

  /// Returns a new [DateTime] with [days] subtracted.
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  /// Returns a new [DateTime] with [months] added.
  DateTime addMonths(int months) {
    final newMonth = month + months;
    final newYear = year + (newMonth - 1) ~/ 12;
    final adjustedMonth = ((newMonth - 1) % 12) + 1;
    final lastDayOfMonth = DateTime(newYear, adjustedMonth + 1, 0).day;
    final newDay = day > lastDayOfMonth ? lastDayOfMonth : day;
    return DateTime(newYear, adjustedMonth, newDay, hour, minute, second);
  }

  /// Calculates age based on this date.
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
  /// Attempts to parse to an [int].
  int? tryParseInt() => int.tryParse(this);

  /// Attempts to parse to a [double].
  double? tryParseDouble() => double.tryParse(this);

  /// Attempts to parse as ISO 8601 date.
  DateTime? tryParseISO() => dateFormatter.parseISO(this);

  /// Attempts to parse as display date.
  DateTime? tryParseDisplay() => dateFormatter.parseDisplay(this);

  /// Whether the string is null (if applicable) or empty.
  bool get isNullOrEmpty => trim().isEmpty;

  /// Whether the string is not empty.
  bool get isNotNullOrEmpty => trim().isNotEmpty;

  /// Validates email format.
  bool get isValidEmail {
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(this);
  }

  /// Validates Khmer phone number format.
  bool get isValidKhmerPhone {
    final cleaned = replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final localPattern = RegExp(r'^0[16789]\d{7}$');
    final intlPattern = RegExp(r'^(\+855|855)[16789]\d{7}$');
    return localPattern.hasMatch(cleaned) || intlPattern.hasMatch(cleaned);
  }

  /// Whether the string contains Khmer characters.
  bool get isKhmer {
    return RegExp(r'[\u1780-\u17FF]').hasMatch(this);
  }

  /// Whether the string contains Khmer characters.
  bool get containsKhmer {
    return RegExp(r'[\u1780-\u17FF]').hasMatch(this);
  }

  /// Capitalizes the first character.
  String get capitalize {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Converts to Title Case.
  String get titleCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncates the string with ellipses if it exceeds [maxLength].
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Returns only the numeric digits from the string.
  String get onlyDigits => replaceAll(RegExp(r'\D'), '');

  /// Formats the string as a Khmer phone number.
  String get formatAsKhmerPhone {
    final digits = onlyDigits;
    if (digits.startsWith('855') && digits.length == 11) {
      return '+855 ${digits.substring(3, 4)} ${digits.substring(4, 7)} ${digits.substring(7)}';
    } else if (digits.startsWith('0') && digits.length == 10) {
      return '0${digits[1]} ${digits.substring(2, 5)} ${digits.substring(5)}';
    }
    return this;
  }

  /// Trims the string.
  String safeTrim() => trim();

  /// Returns [defaultValue] if the string is empty.
  String or(String defaultValue) => isNullOrEmpty ? defaultValue : this;

  /// Returns null if the string is empty.
  String? orNull() => isNullOrEmpty ? null : this;
}
