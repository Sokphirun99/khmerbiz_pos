import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Price display size
enum PriceSize {
  /// Small: For compact displays (list items)
  small,

  /// Medium: For standard displays (product cards)
  medium,

  /// Large: For prominent displays (totals, checkout)
  large,
}

/// KhmerBiz POS Price Display
///
/// Displays currency amounts in KHR (primary) and USD (optional secondary).
///
/// Features:
/// - Roboto Mono font for column alignment
/// - KHR with riel symbol (៛)
/// - USD equivalent with ≈ prefix
/// - Never shows negative amounts
/// - Three size variants
///
/// Usage:
/// ```dart
/// // Product card price
/// PriceDisplay(
///   amountKHR: 12500,
///   showUSD: true,
///   size: PriceSize.medium,
/// )
///
/// // Cart total (large)
/// PriceDisplay(
///   amountKHR: 125000,
///   showUSD: true,
///   size: PriceSize.large,
/// )
/// ```
class PriceDisplay extends StatelessWidget {
  const PriceDisplay({
    required this.amountKHR,
    super.key,
    this.amountUSD,
    this.showUSD = true,
    this.size = PriceSize.medium,
    this.exchangeRate = 4100,
    this.color,
    this.showSymbol = true,
    this.showSeparator = true,
  });

  /// Amount in Cambodian Riel (KHR)
  final double amountKHR;

  /// Amount in USD (optional, auto-calculated if not provided)
  final double? amountUSD;

  /// Whether to show USD equivalent
  final bool showUSD;

  /// Display size
  final PriceSize size;

  /// Exchange rate (default: 4100 KHR/USD)
  final double exchangeRate;

  /// Text color (default: primary color)
  final Color? color;

  /// Show currency symbol
  final bool showSymbol;

  /// Show thousand separator
  final bool showSeparator;

  @override
  Widget build(BuildContext context) {
    // Never show negative amounts
    final effectiveAmountKHR = amountKHR.abs();
    final effectiveAmountUSD =
        amountUSD?.abs() ?? (effectiveAmountKHR / exchangeRate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // KHR amount (primary)
        Text(
          _formatKHR(effectiveAmountKHR),
          style: _getPrimaryTextStyle(),
        ),
        // USD amount (secondary, optional)
        if (showUSD) ...[
          const SizedBox(height: 2),
          Text(
            '≈ \$${effectiveAmountUSD.toStringAsFixed(2)}',
            style: _getSecondaryTextStyle(),
          ),
        ],
      ],
    );
  }

  TextStyle _getPrimaryTextStyle() {
    final textColor = color ?? AppColors.textPrimary;

    switch (size) {
      case PriceSize.small:
        return const TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ).copyWith(color: textColor);
      case PriceSize.medium:
        return const TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ).copyWith(color: textColor);
      case PriceSize.large:
        return const TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: -0.5,
        ).copyWith(color: textColor);
    }
  }

  TextStyle _getSecondaryTextStyle() {
    switch (size) {
      case PriceSize.small:
        return const TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 10,
          fontWeight: FontWeight.normal,
          height: 1.2,
          color: AppColors.textHint,
        );
      case PriceSize.medium:
        return const TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.2,
          color: AppColors.textHint,
        );
      case PriceSize.large:
        return const TextStyle(
          fontFamily: 'Roboto Mono',
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.2,
          color: AppColors.textSecondary,
        );
    }
  }

  String _formatKHR(double amount) {
    final formatted = showSeparator
        ? amount.toStringAsFixed(0).replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            )
        : amount.toStringAsFixed(0);

    return showSymbol ? '៛$formatted' : formatted;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('amountKHR', amountKHR));
    properties.add(DoubleProperty('amountUSD', amountUSD));
    properties.add(DiagnosticsProperty<bool>('showUSD', showUSD));
    properties.add(EnumProperty<PriceSize>('size', size));
    properties.add(DoubleProperty('exchangeRate', exchangeRate));
    properties.add(ColorProperty('color', color));
    properties.add(DiagnosticsProperty<bool>('showSymbol', showSymbol));
    properties.add(DiagnosticsProperty<bool>('showSeparator', showSeparator));
  }
}

/// Compact price display for tight spaces
class PriceCompact extends StatelessWidget {
  const PriceCompact({
    required this.amountKHR,
    super.key,
    this.amountUSD,
    this.showUSD = false,
    this.color,
  });
  final double amountKHR;
  final double? amountUSD;
  final bool showUSD;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final effectiveAmountKHR = amountKHR.abs();

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          '៛',
          style: TextStyle(
            fontFamily: 'Roboto Mono',
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.primary,
          ),
        ),
        const SizedBox(width: 2),
        Text(
          _formatNumber(effectiveAmountKHR),
          style: TextStyle(
            fontFamily: 'Roboto Mono',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? AppColors.primary,
          ),
        ),
        if (showUSD && amountUSD != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Text(
            '(\$${amountUSD!.toStringAsFixed(2)})',
            style: const TextStyle(
              fontFamily: 'Roboto Mono',
              fontSize: 11,
              fontWeight: FontWeight.normal,
              color: AppColors.textHint,
            ),
          ),
        ],
      ],
    );
  }

  String _formatNumber(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('amountKHR', amountKHR));
    properties.add(DoubleProperty('amountUSD', amountUSD));
    properties.add(DiagnosticsProperty<bool>('showUSD', showUSD));
    properties.add(ColorProperty('color', color));
  }
}
