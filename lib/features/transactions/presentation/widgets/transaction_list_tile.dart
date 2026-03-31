import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({
    required this.transaction,
    required this.onTap,
    super.key,
  });

  final Transaction transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final paymentColor = _paymentMethodColor(transaction.paymentMethod);
    final paymentIcon = _paymentMethodIcon(transaction.paymentMethod);
    final paymentLabel = _paymentMethodLabel(transaction.paymentMethod);
    final timeLabel = _formatTimeAgo(transaction.transactionDate);
    final isVoided = transaction.status.toLowerCase() == 'voided';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color:
              isVoided ? AppColors.error.withOpacity(0.05) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: isVoided
                ? AppColors.error.withOpacity(0.2)
                : AppColors.borderLight,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: paymentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              ),
              child: Icon(paymentIcon, color: paymentColor, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          transaction.receiptNumber,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            decoration:
                                isVoided ? TextDecoration.lineThrough : null,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVoided) ...[
                        const SizedBox(width: AppSpacing.xs),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xs,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppSpacing.radiusSmall,
                            ),
                          ),
                          child: Text(
                            'Voided',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        paymentLabel,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '•',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        timeLabel,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${NumberFormat('#,###').format(transaction.totalAmount)}៛',
                  style: AppTextStyles.priceSmall.copyWith(
                    color:
                        isVoided ? AppColors.textHint : AppColors.textPrimary,
                    decoration: isVoided ? TextDecoration.lineThrough : null,
                  ),
                ),
                Text(
                  '\$${transaction.totalAmountUSD.toStringAsFixed(2)}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ],
        ),
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
    return switch (method.toLowerCase()) {
      'cash' => AppColors.cashGreen,
      'khqr' => AppColors.khqrBlue,
      'aba' => AppColors.abaRed,
      'wing' => AppColors.wingOrange,
      _ => AppColors.textSecondary,
    };
  }

  IconData _paymentMethodIcon(String method) {
    return switch (method.toLowerCase()) {
      'cash' => Icons.attach_money,
      'khqr' => Icons.qr_code,
      'aba' => Icons.account_balance,
      'wing' => Icons.wifi,
      _ => Icons.payment,
    };
  }

  String _paymentMethodLabel(String method) {
    return switch (method.toLowerCase()) {
      'cash' => 'Cash',
      'khqr' => 'KHQR',
      'aba' => 'ABA',
      'wing' => 'Wing',
      _ => method,
    };
  }
}
