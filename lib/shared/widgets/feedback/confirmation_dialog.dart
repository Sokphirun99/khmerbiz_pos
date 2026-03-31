import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Confirmation dialog type
enum ConfirmationDialogType {
  /// Default confirmation
  confirm,

  /// Danger action (delete, void)
  danger,

  /// Info confirmation
  info,
}

/// KhmerBiz POS Confirmation Dialog
///
/// Bilingual confirmation dialog for critical actions.
///
/// Features:
/// - Khmer title + English subtitle
/// - Danger/confirm button pair
/// - Three types: confirm, danger, info
/// - Custom content support
///
/// Usage:
/// ```dart
/// // Delete confirmation
/// showDialog(
///   context: context,
///   builder: (context) => ConfirmationDialog(
///     title: 'Delete Product?',
///     titleKhmer: 'លុបផលិតផល?',
///     subtitle: 'This action cannot be undone',
///     subtitleKhmer: 'សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ',
///     type: ConfirmationDialogType.danger,
///     confirmLabel: 'Delete',
///     confirmLabelKhmer: 'លុប',
///     onConfirm: () => _deleteProduct(),
///   ),
/// )
///
/// // Simple confirmation
/// showDialog(
///   context: context,
///   builder: (context) => ConfirmationDialog(
///     title: 'Clear Cart?',
///     titleKhmer: 'សម្អាតកន្ត្រក?',
///     onConfirm: () => _clearCart(),
///   ),
/// )
/// ```
class ConfirmationDialog extends StatelessWidget {
  /// Creates a [ConfirmationDialog].
  const ConfirmationDialog({
    super.key,
    this.title,
    this.titleKhmer,
    this.subtitle,
    this.subtitleKhmer,
    this.type = ConfirmationDialogType.confirm,
    this.confirmLabel,
    this.confirmLabelKhmer,
    this.cancelLabel,
    this.cancelLabelKhmer,
    this.onConfirm,
    this.onCancel,
    this.content,
    this.showCancel = true,
    this.isLoading = false,
  });

  /// Dialog title (English)
  final String? title;

  /// Dialog title (Khmer - primary)
  final String? titleKhmer;

  /// Dialog subtitle (English)
  final String? subtitle;

  /// Dialog subtitle (Khmer)
  final String? subtitleKhmer;

  /// Dialog type
  final ConfirmationDialogType type;

  /// Confirm button label (English)
  final String? confirmLabel;

  /// Confirm button label (Khmer)
  final String? confirmLabelKhmer;

  /// Cancel button label (English)
  final String? cancelLabel;

  /// Cancel button label (Khmer)
  final String? cancelLabelKhmer;

  /// Callback when confirm is tapped
  final VoidCallback? onConfirm;

  /// Callback when cancel is tapped
  final VoidCallback? onCancel;

  /// Custom content widget
  final Widget? content;

  /// Show cancel button
  final bool showCancel;

  /// Whether confirm is loading
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            if (config.icon != null) ...[
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: config.iconColor!.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  config.icon,
                  size: 32,
                  color: config.iconColor,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Custom content or title/subtitle
            if (content != null) ...[
              content!,
            ] else ...[
              // Title
              if (config.titleKhmer != null || config.title != null) ...[
                _buildTitle(config.titleKhmer, config.title),
                const SizedBox(height: AppSpacing.xs),
              ],

              // Subtitle
              if (config.subtitleKhmer != null || config.subtitle != null) ...[
                _buildSubtitle(config.subtitleKhmer, config.subtitle),
              ],
            ],

            // Buttons
            const SizedBox(height: AppSpacing.lg),
            _buildButtons(context, config),
          ],
        ),
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

  Widget _buildButtons(BuildContext context, _DialogConfig config) {
    if (!showCancel) {
      return SizedBox(
        width: double.infinity,
        height: AppSpacing.buttonHeightPrimary,
        child: ElevatedButton(
          onPressed: isLoading ? null : onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: config.confirmColor,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (config.confirmLabelKhmer != null) ...[
                      Text(
                        config.confirmLabelKhmer!,
                        style: const TextStyle(
                          fontFamily: 'Kantumruy Pro',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      const Text('• '),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      config.confirmLabel ?? 'Confirm',
                      style: const TextStyle(
                        fontFamily: 'Kantumruy Pro',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
        ),
      );
    }

    return Row(
      children: [
        // Cancel button
        Expanded(
          child: SizedBox(
            height: AppSpacing.buttonHeightPrimary,
            child: OutlinedButton(
              onPressed:
                  isLoading ? null : (onCancel ?? () => Navigator.pop(context)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
              child: Text(
                cancelLabelKhmer ?? cancelLabel ?? 'Cancel',
                style: const TextStyle(
                  fontFamily: 'Kantumruy Pro',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        // Confirm button
        Expanded(
          child: SizedBox(
            height: AppSpacing.buttonHeightPrimary,
            child: ElevatedButton(
              onPressed: isLoading ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: config.confirmColor,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (config.confirmLabelKhmer != null) ...[
                          Text(
                            config.confirmLabelKhmer!,
                            style: const TextStyle(
                              fontFamily: 'Kantumruy Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          const Text('• '),
                          const SizedBox(width: AppSpacing.xs),
                        ],
                        Text(
                          config.confirmLabel ?? 'Confirm',
                          style: const TextStyle(
                            fontFamily: 'Kantumruy Pro',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  _DialogConfig _getConfig() {
    switch (type) {
      case ConfirmationDialogType.confirm:
        return _DialogConfig(
          title: title ?? 'Confirm Action',
          titleKhmer: titleKhmer ?? 'បញ្ជាក់សកម្មភាព',
          subtitle: subtitle,
          subtitleKhmer: subtitleKhmer,
          confirmLabel: confirmLabel ?? 'Confirm',
          confirmLabelKhmer: confirmLabelKhmer,
          confirmColor: AppColors.primary,
          icon: Icons.help_outline,
          iconColor: AppColors.info,
        );

      case ConfirmationDialogType.danger:
        return _DialogConfig(
          title: title ?? 'Delete Item?',
          titleKhmer: titleKhmer ?? 'លុបធាតុ?',
          subtitle: subtitle ?? 'This action cannot be undone',
          subtitleKhmer: subtitleKhmer ?? 'សកម្មភាពនេះមិនអាចត្រឡប់វិញបានទេ',
          confirmLabel: confirmLabel ?? 'Delete',
          confirmLabelKhmer: confirmLabelKhmer ?? 'លុប',
          confirmColor: AppColors.error,
          icon: Icons.delete_outline,
          iconColor: AppColors.error,
        );

      case ConfirmationDialogType.info:
        return _DialogConfig(
          title: title ?? 'Information',
          titleKhmer: titleKhmer ?? 'ព័ត៌មាន',
          subtitle: subtitle,
          subtitleKhmer: subtitleKhmer,
          confirmLabel: confirmLabel ?? 'OK',
          confirmLabelKhmer: confirmLabelKhmer ?? 'យល់ព្រម',
          confirmColor: AppColors.info,
          icon: Icons.info_outline,
          iconColor: AppColors.info,
        );
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('title', title));
    properties.add(StringProperty('titleKhmer', titleKhmer));
    properties.add(StringProperty('subtitle', subtitle));
    properties.add(StringProperty('subtitleKhmer', subtitleKhmer));
    properties.add(EnumProperty<ConfirmationDialogType>('type', type));
    properties.add(StringProperty('confirmLabel', confirmLabel));
    properties.add(StringProperty('confirmLabelKhmer', confirmLabelKhmer));
    properties.add(StringProperty('cancelLabel', cancelLabel));
    properties.add(StringProperty('cancelLabelKhmer', cancelLabelKhmer));
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onConfirm', onConfirm));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onCancel', onCancel));
    properties.add(DiagnosticsProperty<bool>('showCancel', showCancel));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
  }
}

/// Internal configuration for the dialog based on its type.
class _DialogConfig {
  /// Creates a [_DialogConfig].
  const _DialogConfig({
    required this.confirmColor,
    this.title,
    this.titleKhmer,
    this.subtitle,
    this.subtitleKhmer,
    this.confirmLabel,
    this.confirmLabelKhmer,
    this.icon,
    this.iconColor,
  });
  final String? title;
  final String? titleKhmer;
  final String? subtitle;
  final String? subtitleKhmer;
  final String? confirmLabel;
  final String? confirmLabelKhmer;
  final Color confirmColor;
  final IconData? icon;
  final Color? iconColor;
}

/// Helper function to show a standard confirmation dialog.
///
/// Returns `true` if the user confirmed, `false` otherwise.
Future<bool> showConfirmationDialog({
    required BuildContext context,
    String? title,
    String? titleKhmer,
    String? subtitle,
    String? subtitleKhmer,
    String? confirmLabel,
    String? confirmLabelKhmer,
    ConfirmationDialogType type = ConfirmationDialogType.confirm,
  }) async {
  return await showDialog<bool>(
        context: context,
        builder: (context) => ConfirmationDialog(
          title: title,
          titleKhmer: titleKhmer,
          subtitle: subtitle,
          subtitleKhmer: subtitleKhmer,
          type: type,
          confirmLabel: confirmLabel,
          confirmLabelKhmer: confirmLabelKhmer,
          onConfirm: () => Navigator.pop(context, true),
        ),
      ) ??
      false;
}
