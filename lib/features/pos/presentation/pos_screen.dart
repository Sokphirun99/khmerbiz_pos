import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/di/injection.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/cart_item.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_event.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_state.dart';
import 'package:khmerbiz_pos/features/cart/presentation/screens/checkout_success_screen.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_event.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_state.dart';
import 'package:khmerbiz_pos/shared/widgets/cards/product_card.dart';
import 'package:khmerbiz_pos/shared/widgets/displays/price_display.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/empty_state.dart';
import 'package:khmerbiz_pos/shared/widgets/inputs/app_text_field.dart';
import 'package:khmerbiz_pos/shared/widgets/layouts/category_pill.dart';

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductBloc>(
          create: (_) => sl<ProductBloc>()..add(const LoadProducts()),
        ),
        BlocProvider<CartBloc>(
          create: (_) => sl<CartBloc>(),
        ),
      ],
      child: const _POSBody(),
    );
  }
}

class _POSBody extends StatelessWidget {
  const _POSBody();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 800;

    return BlocListener<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartCheckoutSuccess) {
          context.read<CartBloc>().add(ClearCart());
          Navigator.of(context).pop();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => CheckoutSuccessScreen(state: state),
          );
        } else if (state is CartCheckoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.messageEn),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: isTablet ? const _TabletLayout() : const _MobileLayout(),
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: const _ProductSection(),
        ),
        Container(
          width: 380,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(
              left: BorderSide(color: AppColors.borderLight),
            ),
          ),
          child: const _CartPanel(),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _ProductSection(),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is! CartLoaded || state.items.isEmpty) {
              return const SizedBox.shrink();
            }
            return Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _MobileCartBar(state: state),
            );
          },
        ),
      ],
    );
  }
}

class _MobileCartBar extends StatelessWidget {
  const _MobileCartBar({required this.state});

  final CartLoaded state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCartSheet(context),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.base),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusLarge),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  '${state.items.length}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Cart',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    Text(
                      '៛${state.total.toStringAsFixed(0)}',
                      style: AppTextStyles.priceSmall.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_up,
                color: AppColors.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCartSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) {
          return const _CartPanel();
        },
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  const _ProductSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Column(
          children: [
            const _SearchBar(),
            if (state is ProductsLoaded && state.categories.isNotEmpty)
              CategoryPillRowWithAll(
                categories: state.categories
                    .map((c) => CategoryPillData(
                          id: c.id,
                          name: c.nameEn,
                          nameKhmer: c.nameKh,
                        ))
                    .toList(),
                selectedId: state.selectedCategoryId,
                onSelected: (id) {
                  context.read<ProductBloc>().add(
                        SelectCategory(categoryId: id),
                      );
                },
              ),
            Expanded(child: _ProductGrid()),
          ],
        );
      },
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _controller,
              hintText: 'Search products...',
              hintTextKhmer: 'ស្វែងរកផលិតផល...',
              type: AppTextFieldType.search,
              prefixIcon: Icons.search,
              onChanged: (value) {
                context.read<ProductBloc>().add(
                      SearchProducts(query: value),
                    );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.clear();
              context.read<ProductBloc>().add(const RefreshProducts());
            },
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return switch (state) {
          ProductsLoading() => const _ProductGridLoading(),
          ProductsLoaded() => _ProductGridLoaded(state: state),
          ProductsError() => _ProductGridError(failure: state.failure),
          _ => const _ProductGridLoading(),
        };
      },
    );
  }
}

class _ProductGridLoading extends StatelessWidget {
  const _ProductGridLoading();

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 800;
    final crossCount = isTablet ? 4 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.base),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        childAspectRatio: 0.78,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: 8,
      itemBuilder: (_, __) => const ProductCardShimmer(),
    );
  }
}

class _ProductGridLoaded extends StatelessWidget {
  const _ProductGridLoaded({required this.state});

  final ProductsLoaded state;

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 800;
    final crossCount = isTablet ? 4 : 2;

    if (state.products.isEmpty) {
      return const EmptyState(
        variant: EmptyStateVariant.noProducts,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.base),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossCount,
        childAspectRatio: 0.78,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: state.products.length,
      itemBuilder: (context, index) {
        final product = state.products[index];
        final isInCart = _isInCart(context, product.id);

        return ProductCard(
          product: ProductCardData(
            id: product.id,
            name: product.nameEn,
            nameKhmer: product.nameKh,
            priceKHR: product.retailPrice,
            priceUSD: product.retailPrice / 4100,
            stockQuantity: product.stock.toInt(),
            lowStockThreshold: product.lowStockThreshold.toInt(),
            category: product.categoryName,
          ),
          onTap:
              product.isOutOfStock ? null : () => _addToCart(context, product),
          isSelected: isInCart,
        );
      },
    );
  }

  bool _isInCart(BuildContext context, String productId) {
    final cartState = context.read<CartBloc>().state;
    if (cartState is CartLoaded) {
      return cartState.items.any((item) => item.productId == productId);
    }
    return false;
  }

  void _addToCart(BuildContext context, Product product) {
    context.read<CartBloc>().add(AddToCart(product: product));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}

class _ProductGridError extends StatelessWidget {
  const _ProductGridError({required this.failure});

  final dynamic failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Failed to load products',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ProductBloc>().add(const RefreshProducts());
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _CartPanel extends StatelessWidget {
  const _CartPanel();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        return switch (state) {
          CartInitial() => const _EmptyCart(),
          CartLoaded() => _LoadedCart(state: state),
          CartCheckoutSuccess() => const SizedBox.shrink(),
          CartCheckoutFailure() => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Cart is Empty',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'រទេះទទេ',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap a product to add it',
            style: AppTextStyles.bodySmall,
          ),
          Text(
            'ប៉ះផលិតផលដើម្បីបន្ថែម',
            style: AppTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _LoadedCart extends StatelessWidget {
  const _LoadedCart({required this.state});

  final CartLoaded state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.borderLight),
            ),
          ),
          child: Row(
            children: [
              Text(
                'Current Order',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                'ការបញ្ជាទិញ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => _confirmClear(context),
                tooltip: 'Clear cart',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              final item = state.items[index];
              return _CartItemRow(
                item: item,
                onRemove: () => context.read<CartBloc>().add(
                      RemoveFromCart(productId: item.productId),
                    ),
                onUpdateQuantity: (qty) => context.read<CartBloc>().add(
                      UpdateQuantity(productId: item.productId, quantity: qty),
                    ),
                maxQuantity: item.product.stock.toDouble(),
              );
            },
          ),
        ),
        _CartTotals(state: state),
        if (state.stockWarnings != null && state.stockWarnings!.isNotEmpty)
          _StockWarnings(warnings: state.stockWarnings!),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: SizedBox(
            width: double.infinity,
            height: AppSpacing.buttonHeightPrimary,
            child: ElevatedButton.icon(
              onPressed:
                  state.isCheckingOut ? null : () => _showCheckout(context),
              icon: state.isCheckingOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onPrimary,
                      ),
                    )
                  : const Icon(Icons.payment),
              label: Text(
                'Checkout',
                style: AppTextStyles.buttonLabel.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear Cart?'),
          content: const Text('បញ្ជាក់ការលុបរទេះ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CartBloc>().add(ClearCart());
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showCheckout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _CheckoutSheet(),
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({
    required this.item,
    required this.onRemove,
    required this.onUpdateQuantity,
    this.maxQuantity = 0,
  });

  final CartItem item;
  final VoidCallback onRemove;
  final void Function(double) onUpdateQuantity;
  final double maxQuantity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Remove Item?'),
                content: Text('Remove "${item.product.nameKh}" from cart?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (_) => onRemove(),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.borderLight),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.nameKh,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.product.nameEn,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '៛${item.unitPrice.toStringAsFixed(0)} × ${item.quantity.toStringAsFixed(0)}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              '៛${item.lineTotal.toStringAsFixed(0)}',
              style: AppTextStyles.priceSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _StepperButton(
                  icon: Icons.remove,
                  onPressed: item.quantity > 1
                      ? () => onUpdateQuantity(item.quantity - 1)
                      : null,
                ),
                SizedBox(
                  width: 32,
                  child: Text(
                    item.quantity.toStringAsFixed(0),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _StepperButton(
                  icon: Icons.add,
                  onPressed: maxQuantity == 0 || item.quantity < maxQuantity
                      ? () => onUpdateQuantity(item.quantity + 1)
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
  });

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onPressed != null ? AppColors.primary : AppColors.border,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color:
              onPressed != null ? AppColors.onPrimary : AppColors.textDisabled,
        ),
      ),
    );
  }
}

class _CartTotals extends StatelessWidget {
  const _CartTotals({required this.state});

  final CartLoaded state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.base),
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Column(
        children: [
          _TotalRow(
            label: 'Subtotal',
            value: '៛${state.subtotal.toStringAsFixed(0)}',
          ),
          if (state.discountAmount > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            _TotalRow(
              label: 'Discount',
              value: '-៛${state.discountAmount.toStringAsFixed(0)}',
              isNegative: true,
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          _TotalRow(
            label: 'Tax (10%)',
            value: '៛${state.taxAmount.toStringAsFixed(0)}',
          ),
          const Divider(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'សរុប',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              PriceDisplay(
                amountKHR: state.total,
                amountUSD: state.totalUSD,
                size: PriceSize.medium,
                color: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.isNegative = false,
  });

  final String label;
  final String value;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isNegative ? AppColors.error : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isNegative ? AppColors.error : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _StockWarnings extends StatelessWidget {
  const _StockWarnings({required this.warnings});

  final Map<String, String> warnings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      color: AppColors.warningLight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: warnings.values.map((msg) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: 16,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    msg,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CheckoutSheet extends StatefulWidget {
  const _CheckoutSheet();

  @override
  State<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<_CheckoutSheet> {
  PaymentMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is! CartLoaded) return const SizedBox.shrink();

        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusExtraLarge),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: AppSpacing.sm),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Text(
                  'Select Payment Method',
                  style: AppTextStyles.headlineMedium,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 2.5,
                  children: [
                    _PaymentOption(
                      method: PaymentMethod.cash,
                      icon: Icons.attach_money,
                      label: 'Cash',
                      color: AppColors.cashGreen,
                      isSelected: _selectedMethod == PaymentMethod.cash,
                      onTap: () => setState(
                        () => _selectedMethod = PaymentMethod.cash,
                      ),
                    ),
                    _PaymentOption(
                      method: PaymentMethod.khqr,
                      icon: Icons.qr_code,
                      label: 'KHQR',
                      color: AppColors.khqrBlue,
                      isSelected: _selectedMethod == PaymentMethod.khqr,
                      onTap: () => setState(
                        () => _selectedMethod = PaymentMethod.khqr,
                      ),
                    ),
                    _PaymentOption(
                      method: PaymentMethod.aba,
                      icon: Icons.account_balance,
                      label: 'ABA',
                      color: AppColors.abaRed,
                      isSelected: _selectedMethod == PaymentMethod.aba,
                      onTap: () => setState(
                        () => _selectedMethod = PaymentMethod.aba,
                      ),
                    ),
                    _PaymentOption(
                      method: PaymentMethod.wing,
                      icon: Icons.wifi,
                      label: 'Wing',
                      color: AppColors.wingOrange,
                      isSelected: _selectedMethod == PaymentMethod.wing,
                      onTap: () => setState(
                        () => _selectedMethod = PaymentMethod.wing,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: SizedBox(
                  width: double.infinity,
                  height: AppSpacing.buttonHeightPrimary,
                  child: ElevatedButton.icon(
                    onPressed: _selectedMethod != null && !state.isCheckingOut
                        ? () => _processPayment(context, state)
                        : null,
                    icon: const Icon(Icons.check),
                    label: Text(
                      'Confirm Payment',
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: AppColors.onPrimary,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusMedium,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),
            ],
          ),
        );
      },
    );
  }

  void _processPayment(BuildContext context, CartLoaded state) {
    if (_selectedMethod == null) return;

    Navigator.of(context).pop();

    context.read<CartBloc>().add(
          ProcessCheckout(method: _selectedMethod!),
        );
  }
}

class _PaymentOption extends StatelessWidget {
  const _PaymentOption({
    required this.method,
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final PaymentMethod method;
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: isSelected ? color : AppColors.borderLight,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? color : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
