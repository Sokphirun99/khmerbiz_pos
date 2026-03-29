import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Stock status
enum StockStatus {
  /// In stock (quantity > low threshold)
  inStock,

  /// Low stock (quantity <= low threshold)
  lowStock,

  /// Out of stock (quantity = 0)
  outOfStock,
}

/// Stock badge style
enum StockBadgeStyle {
  /// Compact: Icon + short text
  compact,

  /// Full: Icon + descriptive text
  full,

  /// Dot: Color dot only
  dot,
}

/// KhmerBiz POS Stock Badge
///
/// Compact colored badge showing stock status.
///
/// Features:
/// - Color-coded: green (ok), amber (low), red (out)
/// - Icon + text
/// - Three styles: compact, full, dot
/// - Rounded corners
///
/// Usage:
/// ```dart
/// // Compact badge
/// StockBadge(
///   status: StockStatus.lowStock,
///   quantity: 3,
///   style: StockBadgeStyle.compact,
/// )
///
/// // Full badge with custom threshold
/// StockBadge(
///   status: StockStatus.inStock,
///   quantity: 50,
///   lowThreshold: 10,
///   style: StockBadgeStyle.full,
/// )
/// ```
class StockBadge extends StatelessWidget {
  const StockBadge({
    required this.status,
    super.key,
    this.quantity = 0,
    this.lowThreshold = 10,
    this.style = StockBadgeStyle.compact,
    this.lowStockText,
    this.outOfStockText,
    this.inStockText,
    this.hideWhenInStock = false,
  });

  /// Create from quantity and threshold
  factory StockBadge.fromQuantity({
    required int quantity,
    int lowThreshold = 10,
    StockBadgeStyle style = StockBadgeStyle.compact,
    bool hideWhenInStock = false,
  }) {
    final StockStatus status;
    if (quantity == 0) {
      status = StockStatus.outOfStock;
    } else if (quantity <= lowThreshold) {
      status = StockStatus.lowStock;
    } else {
      status = StockStatus.inStock;
    }

    return StockBadge(
      status: status,
      quantity: quantity,
      lowThreshold: lowThreshold,
      style: style,
      hideWhenInStock: hideWhenInStock,
    );
  }

  /// Stock status
  final StockStatus status;

  /// Current quantity
  final int quantity;

  /// Low stock threshold
  final int lowThreshold;

  /// Badge style
  final StockBadgeStyle style;

  /// Custom text for low stock
  final String? lowStockText;

  /// Custom text for out of stock
  final String? outOfStockText;

  /// Custom text for in stock
  final String? inStockText;

  /// Hide when in stock (show only for low/out)
  final bool hideWhenInStock;

  @override
  Widget build(BuildContext context) {
    // Hide if in stock and hideWhenInStock is true
    if (hideWhenInStock && status == StockStatus.inStock) {
      return const SizedBox.shrink();
    }

    final color = _getColor();
    final icon = _getIcon();
    final text = _getText();

    if (style == StockBadgeStyle.dot) {
      return _buildDot(color);
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal:
            style == StockBadgeStyle.compact ? AppSpacing.sm : AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: style == StockBadgeStyle.compact ? 12 : 14,
            color: color,
          ),
          if (style == StockBadgeStyle.full) ...[
            const SizedBox(width: AppSpacing.xs),
          ] else ...[
            const SizedBox(width: 4),
          ],
          if (style == StockBadgeStyle.full || style == StockBadgeStyle.compact)
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: style == StockBadgeStyle.compact ? 10 : 12,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: color,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case StockStatus.inStock:
        return AppColors.success;
      case StockStatus.lowStock:
        return AppColors.warning;
      case StockStatus.outOfStock:
        return AppColors.error;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case StockStatus.inStock:
        return Icons.check_circle;
      case StockStatus.lowStock:
        return Icons.warning_amber;
      case StockStatus.outOfStock:
        return Icons.cancel;
    }
  }

  String _getText() {
    // Use custom text if provided
    if (status == StockStatus.inStock && inStockText != null) {
      return inStockText!;
    }
    if (status == StockStatus.lowStock && lowStockText != null) {
      return lowStockText!;
    }
    if (status == StockStatus.outOfStock && outOfStockText != null) {
      return outOfStockText!;
    }

    // Default text based on style
    switch (status) {
      case StockStatus.inStock:
        return style == StockBadgeStyle.full ? 'In Stock' : '✓';
      case StockStatus.lowStock:
        return style == StockBadgeStyle.full
            ? 'Low: $quantity left'
            : '$quantity left';
      case StockStatus.outOfStock:
        return style == StockBadgeStyle.full ? 'Out of Stock' : '✗';
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<StockStatus>('status', status));
    properties.add(IntProperty('quantity', quantity));
    properties.add(IntProperty('lowThreshold', lowThreshold));
    properties.add(EnumProperty<StockBadgeStyle>('style', style));
    properties.add(StringProperty('lowStockText', lowStockText));
    properties.add(StringProperty('outOfStockText', outOfStockText));
    properties.add(StringProperty('inStockText', inStockText));
    properties
        .add(DiagnosticsProperty<bool>('hideWhenInStock', hideWhenInStock));
  }
}

/// Stock badge with product name for low stock warnings
class StockWarningBadge extends StatelessWidget {
  const StockWarningBadge({
    required this.productName,
    required this.quantity,
    super.key,
    this.productNameKhmer,
    this.lowThreshold = 10,
    this.onTap,
  });
  final String productName;
  final String? productNameKhmer;
  final int quantity;
  final int lowThreshold;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: AppColors.warning.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warning,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (productNameKhmer != null) ...[
                    Text(
                      productNameKhmer!,
                      style: const TextStyle(
                        fontFamily: 'Kantumruy Pro',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    productName,
                    style: const TextStyle(
                      fontFamily: 'Kantumruy Pro',
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                      height: 1.3,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Only $quantity items left',
                    style: const TextStyle(
                      fontFamily: 'Kantumruy Pro',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.warning,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('productName', productName));
    properties.add(StringProperty('productNameKhmer', productNameKhmer));
    properties.add(IntProperty('quantity', quantity));
    properties.add(IntProperty('lowThreshold', lowThreshold));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}
