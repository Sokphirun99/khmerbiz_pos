import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Empty state variant
enum EmptyStateVariant {
  /// Empty cart
  emptyCart,

  /// No products
  noProducts,

  /// No transactions
  noTransactions,

  /// No customers
  noCustomers,

  /// No internet connection
  noInternet,

  /// No search results
  noResults,

  /// No notifications
  noNotifications,

  /// Generic empty state
  generic,
}

/// KhmerBiz POS Empty State
///
/// Centered illustration with bilingual title and action button.
///
/// Features:
/// - Pre-built variants for common empty states
/// - Bilingual title (Khmer + English)
/// - Optional subtitle
/// - Optional action button
/// - Custom illustration support
///
/// Usage:
/// ```dart
/// // Pre-built variant
/// EmptyState(
///   variant: EmptyStateVariant.emptyCart,
///   actionLabel: 'Browse Products',
///   actionLabelKhmer: 'មើលផលិតផល',
///   onAction: () => _browseProducts(),
/// )
///
/// // Custom empty state
/// EmptyState(
///   title: 'No Items',
///   titleKhmer: 'គ្មានធាតុ',
///   subtitle: 'Add items to get started',
///   subtitleKhmer: 'បន្ថែមធាតុដើម្បីចាប់ផ្តើម',
///   icon: Icons.inventory_2_outlined,
///   actionLabel: 'Add Item',
///   onAction: () => _addItem(),
/// )
/// ```
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.variant,
    this.title,
    this.titleKhmer,
    this.subtitle,
    this.subtitleKhmer,
    this.icon,
    this.illustration,
    this.actionLabel,
    this.actionLabelKhmer,
    this.onAction,
    this.maxWidth,
    this.padding,
  });

  /// Empty state variant (pre-built)
  final EmptyStateVariant? variant;

  /// Title (English)
  final String? title;

  /// Title (Khmer - primary)
  final String? titleKhmer;

  /// Subtitle (English)
  final String? subtitle;

  /// Subtitle (Khmer)
  final String? subtitleKhmer;

  /// Custom icon
  final IconData? icon;

  /// Custom illustration widget
  final Widget? illustration;

  /// Action button label (English)
  final String? actionLabel;

  /// Action button label (Khmer)
  final String? actionLabelKhmer;

  /// Callback when action is tapped
  final VoidCallback? onAction;

  /// Maximum width of the content
  final double? maxWidth;

  /// Padding around content
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth ?? 400),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              if (illustration != null) ...[
                illustration!,
                const SizedBox(height: AppSpacing.xl),
              ] else if (config.icon != null) ...[
                _buildIcon(config.icon!, config.iconColor),
                const SizedBox(height: AppSpacing.xl),
              ],

              // Title
              if (config.titleKhmer != null || config.title != null) ...[
                _buildTitle(config.titleKhmer, config.title),
                const SizedBox(height: AppSpacing.sm),
              ],

              // Subtitle
              if (config.subtitleKhmer != null || config.subtitle != null) ...[
                _buildSubtitle(config.subtitleKhmer, config.subtitle),
                const SizedBox(height: AppSpacing.lg),
              ] else ...[
                const SizedBox(height: AppSpacing.lg),
              ],

              // Action button
              if (onAction != null &&
                  (config.actionLabel != null ||
                      config.actionLabelKhmer != null))
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onAction,
                    icon: const Icon(Icons.add_shopping_cart, size: 20),
                    label: Row(
                      children: [
                        if (config.actionLabelKhmer != null) ...[
                          Text(
                            config.actionLabelKhmer!,
                            style: const TextStyle(
                              fontFamily: 'Kantumruy Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Text(
                            '•',
                            style: TextStyle(
                              fontFamily: 'Kantumruy Pro',
                              fontSize: 16,
                              color: AppColors.textHint,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Expanded(
                          child: Text(
                            config.actionLabel ?? '',
                            style: const TextStyle(
                              fontFamily: 'Kantumruy Pro',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, Color? color) {
    final effectiveColor = color ?? AppColors.textHint;
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: effectiveColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 64,
        color: effectiveColor.withOpacity(0.5),
      ),
    );
  }

  Widget _buildTitle(String? titleKhmer, String? title) {
    return Column(
      children: [
        if (titleKhmer != null)
          Text(
            titleKhmer,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        if (title != null) ...[
          if (titleKhmer != null) const SizedBox(height: AppSpacing.xs),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 18,
              fontWeight: FontWeight.normal,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildSubtitle(String? subtitleKhmer, String? subtitle) {
    return Column(
      children: [
        if (subtitleKhmer != null)
          Text(
            subtitleKhmer,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 14,
              fontWeight: FontWeight.normal,
              height: 1.5,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        if (subtitle != null) ...[
          if (subtitleKhmer != null) const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 13,
              fontWeight: FontWeight.normal,
              height: 1.5,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  _EmptyStateConfig _getConfig() {
    // Use custom values if provided
    if (title != null || titleKhmer != null) {
      return _EmptyStateConfig(
        title: title,
        titleKhmer: titleKhmer,
        subtitle: subtitle,
        subtitleKhmer: subtitleKhmer,
        icon: icon,
        actionLabel: actionLabel,
        actionLabelKhmer: actionLabelKhmer,
      );
    }

    // Use variant config
    if (variant != null) {
      return _getVariantConfig(variant!);
    }

    // Default generic config
    return const _EmptyStateConfig(
      title: 'No Data',
      titleKhmer: 'គ្មានទិន្នន័យ',
      subtitle: 'There is no data to display',
      subtitleKhmer: 'គ្មានទិន្នន័យសម្រាប់បង្ហាញ',
      icon: Icons.inbox_outlined,
    );
  }

  _EmptyStateConfig _getVariantConfig(EmptyStateVariant variant) {
    switch (variant) {
      case EmptyStateVariant.emptyCart:
        return const _EmptyStateConfig(
          title: 'Cart is Empty',
          titleKhmer: 'កន្ត្រកទទេ',
          subtitle: 'Add products to your cart',
          subtitleKhmer: 'បន្ថែមផលិតផលទៅកន្ត្រករបស់អ្នក',
          icon: Icons.shopping_cart_outlined,
          iconColor: AppColors.primary,
          actionLabel: 'Browse Products',
          actionLabelKhmer: 'មើលផលិតផល',
        );

      case EmptyStateVariant.noProducts:
        return const _EmptyStateConfig(
          title: 'No Products',
          titleKhmer: 'គ្មានផលិតផល',
          subtitle: 'Add products to get started',
          subtitleKhmer: 'បន្ថែមផលិតផលដើម្បីចាប់ផ្តើម',
          icon: Icons.inventory_2_outlined,
          iconColor: AppColors.info,
          actionLabel: 'Add Product',
          actionLabelKhmer: 'បន្ថែមផលិតផល',
        );

      case EmptyStateVariant.noTransactions:
        return const _EmptyStateConfig(
          title: 'No Transactions',
          titleKhmer: 'គ្មានប្រតិបត្តិការ',
          subtitle: 'Transactions will appear here',
          subtitleKhmer: 'ប្រតិបត្តិការនឹងលេចឡើងនៅទីនេះ',
          icon: Icons.receipt_long_outlined,
          iconColor: AppColors.success,
        );

      case EmptyStateVariant.noCustomers:
        return const _EmptyStateConfig(
          title: 'No Customers',
          titleKhmer: 'គ្មានអតិថិជន',
          subtitle: 'Add customers to manage relationships',
          subtitleKhmer: 'បន្ថែមអតិថិជនដើម្បីគ្រប់គ្រង',
          icon: Icons.people_outline,
          iconColor: AppColors.accent,
          actionLabel: 'Add Customer',
          actionLabelKhmer: 'បន្ថែមអតិថិជន',
        );

      case EmptyStateVariant.noInternet:
        return const _EmptyStateConfig(
          title: 'No Internet',
          titleKhmer: 'គ្មានអ៊ីនធឺណិត',
          subtitle: 'Check your connection and try again',
          subtitleKhmer: 'ពិនិត្យមើលការតភ្ជាប់របស់អ្នកហើយព្យាយាមម្តងទៀត',
          icon: Icons.cloud_off_outlined,
          iconColor: AppColors.warning,
          actionLabel: 'Retry',
          actionLabelKhmer: 'ព្យាយាមម្តងទៀត',
        );

      case EmptyStateVariant.noResults:
        return const _EmptyStateConfig(
          title: 'No Results',
          titleKhmer: 'គ្មានលទ្ធផល',
          subtitle: 'Try a different search term',
          subtitleKhmer: 'សាកល្បងពាក្យស្វែងរកផ្សេងទៀត',
          icon: Icons.search_off,
          iconColor: AppColors.textHint,
        );

      case EmptyStateVariant.noNotifications:
        return const _EmptyStateConfig(
          title: 'No Notifications',
          titleKhmer: 'គ្មានការជូនដំណឹង',
          subtitle: 'You are all caught up',
          subtitleKhmer: 'អ្នកបានមើលការជូនដំណឹងទាំងអស់ហើយ',
          icon: Icons.notifications_none,
          iconColor: AppColors.info,
        );

      case EmptyStateVariant.generic:
        return const _EmptyStateConfig(
          title: 'No Data',
          titleKhmer: 'គ្មានទិន្នន័យ',
          subtitle: 'There is no data to display',
          subtitleKhmer: 'គ្មានទិន្នន័យសម្រាប់បង្ហាញ',
          icon: Icons.inbox_outlined,
          iconColor: AppColors.textHint,
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<EmptyStateVariant?>('variant', variant));
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('titleKhmer', titleKhmer));
    properties.add(StringProperty('subtitle', subtitle));
    properties.add(StringProperty('subtitleKhmer', subtitleKhmer));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(StringProperty('actionLabel', actionLabel));
    properties.add(StringProperty('actionLabelKhmer', actionLabelKhmer));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onAction', onAction));
    properties.add(DoubleProperty('maxWidth', maxWidth));
    properties
        .add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
  }
}

class _EmptyStateConfig {
  const _EmptyStateConfig({
    this.title,
    this.titleKhmer,
    this.subtitle,
    this.subtitleKhmer,
    this.icon,
    this.iconColor,
    this.actionLabel,
    this.actionLabelKhmer,
  });
  final String? title;
  final String? titleKhmer;
  final String? subtitle;
  final String? subtitleKhmer;
  final IconData? icon;
  final Color? iconColor;
  final String? actionLabel;
  final String? actionLabelKhmer;
}
