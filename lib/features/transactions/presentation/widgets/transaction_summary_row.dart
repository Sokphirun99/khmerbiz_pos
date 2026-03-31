import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';

class TransactionSummaryRow extends StatelessWidget {
  const TransactionSummaryRow({
    required this.label,
    required this.value,
    this.isNegative = false,
    this.isTotal = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isNegative;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.headlineSmall
              : AppTextStyles.bodyMedium.copyWith(
                  color: isNegative ? AppColors.error : AppColors.textSecondary,
                ),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.priceDisplay.copyWith(
                  color: isNegative ? AppColors.error : AppColors.primary,
                )
              : AppTextStyles.priceSmall.copyWith(
                  color: isNegative ? AppColors.error : AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}
