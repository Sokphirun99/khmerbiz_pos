import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/top_product.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/stock_badge.dart';

class TopProductTile extends StatelessWidget {
  const TopProductTile({required this.product, required this.rank, super.key});

  final TopProduct product;
  final int rank;

  @override
  Widget build(BuildContext context) {
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
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: rank <= 3 ? AppColors.accentLight : AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: Center(
              child: Text(
                '$rank',
                style: AppTextStyles.labelSmall.copyWith(
                  color: rank <= 3 ? AppColors.accent : AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.product.nameKh,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  product.product.nameEn,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          StockBadge.fromQuantity(
            quantity: product.product.stock.toInt(),
            lowThreshold: product.product.lowStockThreshold.toInt(),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            '${product.quantitySold.toStringAsFixed(0)} sold',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TopProduct>('product', product));
    properties.add(IntProperty('rank', rank));
  }
}
