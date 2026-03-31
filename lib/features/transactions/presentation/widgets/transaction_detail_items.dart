import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/transaction_item.dart';

class TransactionDetailItems extends StatelessWidget {
  const TransactionDetailItems({required this.items, super.key});

  final List<TransactionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) => _ItemRow(item: item)).toList(),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productNameSnapshot,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (item.productNameEnSnapshot.isNotEmpty &&
                    item.productNameEnSnapshot != item.productNameSnapshot)
                  Text(
                    item.productNameEnSnapshot,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                Text(
                  '${item.quantity.toStringAsFixed(0)} × ${NumberFormat('#,###').format(item.unitPrice)}៛',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${NumberFormat('#,###').format(item.subtotal)}៛',
            style: AppTextStyles.priceSmall,
          ),
        ],
      ),
    );
  }
}
