import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

/// Loading skeleton type
enum SkeletonType {
  /// Product card skeleton
  productCard,

  /// Cart item tile skeleton
  cartItem,

  /// List tile skeleton
  listTile,

  /// Text lines skeleton
  textLines,

  /// Circle avatar skeleton
  circle,

  /// Custom skeleton
  custom,
}

/// KhmerBiz POS Loading Skeleton
///
/// Shimmer placeholder matching the layout of various components.
///
/// Features:
/// - Pre-built skeletons for common components
/// - Custom skeleton support
/// - Smooth shimmer animation
/// - Matches app color scheme
///
/// Usage:
/// ```dart
/// // Product card skeleton
/// LoadingSkeleton(
///   type: SkeletonType.productCard,
/// )
///
/// // List of skeletons
/// ListView.builder(
///   itemCount: 5,
///   itemBuilder: (context, index) => const LoadingSkeleton(
///     type: SkeletonType.listTile,
///   ),
/// )
/// ```
class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    super.key,
    this.type = SkeletonType.textLines,
    this.width,
    this.height,
    this.lineCount = 3,
    this.child,
    this.borderRadius,
  });

  /// Skeleton type
  final SkeletonType type;

  /// Custom width (overrides type default)
  final double? width;

  /// Custom height (overrides type default)
  final double? height;

  /// Number of lines (for textLines type)
  final int lineCount;

  /// Custom child (for custom type)
  final Widget? child;

  /// Border radius
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withOpacity(0.3),
      highlightColor: AppColors.border.withOpacity(0.1),
      child: _buildSkeleton(),
    );
  }

  Widget _buildSkeleton() {
    switch (type) {
      case SkeletonType.productCard:
        return _buildProductCard();
      case SkeletonType.cartItem:
        return _buildCartItem();
      case SkeletonType.listTile:
        return _buildListTile();
      case SkeletonType.textLines:
        return _buildTextLines();
      case SkeletonType.circle:
        return _buildCircle();
      case SkeletonType.custom:
        return child ?? const SizedBox.shrink();
    }
  }

  Widget _buildProductCard() {
    final cardWidth = width ?? AppSpacing.productCardWidth;
    final cardHeight = height ?? AppSpacing.productCardHeight;

    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(borderRadius ?? AppSpacing.radiusMedium),
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
                    Container(
                      height: 18,
                      width: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: AppSpacing.xs),
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
    );
  }

  Widget _buildCartItem() {
    return SizedBox(
      height: height ?? AppSpacing.listItemHeight,
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 14,
                  width: double.infinity,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 14,
                  width: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 12,
                  width: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile() {
    return SizedBox(
      height: height ?? AppSpacing.listItemHeight,
      child: Row(
        children: [
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          // Text placeholders
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 14,
                  width: 150,
                  color: Colors.white,
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  height: 12,
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          // Trailing placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextLines() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        lineCount,
        (index) => Padding(
          padding: EdgeInsets.only(
              bottom: index < lineCount - 1 ? AppSpacing.sm : 0,),
          child: Container(
            height: height ?? 14,
            width: width ?? (index == lineCount - 1 ? 100 : double.infinity),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildCircle() {
    final size = width ?? height ?? 40;

    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<SkeletonType>('type', type));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(IntProperty('lineCount', lineCount));
    properties.add(DoubleProperty('borderRadius', borderRadius));
  }
}

/// Grid of loading skeletons for product grid
class ProductGridSkeleton extends StatelessWidget {
  const ProductGridSkeleton({
    super.key,
    this.itemCount = 8,
    this.crossAxisCount = 2,
  });
  final int itemCount;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.78,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => const LoadingSkeleton(
        type: SkeletonType.productCard,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('itemCount', itemCount));
    properties.add(IntProperty('crossAxisCount', crossAxisCount));
  }
}

/// List of loading skeletons
class ListSkeleton extends StatelessWidget {
  const ListSkeleton({
    super.key,
    this.itemCount = 5,
    this.type = SkeletonType.listTile,
    this.itemHeight,
  });
  final int itemCount;
  final SkeletonType type;
  final double? itemHeight;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) =>
          const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) => LoadingSkeleton(
        type: type,
        height: itemHeight,
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('itemCount', itemCount));
    properties.add(EnumProperty<SkeletonType>('type', type));
    properties.add(DoubleProperty('itemHeight', itemHeight));
  }
}
