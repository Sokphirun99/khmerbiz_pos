import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';

/// Loading skeleton for printer device list items.
class PrinterDeviceLoadingSkeleton extends StatelessWidget {
  /// Creates a [PrinterDeviceLoadingSkeleton].
  const PrinterDeviceLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      ),
      child: Row(
        children: [
          // Printer icon placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
          ),
          const SizedBox(width: AppSpacing.base),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: 120,
                  color: AppColors.border,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 12,
                  width: 80,
                  color: AppColors.border,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state when no printers are found.
class PrinterEmptyState extends StatelessWidget {
  /// Creates a [PrinterEmptyState].
  const PrinterEmptyState({
    required this.message,
    required this.icon,
    super.key,
  });

  /// Message to display.
  final String message;

  /// Icon to display.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textHint,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Connecting indicator overlay.
class ConnectingIndicator extends StatelessWidget {
  /// Creates a [ConnectingIndicator].
  const ConnectingIndicator({
    required this.deviceName,
    super.key,
  });

  /// Name of the device being connected to.
  final String deviceName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primary,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Connecting to $deviceName...',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'កំពុងតភ្ជាប់ទៅ $deviceName...',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
