import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/stock_badge.dart';
import 'package:shimmer/shimmer.dart';

/// Product data model for ProductCard
class ProductCardData {
  /// Creates a [ProductCardData].
  const ProductCardData({
    required this.id,
    required this.name,
    this.nameKhmer,
    this.description,
    this.descriptionKhmer,
    this.priceKHR = 0,
    this.priceUSD,
    this.stockQuantity = 0,
    this.lowStockThreshold = 10,
    this.imageUrl,
    this.category,
  });

  /// Unique identifier for the product.
  final String id;

  /// English name of the product.
  final String name;

  /// Khmer name of the product.
  final String? nameKhmer;

  /// English description of the product.
  final String? description;

  /// Khmer description of the product.
  final String? descriptionKhmer;

  /// Retail price in KHR.
  final double priceKHR;

  /// Retail price in USD.
  final double? priceUSD;

  /// Current available stock quantity.
  final int stockQuantity;

  /// Threshold for low stock warning.
  final int lowStockThreshold;

  /// URL of the product image.
  final String? imageUrl;

  /// Product category name.
  final String? category;

  /// Get stock status based on quantity
  StockStatus get stockStatus {
    if (stockQuantity == 0) return StockStatus.outOfStock;
    if (stockQuantity <= lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }
}

/// KhmerBiz POS Product Card
///
/// Grid-style product card for POS product selection.
///
/// Features:
/// - Product image (100×100, rounded)
/// - Bilingual name (Khmer bold, English secondary)
/// - Dual price display (KHR large, USD small)
/// - Stock status badge
/// - Add-to-cart ripple button
/// - Shimmer loading state
/// - Selected state
///
/// Usage:
/// ```dart
/// ProductCard(
///   product: ProductCardData(
///     id: '1',
///     name: 'Coffee',
///     nameKhmer: 'កាហ្វេ',
///     priceKHR: 5000,
///     priceUSD: 1.25,
///     stockQuantity: 50,
///   ),
///   onTap: () => _addToCart(product),
///   onLongPress: () => _showProductDetails(product),
/// )
/// ```
class ProductCard extends StatefulWidget {
  /// Creates a [ProductCard].
  const ProductCard({
    required this.product,
    super.key,
    this.onTap,
    this.onLongPress,
    this.isSelected = false,
    this.showStockBadge = true,
    this.showAddButton = true,
    this.width,
    this.height,
  });

  /// Product data
  final ProductCardData product;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Callback when card is long-pressed
  final VoidCallback? onLongPress;

  /// Whether product is selected (in cart)
  final bool isSelected;

  /// Show stock badge
  final bool showStockBadge;

  /// Show add to cart button overlay
  final bool showAddButton;

  /// Card width (default: 140dp)
  final double? width;

  /// Card height (default: 180dp)
  final double? height;

  @override
  State<ProductCard> createState() => _ProductCardState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ProductCardData>('product', product));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onLongPress', onLongPress));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(DiagnosticsProperty<bool>('showStockBadge', showStockBadge));
    properties.add(DiagnosticsProperty<bool>('showAddButton', showAddButton));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
  }
}

class _ProductCardState extends State<ProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 80),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.96).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _scaleController.reverse();
  }

  void _handleTapCancel() {
    _scaleController.reverse();
  }

  void _handleTap() {
    HapticFeedback.selectionClick();
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = widget.width ?? AppSpacing.productCardWidth;
    final cardHeight = widget.height ?? AppSpacing.productCardHeight;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: widget.isSelected ? 4 : 1,
            shadowColor: AppColors.shadow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Product image
                    _buildImage(),

                    // Content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product name (Khmer + English)
                            Expanded(
                              child: _buildName(),
                            ),

                            // Price
                            _buildPrice(),

                            // Stock badge
                            if (widget.showStockBadge) ...[
                              const SizedBox(height: AppSpacing.xs),
                              _buildStockBadge(),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Selected overlay
                if (widget.isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xs),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: AppColors.onPrimary,
                      ),
                    ),
                  ),

                // Add to cart overlay button
                if (widget.showAddButton &&
                    widget.product.stockStatus != StockStatus.outOfStock)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.surface.withValues(alpha: 0.9),
                          ],
                        ),
                      ),
                      child: Center(
                        child: InkWell(
                          onTap: widget.onTap,
                          borderRadius:
                              BorderRadius.circular(AppSpacing.radiusSmall),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.xs,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius:
                                  BorderRadius.circular(AppSpacing.radiusSmall),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart,
                              size: 20,
                              color: AppColors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // Out of stock overlay
                if (widget.product.stockStatus == StockStatus.outOfStock)
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.5),
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusSmall),
                          ),
                          child: const Text(
                            'Out of Stock',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: widget.product.imageUrl != null
          ? Image.network(
              widget.product.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return ColoredBox(
      color: AppColors.surfaceAlt,
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 48,
        color: AppColors.textHint.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildName() {
    if (widget.product.nameKhmer != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Khmer name (primary, bold)
          Text(
            widget.product.nameKhmer!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          // English name (secondary)
          if (widget.product.name.isNotEmpty)
            Text(
              widget.product.name,
              style: const TextStyle(
                fontFamily: 'Kantumruy Pro',
                fontSize: 13,
                fontWeight: FontWeight.normal,
                height: 1.3,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      );
    } else {
      return Text(
        widget.product.name,
        style: const TextStyle(
          fontFamily: 'Kantumruy Pro',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.3,
          color: AppColors.textPrimary,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
  }

  Widget _buildPrice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // KHR price (large, bold, monospace)
        Text(
          '៛${_formatNumber(widget.product.priceKHR)}',
          style: const TextStyle(
            fontFamily: 'Roboto Mono',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.2,
            color: AppColors.primary,
          ),
        ),
        // USD price (small, gray)
        if (widget.product.priceUSD != null) ...[
          const SizedBox(height: 2),
          Text(
            '≈ \$${widget.product.priceUSD!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Roboto Mono',
              fontSize: 11,
              fontWeight: FontWeight.normal,
              height: 1.2,
              color: AppColors.textHint,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStockBadge() {
    final status = widget.product.stockStatus;
    final Color color;
    final String text;
    final IconData icon;

    switch (status) {
      case StockStatus.inStock:
        color = AppColors.success;
        text = 'In Stock';
        icon = Icons.check_circle;
      case StockStatus.lowStock:
        color = AppColors.warning;
        text = '${widget.product.stockQuantity} left';
        icon = Icons.warning_amber;
      case StockStatus.outOfStock:
        color = AppColors.error;
        text = 'Out of Stock';
        icon = Icons.cancel;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.2,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<ProductCardData>('product', widget.product));
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onTap', widget.onTap));
    properties.add(
      ObjectFlagProperty<VoidCallback?>.has(
        'onLongPress',
        widget.onLongPress,
      ),
    );
    properties.add(DiagnosticsProperty<bool>('isSelected', widget.isSelected));
    properties.add(
      DiagnosticsProperty<bool>('showStockBadge', widget.showStockBadge),
    );
    properties
        .add(DiagnosticsProperty<bool>('showAddButton', widget.showAddButton));
    properties.add(DoubleProperty('width', widget.width));
    properties.add(DoubleProperty('height', widget.height));
  }
}

/// Shimmer loading placeholder for ProductCard
class ProductCardShimmer extends StatelessWidget {
  /// Creates a [ProductCardShimmer].
  const ProductCardShimmer({
    super.key,
    this.width,
    this.height,
  });
  /// Shimmer width.
  final double? width;

  /// Shimmer height.
  final double? height;

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? AppSpacing.productCardWidth;
    final cardHeight = height ?? AppSpacing.productCardHeight;

    return Shimmer.fromColors(
      baseColor: AppColors.border.withValues(alpha: 0.3),
      highlightColor: AppColors.border.withValues(alpha: 0.1),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image placeholder
              Container(
                height: 100,
                color: Colors.white,
              ),
              // Content placeholder
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name lines
                      Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Container(
                        height: 14,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      // Price line
                      Container(
                        height: 18,
                        width: 60,
                        color: Colors.white,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      // Stock badge line
                      Container(
                        height: 12,
                        width: 50,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
  }
}
