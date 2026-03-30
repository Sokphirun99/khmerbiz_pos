import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:khmerbiz_pos/core/router/app_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/widgets/stock_adjustment_sheet.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/stock_badge.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProductRepository>().getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final either = snapshot.data;
        if (either == null) {
          return const Scaffold(
            body: Center(child: Text('Product not found')),
          );
        }

        return either.fold(
          (failure) => Scaffold(
            body: Center(child: Text('Error: $failure')),
          ),
          (product) {
            if (product == null) {
              return const Scaffold(
                body: Center(child: Text('Product not found')),
              );
            }
            return _buildContent(context, product);
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, Product product) {
    final stockStatus = product.stock <= 0
        ? StockStatus.outOfStock
        : product.stock <= product.lowStockThreshold
            ? StockStatus.lowStock
            : StockStatus.inStock;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          product.nameEn,
          style:
              AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () => context.pushNamed(
              AppRouter.productEditName,
              pathParameters: {'id': product.id},
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        children: [
          // Product image
          if (product.imagePath != null)
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(AppSpacing.radiusLarge),
              child: Image.network(
                product.imagePath!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildImagePlaceholder(),
              ),
            )
          else
            _buildImagePlaceholder(),

          const SizedBox(height: AppSpacing.lg),

          // Names
          Text(product.nameKh, style: AppTextStyles.displayMedium),
          Text(
            product.nameEn,
            style: AppTextStyles.headlineMedium
                .copyWith(color: AppColors.textSecondary),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Info cards
          _buildInfoRow('Barcode', product.barcode ?? 'N/A'),
          _buildInfoRow('Unit', product.unit),
          _buildInfoRow('Category', product.categoryId ?? 'Uncategorized'),

          const Divider(height: AppSpacing.xl),

          // Pricing
          Text('Pricing', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          _buildInfoRow(
              'Cost Price', '${product.costPrice.toStringAsFixed(0)}R'),
          _buildInfoRow(
              'Retail Price', '${product.retailPrice.toStringAsFixed(0)}R'),
          if (product.wholesalePrice != null)
            _buildInfoRow('Wholesale Price',
                '${product.wholesalePrice!.toStringAsFixed(0)}R'),

          _buildProfitRow(product),

          const Divider(height: AppSpacing.xl),

          // Stock
          Text('Stock', style: AppTextStyles.headlineMedium),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Text(
                product.stock.toStringAsFixed(0),
                style: AppTextStyles.displayLarge.copyWith(
                  color: stockStatus == StockStatus.outOfStock
                      ? AppColors.error
                      : stockStatus == StockStatus.lowStock
                          ? AppColors.warning
                          : AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(product.unit, style: AppTextStyles.bodyMedium),
              const Spacer(),
              StockBadge(
                status: stockStatus,
                quantity: product.stock.toInt(),
                style: StockBadgeStyle.full,
              ),
            ],
          ),
          _buildInfoRow('Low Stock Threshold',
              product.lowStockThreshold.toStringAsFixed(0)),

          const SizedBox(height: AppSpacing.lg),

          // Adjust stock button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () =>
                  StockAdjustmentSheet.show(context, product),
              icon: const Icon(Icons.inventory),
              label: const Text('Adjust Stock'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.md),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Status
          _buildInfoRow('Featured', product.isFeatured ? 'Yes' : 'No'),
          _buildInfoRow('Active', product.isActive ? 'Yes' : 'No'),
          if (product.createdAt != null)
            _buildInfoRow('Created', _formatDate(product.createdAt!)),
          if (product.updatedAt != null)
            _buildInfoRow('Updated', _formatDate(product.updatedAt!)),
        ],
      ),
    );
  }

  Widget _buildProfitRow(Product product) {
    final profit = product.retailPrice - product.costPrice;
    final margin = product.retailPrice > 0
        ? (profit / product.retailPrice * 100)
        : 0.0;
    return _buildInfoRow(
      'Profit Margin',
      '${profit.toStringAsFixed(0)}R (${margin.toStringAsFixed(1)}%)',
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textSecondary),
          ),
          Text(value, style: AppTextStyles.labelMedium),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
      ),
      child: const Icon(
        Icons.inventory_2_outlined,
        size: 64,
        color: AppColors.textTertiary,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
