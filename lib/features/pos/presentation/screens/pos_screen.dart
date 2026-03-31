import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/shared/widgets/widgets.dart';

/// KhmerBiz POS Screen - Example Wireframe
///
/// This screen demonstrates the complete design system implementation.
/// It serves as a reference for how all components work together.
///
/// Features demonstrated:
/// - Category pills (horizontal scroll)
/// - Product grid with shimmer loading
/// - Cart panel with item tiles
/// - Price displays (KHR + USD)
/// - Stock badges
/// - Sync status indicator
/// - Offline banner
/// - Empty states
/// - Confirmation dialogs
///
/// Layout:
/// - Tablet: Side-by-side (products | cart)
/// - Phone: Stacked (products above cart)
class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  // Demo data
  String? _selectedCategory;
  final bool _isLoading = false;
  final bool _isOnline = true;
  final int _pendingSyncCount = 0;

  // Demo categories
  final List<CategoryPillData> _categories = [
    const CategoryPillData(
      id: 'all',
      name: 'All',
      nameKhmer: 'ទាំងអស់',
      icon: Icons.apps_outlined,
      productCount: 48,
    ),
    const CategoryPillData(
      id: 'coffee',
      name: 'Coffee',
      nameKhmer: 'កាហ្វេ',
      icon: Icons.local_cafe_outlined,
      productCount: 12,
    ),
    const CategoryPillData(
      id: 'tea',
      name: 'Tea',
      nameKhmer: 'តែ',
      icon: Icons.local_drink_outlined,
      productCount: 8,
    ),
    const CategoryPillData(
      id: 'smoothie',
      name: 'Smoothie',
      nameKhmer: 'ទឹកក្រឡុក',
      icon: Icons.brunch_dining_outlined,
      productCount: 10,
    ),
    const CategoryPillData(
      id: 'dessert',
      name: 'Dessert',
      nameKhmer: 'នំចំណី',
      icon: Icons.cake_outlined,
      productCount: 15,
    ),
    const CategoryPillData(
      id: 'snack',
      name: 'Snack',
      nameKhmer: 'ចំណី',
      icon: Icons.cookie_outlined,
      productCount: 3,
    ),
  ];

  // Demo products
  final List<ProductCardData> _products = [
    const ProductCardData(
      id: '1',
      name: 'Caffe Latte',
      nameKhmer: 'កាហ្វេឡាតេ',
      priceKHR: 12000,
      priceUSD: 2.93,
      stockQuantity: 50,
    ),
    const ProductCardData(
      id: '2',
      name: 'Cappuccino',
      nameKhmer: 'កាហ្វេកាបូឆីណូ',
      priceKHR: 13000,
      priceUSD: 3.17,
      stockQuantity: 45,
    ),
    const ProductCardData(
      id: '3',
      name: 'Iced Coffee',
      nameKhmer: 'កាហ្វេទឹកកក',
      priceKHR: 10000,
      priceUSD: 2.44,
      stockQuantity: 8,
    ),
    const ProductCardData(
      id: '4',
      name: 'Espresso',
      nameKhmer: 'អេស្ព្រេសូ',
      priceKHR: 9000,
      priceUSD: 2.20,
    ),
    const ProductCardData(
      id: '5',
      name: 'Green Tea',
      nameKhmer: 'តែបៃតង',
      priceKHR: 8000,
      priceUSD: 1.95,
      stockQuantity: 30,
    ),
    const ProductCardData(
      id: '6',
      name: 'Lemon Tea',
      nameKhmer: 'តែក្រូចឆ្មារ',
      priceKHR: 8000,
      priceUSD: 1.95,
      stockQuantity: 25,
    ),
  ];

  // Demo cart items
  final List<CartItemData> _cartItems = [
    const CartItemData(
      id: 'c1',
      productId: '1',
      name: 'Caffe Latte',
      nameKhmer: 'កាហ្វេឡាតេ',
      unitPriceKHR: 12000,
      unitPriceUSD: 2.93,
      quantity: 2,
    ),
    const CartItemData(
      id: 'c2',
      productId: '3',
      name: 'Iced Coffee',
      nameKhmer: 'កាហ្វេទឹកកក',
      unitPriceKHR: 10000,
      unitPriceUSD: 2.44,
      quantity: 1,
    ),
  ];

  double get _cartTotalKHR {
    return _cartItems.fold(0, (sum, item) => sum + item.lineTotalKHR);
  }

  double? get _cartTotalUSD {
    final total = _cartItems.fold<double>(
      0,
      (sum, item) => sum + (item.lineTotalUSD ?? 0),
    );
    return total > 0 ? total : null;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 720;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          // Main content
          Row(
            children: [
              // Products section (expanded)
              Expanded(
                flex: isTablet ? 2 : 1,
                child: _buildProductsSection(),
              ),

              // Cart section (fixed width on tablet, bottom sheet on phone)
              if (isTablet)
                SizedBox(
                  width: 380,
                  child: _buildCartSection(),
                ),
            ],
          ),

          // Offline banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: OfflineBanner(
              isPendingCount: _pendingSyncCount,
              isVisible: !_isOnline,
              onDismiss: () => setState(() {}),
              onRetry: () => setState(() {}),
            ),
          ),
        ],
      ),

      // Bottom cart bar for phone layout
      bottomNavigationBar: isTablet ? null : _buildBottomCartBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Point of Sale',
            style: AppTextStyles.headlineLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            'លក់ទំនិញ',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      actions: [
        // Sync status
        SyncStatusBadge(
          status: _isOnline ? SyncStatus.synced : SyncStatus.offline,
          pendingCount: _pendingSyncCount,
          onTap: _showSyncDialog,
        ),
        const SizedBox(width: AppSpacing.sm),
        // Settings button
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildProductsSection() {
    return Column(
      children: [
        // Category pills
        CategoryPillRow(
          categories: _categories,
          selectedId: _selectedCategory,
          onSelected: (id) => setState(() => _selectedCategory = id),
        ),

        // Search bar
        const Padding(
          padding: EdgeInsets.all(AppSpacing.base),
          child: AppTextField(
            type: AppTextFieldType.search,
            hintText: 'Search products...',
            hintTextKhmer: 'ស្វែងរកផលិតផល...',
            prefixIcon: Icons.search_outlined,
            showClearButton: true,
          ),
        ),

        // Products grid
        Expanded(
          child: _isLoading
              ? const ProductGridSkeleton(
                  itemCount: 6,
                )
              : _products.isEmpty
                  ? EmptyState(
                      variant: EmptyStateVariant.noProducts,
                      actionLabel: 'Add Product',
                      actionLabelKhmer: 'បន្ថែមផលិតផល',
                      onAction: () {},
                    )
                  : _buildProductGrid(),
        ),
      ],
    );
  }

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.base),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 0.78,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final isInCart = _cartItems.any((item) => item.productId == product.id);

        return ProductCard(
          product: product,
          isSelected: isInCart,
          onTap: () => _addToCart(product),
          onLongPress: () => _showProductDetails(product),
        );
      },
    );
  }

  Widget _buildCartSection() {
    return ColoredBox(
      color: AppColors.surface,
      child: Column(
        children: [
          // Cart header
          SectionHeader(
            title: 'Cart',
            titleKhmer: 'កន្ត្រក',
            actionLabel: _cartItems.isNotEmpty ? 'Clear' : null,
            actionLabelKhmer: _cartItems.isNotEmpty ? 'សម្អាត' : null,
            onAction: _cartItems.isNotEmpty ? _clearCart : null,
          ),

          // Cart items
          Expanded(
            child: _cartItems.isEmpty
                ? EmptyState(
                    variant: EmptyStateVariant.emptyCart,
                    actionLabel: 'Browse Products',
                    actionLabelKhmer: 'មើលផលិតផល',
                    onAction: () {},
                  )
                : ListView.separated(
                    itemCount: _cartItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return CartItemTile(
                        item: item,
                        onQuantityChanged: (qty) =>
                            _updateQuantity(item.id, qty),
                        onRemoved: () => _removeFromCart(item.id),
                      );
                    },
                  ),
          ),

          // Cart total and checkout
          _buildCartFooter(),
        ],
      ),
    );
  }

  Widget _buildCartFooter() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              PriceDisplay(
                amountKHR: _cartTotalKHR,
                amountUSD: _cartTotalUSD,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              PriceDisplay(
                amountKHR: _cartTotalKHR,
                amountUSD: _cartTotalUSD,
                size: PriceSize.large,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Checkout button
          AppButton(
            label: 'Checkout',
            labelKhmer: 'ទូទាត់',
            icon: Icons.point_of_sale_outlined,
            height: AppSpacing.buttonHeightPrimary,
            onTap: _cartItems.isNotEmpty ? _checkout : null,
            isDisabled: _cartItems.isEmpty,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCartBar() {
    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.base,
        right: AppSpacing.base,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
        top: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cart summary
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_cartItems.length} items',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                PriceDisplay(
                  amountKHR: _cartTotalKHR,
                  amountUSD: _cartTotalUSD,
                ),
              ],
            ),
          ),

          // Checkout button
          SizedBox(
            width: 140,
            child: AppButton(
              label: 'Checkout',
              labelKhmer: 'ទូទាត់',
              height: AppSpacing.buttonHeightPrimary,
              onTap: _cartItems.isNotEmpty ? _checkout : null,
              isDisabled: _cartItems.isEmpty,
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _addToCart(ProductCardData product) {
    setState(() {
      _cartItems.add(
        CartItemData(
          id: 'c${DateTime.now().millisecondsSinceEpoch}',
          productId: product.id,
          name: product.name,
          nameKhmer: product.nameKhmer,
          unitPriceKHR: product.priceKHR,
          unitPriceUSD: product.priceUSD,
          quantity: 1,
        ),
      );
    });

    // Haptic feedback
    HapticFeedback.lightImpact();
  }

  void _updateQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      _removeFromCart(itemId);
      return;
    }

    setState(() {
      final index = _cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        final item = _cartItems[index];
        _cartItems[index] = CartItemData(
          id: item.id,
          productId: item.productId,
          name: item.name,
          nameKhmer: item.nameKhmer,
          unitPriceKHR: item.unitPriceKHR,
          unitPriceUSD: item.unitPriceUSD,
          quantity: quantity,
        );
      }
    });
  }

  void _removeFromCart(String itemId) {
    setState(() {
      _cartItems.removeWhere((item) => item.id == itemId);
    });
  }

  void _clearCart() {
    showDialog<void>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Clear Cart?',
        titleKhmer: 'សម្អាតកន្ត្រក?',
        subtitle: 'Remove all items from cart',
        subtitleKhmer: 'ដកធាតុទាំងអស់ចេញពីកន្ត្រក',
        type: ConfirmationDialogType.danger,
        confirmLabel: 'Clear',
        confirmLabelKhmer: 'សម្អាត',
        onConfirm: () {
          Navigator.pop(context);
          setState(_cartItems.clear);
        },
      ),
    );
  }

  void _checkout() {
    // Navigate to checkout screen
    // For demo, show success dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Checkout Success'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 64,
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Payment Successful!',
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'ការទូទាត់បានជោគជ័យ!',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            PriceDisplay(
              amountKHR: _cartTotalKHR,
              amountUSD: _cartTotalUSD,
              size: PriceSize.large,
            ),
          ],
        ),
        actions: [
          AppButton(
            label: 'Done',
            labelKhmer: 'រួចរាល់',
            onTap: () {
              Navigator.pop(context);
              setState(_cartItems.clear);
            },
          ),
        ],
      ),
    );
  }

  void _showProductDetails(ProductCardData product) {
    // Show product details dialog
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.nameKhmer ?? product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.name),
            const SizedBox(height: AppSpacing.md),
            PriceDisplay(
              amountKHR: product.priceKHR,
              amountUSD: product.priceUSD,
              size: PriceSize.large,
            ),
            const SizedBox(height: AppSpacing.md),
            StockBadge.fromQuantity(
              quantity: product.stockQuantity,
              lowThreshold: product.lowStockThreshold,
              style: StockBadgeStyle.full,
            ),
          ],
        ),
        actions: [
          AppButton(
            label: 'Add to Cart',
            labelKhmer: 'ដាក់ចូលកន្ត្រក',
            isDisabled: product.stockStatus == StockStatus.outOfStock,
            onTap: () {
              Navigator.pop(context);
              _addToCart(product);
            },
          ),
        ],
      ),
    );
  }

  void _showSyncDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sync Status'),
        content: SyncStatusDetail(
          status: _isOnline ? SyncStatus.synced : SyncStatus.offline,
          pendingCount: _pendingSyncCount,
          lastSyncTime: DateTime.now().subtract(const Duration(minutes: 5)),
          onRetry: () {
            Navigator.pop(context);
            setState(() {});
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
