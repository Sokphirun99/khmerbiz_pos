import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/foundation/app_border.dart';
import '../../../core/theme/foundation/app_radius.dart';
import '../../../core/theme/foundation/app_shadow.dart';

enum KhqrState { generating, ready, success, timeout, offline }

class KhqrDisplayWidget extends StatelessWidget {
  const KhqrDisplayWidget({
    super.key,
    required this.state,
    this.qrString,
    this.onRetry,
  });

  final KhqrState state;
  final String? qrString;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.md,
        border: Border.all(color: AppColors.border, width: AppBorderWidth.thin),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildContent(context),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (state) {
      case KhqrState.generating:
        return Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: AppSpacing.md),
            Text('Generating KHQR...', style: AppTextStyles.bodyLarge),
          ],
        );
      case KhqrState.ready:
        return Column(
          children: [
            Container(
              width: 200,
              height: 200,
              color: AppColors.surfaceAlt,
              child: const Center(
                child: Icon(Icons.qr_code_2, size: 120, color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Scan to pay with any supported app', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
          ],
        );
      case KhqrState.success:
        return Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: AppColors.success),
            const SizedBox(height: AppSpacing.md),
            Text('Payment Received!', style: AppTextStyles.headlineMedium),
          ],
        );
      case KhqrState.timeout:
        return Column(
          children: [
            const Icon(Icons.timer_off, size: 60, color: AppColors.warning),
            const SizedBox(height: AppSpacing.md),
            Text('QR Code Expired', style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.lg),
            if (onRetry != null)
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('Generate New QR'),
              ),
          ],
        );
      case KhqrState.offline:
        return Column(
          children: [
            const Icon(Icons.wifi_off, size: 60, color: AppColors.textHint),
            const SizedBox(height: AppSpacing.md),
            Text('Offline Mode', style: AppTextStyles.headlineSmall),
            const SizedBox(height: AppSpacing.sm),
            Text('Cannot generate KHQR without internet connection.', style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            if (onRetry != null)
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Try Again'),
              ),
          ],
        );
    }
  }
}
