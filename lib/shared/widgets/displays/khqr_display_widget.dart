import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/core/theme/foundation/app_radius.dart';
import 'package:khmerbiz_pos/core/theme/foundation/app_shadow.dart';

/// States of the KHQR generation and payment process.
enum KhqrState {
  /// Currently generating the QR code.
  generating,

  /// QR code is ready for scanning.
  ready,

  /// Payment has been successfully received.
  success,

  /// QR code generation or payment timed out.
  timeout,

  /// Device is offline and cannot generate QR.
  offline,
}

/// A widget that displays the KHQR and manages its states.
class KhqrDisplayWidget extends StatelessWidget {
  /// Creates a [KhqrDisplayWidget].
  const KhqrDisplayWidget({
    required this.state,
    super.key,
    this.qrString,
    this.onRetry,
  });

  /// The current state of the KHQR.
  final KhqrState state;

  /// The raw QR string to display (if ready).
  final String? qrString;

  /// Callback when the user wants to retry generation.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 400,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadow.md,
        border: Border.all(color: AppColors.border),
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
                child: Icon(Icons.qr_code_2,
                    size: 120, color: AppColors.textPrimary,),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Scan to pay with any supported app',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center,),
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
            Text('Cannot generate KHQR without internet connection.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center,),
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<KhqrState>('state', state));
    properties.add(StringProperty('qrString', qrString));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onRetry', onRetry));
  }
}
