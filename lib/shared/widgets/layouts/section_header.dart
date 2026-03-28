import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// KhmerBiz POS Section Header
///
/// Section header with bilingual title (Khmer large + English small)
/// and optional action button.
///
/// Features:
/// - Khmer title (large, bold)
/// - English subtitle (smaller, secondary)
/// - Optional action button
/// - Optional divider
///
/// Usage:
/// ```dart
/// // Simple header
/// SectionHeader(
///   title: 'Cart Items',
///   titleKhmer: 'មុខទំនិញក្នុងកន្ត្រក',
/// )
///
/// // Header with action
/// SectionHeader(
///   title: 'Products',
///   titleKhmer: 'ផលិតផល',
///   actionLabel: 'View All',
///   actionLabelKhmer: 'មើលទាំងអស់',
///   onAction: () => _viewAll(),
/// )
/// ```
class SectionHeader extends StatelessWidget {

  const SectionHeader({
    super.key,
    this.title,
    this.titleKhmer,
    this.subtitle,
    this.subtitleKhmer,
    this.actionLabel,
    this.actionLabelKhmer,
    this.onAction,
    this.showDivider = true,
    this.padding,
  });
  /// Title (English)
  final String? title;

  /// Title (Khmer - primary)
  final String? titleKhmer;

  /// Subtitle/description (English)
  final String? subtitle;

  /// Subtitle/description (Khmer)
  final String? subtitleKhmer;

  /// Action button label (English)
  final String? actionLabel;

  /// Action button label (Khmer)
  final String? actionLabelKhmer;

  /// Callback when action is tapped
  final VoidCallback? onAction;

  /// Show divider below header
  final bool showDivider;

  /// Padding around header
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
          child: Row(
            children: [
              // Title
              Expanded(
                child: _buildTitle(),
              ),

              // Action button
              if (onAction != null && (actionLabel != null || actionLabelKhmer != null))
                TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (actionLabelKhmer != null) ...[
                        Text(
                          actionLabelKhmer!,
                          style: const TextStyle(
                            fontFamily: 'Kantumruy Pro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                      ],
                      if (actionLabel != null)
                        Text(
                          actionLabel!,
                          style: const TextStyle(
                            fontFamily: 'Kantumruy Pro',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: AppColors.primary,
                          ),
                        ),
                      const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Khmer title (primary)
        if (titleKhmer != null)
          Text(
            titleKhmer!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),

        // English title (secondary)
        if (title != null) ...[
          if (titleKhmer != null) const SizedBox(height: 2),
          Text(
            title!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],

        // Subtitle
        if (subtitle != null || subtitleKhmer != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildSubtitle(),
        ],
      ],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subtitleKhmer != null) ...[
          Text(
            subtitleKhmer!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 13,
              fontWeight: FontWeight.normal,
              height: 1.4,
              color: AppColors.textHint,
            ),
          ),
          if (subtitle != null) const SizedBox(height: 2),
        ],
        if (subtitle != null)
          Text(
            subtitle!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              height: 1.4,
              color: AppColors.textHint,
            ),
          ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('titleKhmer', titleKhmer));
    properties.add(StringProperty('subtitle', subtitle));
    properties.add(StringProperty('subtitleKhmer', subtitleKhmer));
    properties.add(StringProperty('actionLabel', actionLabel));
    properties.add(StringProperty('actionLabelKhmer', actionLabelKhmer));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onAction', onAction));
    properties.add(DiagnosticsProperty<bool>('showDivider', showDivider));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
  }
}

/// Compact section header for cards
class SectionHeaderCompact extends StatelessWidget {

  const SectionHeaderCompact({
    super.key,
    required this.title,
    this.titleKhmer,
    this.icon,
    this.onAction,
    this.actionIcon,
  });
  final String title;
  final String? titleKhmer;
  final IconData? icon;
  final VoidCallback? onAction;
  final IconData? actionIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
          ],
          if (titleKhmer != null) ...[
            Text(
              titleKhmer!,
              style: const TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
          ],
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          if (onAction != null)
            IconButton(
              icon: Icon(actionIcon ?? Icons.more_horiz, size: 20),
              onPressed: onAction,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('titleKhmer', titleKhmer));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onAction', onAction));
    properties.add(DiagnosticsProperty<IconData?>('actionIcon', actionIcon));
  }
}
