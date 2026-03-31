import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';

class RecentTransactionTile extends StatelessWidget {
  const RecentTransactionTile({required this.transaction, super.key});

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final timeAgo = _formatTimeAgo(transaction.createdAt);
    final paymentColor = _paymentMethodColor(transaction.paymentMethod);
    final paymentIcon = _paymentMethodIcon(transaction.paymentMethod);
    final paymentLabel = _paymentMethodLabel(transaction.paymentMethod);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              color: paymentColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Icon(paymentIcon, color: paymentColor, size: 16),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.receiptNumber,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  paymentLabel,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.totalAmount.toStringAsFixed(0)}៛',
                style: AppTextStyles.priceSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                timeAgo,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color _paymentMethodColor(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return AppColors.cashGreen;
      case 'khqr':
        return AppColors.khqrBlue;
      case 'aba':
        return AppColors.abaRed;
      case 'wing':
        return AppColors.wingOrange;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _paymentMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return Icons.attach_money;
      case 'khqr':
        return Icons.qr_code;
      case 'aba':
        return Icons.account_balance;
      case 'wing':
        return Icons.wifi;
      default:
        return Icons.payment;
    }
  }

  String _paymentMethodLabel(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return 'Cash';
      case 'khqr':
        return 'KHQR';
      case 'aba':
        return 'ABA';
      case 'wing':
        return 'Wing';
      default:
        return method;
    }
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Transaction>('transaction', transaction));
  }
}
