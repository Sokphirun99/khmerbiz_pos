import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/config/constants.dart';

/// Date formatter supporting both English and Khmer locales.
///
/// KhmerBiz POS displays dates in both languages for clarity.
///
/// Example usage:
/// ```dart
/// final formatter = DateFormatter();
/// formatter.formatDisplay(DateTime.now()); // "28 Mar 2026"
/// formatter.formatKhmer(DateTime.now());   // "២៨ មីនា ២០២៦"
/// formatter.formatDual(DateTime.now());    // "28 Mar 2026 | ២៨ មីនា ២០២៦"
/// ```
final class DateFormatter {
  /// Creates a date formatter.
  DateFormatter();

  /// Format date using display format (dd MMM yyyy).
  ///
  /// [date] - The date to format
  /// Returns formatted string like "28 Mar 2026"
  String formatDisplay(DateTime date) {
    return DateFormat(AppConstants.dateFormatDisplay, 'en_US').format(date);
  }

  /// Format date and time using display format.
  ///
  /// [date] - The date to format
  /// Returns formatted string like "28 Mar 2026 14:30"
  String formatDateTimeDisplay(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormatDisplay, 'en_US').format(date);
  }

  /// Format date in Khmer.
  ///
  /// [date] - The date to format
  /// Returns formatted string in Khmer like "២៨ មីនា ២០២៦"
  String formatKhmer(DateTime date) {
    // Khmer month names
    const khmerMonths = [
      'មករា', // January
      'កុម្ភៈ', // February
      'មីនា', // March
      'មេសា', // April
      'ឧសភា', // May
      'មិថុនា', // June
      'កក្កដា', // July
      'សីហា', // August
      'កញ្ញា', // September
      'តុលា', // October
      'វិច្ឆិកា', // November
      'ធ្នូ', // December
    ];

    final day = _convertToKhmerNumber(date.day);
    final month = khmerMonths[date.month - 1];
    final year = _convertToKhmerNumber(date.year);

    return '$day $month $year';
  }

  /// Format date and time in Khmer.
  ///
  /// [date] - The date to format
  /// Returns formatted string in Khmer with time
  String formatDateTimeKhmer(DateTime date) {
    final datePart = formatKhmer(date);
    final hour = _convertToKhmerNumber(date.hour);
    final minute =
        _convertToKhmerNumber(date.minute.toString().padLeft(2, '0'));
    return '$datePart $hour:$minute';
  }

  /// Format date showing both English and Khmer.
  ///
  /// [date] - The date to format
  /// Returns formatted string like "28 Mar 2026 | ២៨ មីនា ២០២៦"
  String formatDual(DateTime date) {
    return '${formatDisplay(date)} | ${formatKhmer(date)}';
  }

  /// Format date and time showing both English and Khmer.
  ///
  /// [date] - The date to format
  /// Returns formatted string with both languages and time
  String formatDateTimeDual(DateTime date) {
    return '${formatDateTimeDisplay(date)} | ${formatDateTimeKhmer(date)}';
  }

  /// Format as ISO 8601 string for storage/transmission.
  ///
  /// [date] - The date to format
  /// Returns ISO 8601 formatted string
  String formatISO(DateTime date) {
    return DateFormat(AppConstants.dateTimeFormatISO).format(date);
  }

  /// Format as relative time (e.g., "2 hours ago").
  ///
  /// [date] - The date to format
  /// Returns relative time string in English
  String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Format as relative time in Khmer.
  ///
  /// [date] - The date to format
  /// Returns relative time string in Khmer
  String formatRelativeKhmer(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      final yearsKm = _convertToKhmerNumber(years);
      return '$yearsKm ឆ្នាំមុន';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      final monthsKm = _convertToKhmerNumber(months);
      return '$monthsKm ខែមុន';
    } else if (difference.inDays > 0) {
      final daysKm = _convertToKhmerNumber(difference.inDays);
      return '$daysKm ថ្ងៃមុន';
    } else if (difference.inHours > 0) {
      final hoursKm = _convertToKhmerNumber(difference.inHours);
      return '$hoursKm ម៉ោងមុន';
    } else if (difference.inMinutes > 0) {
      final minutesKm = _convertToKhmerNumber(difference.inMinutes);
      return '$minutesKm នាទីមុន';
    } else {
      return 'ទើបតែប៉ុន្មានវិនាទីមុន';
    }
  }

  /// Parse ISO 8601 string to DateTime.
  ///
  /// [isoString] - ISO 8601 formatted string
  /// Returns DateTime, or null if parsing fails
  DateTime? parseISO(String isoString) {
    try {
      return DateFormat(AppConstants.dateTimeFormatISO).parse(isoString);
    } catch (_) {
      return null;
    }
  }

  /// Parse display format string to DateTime.
  ///
  /// [displayString] - Display format string like "28 Mar 2026"
  /// Returns DateTime, or null if parsing fails
  DateTime? parseDisplay(String displayString) {
    try {
      return DateFormat(AppConstants.dateFormatDisplay, 'en_US')
          .parse(displayString);
    } catch (_) {
      return null;
    }
  }

  /// Check if date is today.
  ///
  /// [date] - The date to check
  /// Returns true if the date is today
  bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday.
  ///
  /// [date] - The date to check
  /// Returns true if the date is yesterday
  bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Format time only (HH:mm).
  ///
  /// [date] - The date to format
  /// Returns time string like "14:30"
  String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  /// Format time in Khmer numerals.
  ///
  /// [date] - The date to format
  /// Returns time string with Khmer numerals
  String formatTimeKhmer(DateTime date) {
    final hour = _convertToKhmerNumber(date.hour);
    final minute = _convertToKhmerNumber(date.minute);
    return '$hour:$minute';
  }

  /// Convert English digits to Khmer digits.
  String _convertToKhmerNumber(dynamic value) {
    final str = value.toString();
    final buffer = StringBuffer();

    for (int i = 0; i < str.length; i++) {
      final codeUnit = str.codeUnitAt(i);
      // English digits '0' (48) to '9' (57)
      if (codeUnit >= 48 && codeUnit <= 57) {
        // Offset to Khmer digits '០' (6112) is 6112 - 48 = 6064
        buffer.writeCharCode(codeUnit + 6064);
      } else {
        buffer.writeCharCode(codeUnit);
      }
    }

    return buffer.toString();
  }

  /// Get day name in Khmer.
  ///
  /// [date] - The date to get day name for
  /// Returns Khmer day name
  String getDayNameKhmer(DateTime date) {
    const khmerDays = [
      'ថ្ងៃអាទិត្យ', // Sunday
      'ថ្ងៃច័ន្ទ', // Monday
      'ថ្ងៃអង្គារ', // Tuesday
      'ថ្ងៃពុធ', // Wednesday
      'ថ្ងៃព្រហស្បតិ៍', // Thursday
      'ថ្ងៃសុក្រ', // Friday
      'ថ្ងៃសៅរ៍', // Saturday
    ];

    return khmerDays[date.weekday % 7];
  }

  /// Get day name in English (short).
  ///
  /// [date] - The date to get day name for
  /// Returns short English day name like "Mon"
  String getDayNameEnglish(DateTime date) {
    return DateFormat('EEE', 'en_US').format(date);
  }
}

/// Global singleton instance for convenience.
final dateFormatter = DateFormatter();

/// Extension on DateTime for convenient date formatting.
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
}
