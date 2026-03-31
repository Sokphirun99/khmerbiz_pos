import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/stock_badge.dart';

/// A grid item widget that displays product information.
///
/// Shows name (Khmer/English), price, stock status, and image.
class ProductGridItem extends StatelessWidget {
  /// Creates a [ProductGridItem].
  const ProductGridItem({
    required this.product,
    super.key,
    this.onTap,
    this.onLongPress,
  });

  /// The product entity to display.
  final Product product;

  /// Callback when the item is tapped.
  final VoidCallback? onTap;

  /// Callback when the item is long-pressed.
  final VoidCallback? onLongPress;

  StockStatus get _stockStatus {
    if (product.stock <= 0) return StockStatus.outOfStock;
    if (product.stock <= product.lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: AppSpacing.elevation1,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          side: _stockStatus == StockStatus.outOfStock
              ? const BorderSide(color: AppColors.error)
              : BorderSide.none,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product image
              Expanded(
                flex: 3,
                child: Center(
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusSmall),
                    child: product.imagePath != null
                        ? Image.network(
                            product.imagePath!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, __, ___) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xs),

              // Product name (Khmer)
              Text(
                product.nameKh,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Product name (English)
              Text(
                product.nameEn,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: AppSpacing.xs),

              // Price + Stock row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${product.retailPrice.toStringAsFixed(0)}R',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StockBadge(
                    status: _stockStatus,
                    quantity: product.stock.toInt(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        size: 40,
        color: AppColors.textTertiary,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Product>('product', product));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
  }
}
