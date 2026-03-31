import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/core/utils/currency_formatter.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/features/payment/data/deep_link_helper.dart';

/// Dialog shown when user returns from a deep link payment (ABA/Wing).
///
/// Asks the user to confirm whether the payment was completed
/// in the banking app. Provides options to confirm, retry, or cancel.
///
/// Usage:
/// ```dart
/// final result = await PaymentConfirmationDialog.show(
///   context: context,
///   method: PaymentMethod.aba,
///   amountKHR: 50000,
///   invoiceId: 'TXN-20260330-0001',
/// );
/// if (result == PaymentConfirmationResult.confirmed) { ... }
/// ```
class PaymentConfirmationDialog extends StatelessWidget {
  /// Creates a [PaymentConfirmationDialog].
  const PaymentConfirmationDialog({
    required this.method,
    required this.amountKHR,
    required this.invoiceId,
    super.key,
  });

  /// The payment method used for the transaction.
  final PaymentMethod method;

  /// The total transaction amount in KHR.
  final double amountKHR;

  /// The unique invoice ID or reference for the transaction.
  final String invoiceId;

  /// Show the dialog and return the user's choice.
  static Future<PaymentConfirmationResult?> show({
    required BuildContext context,
    required PaymentMethod method,
    required double amountKHR,
    required String invoiceId,
  }) {
    return showDialog<PaymentConfirmationResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PaymentConfirmationDialog(
        method: method,
        amountKHR: amountKHR,
        invoiceId: invoiceId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appName = DeepLinkHelper.getDisplayName(method);
    final appNameKm = DeepLinkHelper.getDisplayNameKm(method);
    final brandColor = switch (method) {
      PaymentMethod.aba => AppColors.abaRed,
      PaymentMethod.wing => AppColors.wingOrange,
      _ => AppColors.khqrBlue,
    };

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      title: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: brandColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance,
              color: brandColor,
              size: 28,
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Confirm $appName Payment',
            style: AppTextStyles.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'បញ្ជាក់ការទូទាត់ $appNameKm',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Amount
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Column(
              children: [
                Text(
                  amountKHR.formatKHR,
                  style: AppTextStyles.priceDisplay.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  amountKHR.formatUSD,
                  style: AppTextStyles.priceSub.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Invoice: $invoiceId',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.base),
          Text(
            'Did you complete the payment in $appName?',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'តើអ្នកបានបង់ប្រាក់នៅក្នុង $appNameKm រួចហើយទេ?',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        // Cancel
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(PaymentConfirmationResult.cancelled),
          child: const Text(
            'Cancel',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        // Not Yet — reopen banking app
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(PaymentConfirmationResult.notYet),
          child: const Text(
            'Not Yet',
            style: TextStyle(color: AppColors.warning),
          ),
        ),
        // Confirmed
        ElevatedButton(
          onPressed: () => Navigator.of(context)
              .pop(PaymentConfirmationResult.confirmed),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: AppColors.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
          ),
          child: const Text('Yes, Paid'),
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<PaymentMethod>('method', method));
    properties.add(DoubleProperty('amountKHR', amountKHR));
    properties.add(StringProperty('invoiceId', invoiceId));
  }
}

/// Result of the payment confirmation dialog.
enum PaymentConfirmationResult {
  /// User confirmed payment was made.
  confirmed,

  /// User hasn't paid yet — reopen banking app.
  notYet,

  /// User cancelled the payment flow.
  cancelled,
}
