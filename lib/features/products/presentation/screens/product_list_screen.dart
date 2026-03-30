import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:khmerbiz_pos/core/router/app_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_event.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_state.dart';
import 'package:khmerbiz_pos/features/products/presentation/widgets/product_grid_item.dart';
import 'package:khmerbiz_pos/features/products/presentation/widgets/low_stock_alert_banner.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/empty_state.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/loading_skeleton.dart';
import 'package:khmerbiz_pos/shared/widgets/layouts/category_pill.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const LoadProducts());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: BlocConsumer<ProductBloc, ProductState>(
        listener: _blocListener,
        builder: (context, state) {
          return switch (state) {
            ProductsInitial() || ProductsLoading() => _buildLoading(),
            ProductsLoaded(:final products, :final categories,
                :final lowStockAlerts, :final selectedCategoryId) =>
              _buildContent(
                context,
                products: products,
                categories: categories,
                lowStockAlerts: lowStockAlerts,
                selectedCategoryId: selectedCategoryId,
              ),
            ProductsError(:final failure) => _buildError(failure.toString()),
            BarcodeScanning() => _buildLoading(),
            ProductScanned(:final product) =>
              _buildContent(context, products: [product]),
            BarcodeNotFound(:final barcode) =>
              _buildError('Product not found: $barcode'),
            ProductSaved() => _buildLoading(),
          };
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(AppRouter.productAddName),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text('Add Product', style: AppTextStyles.labelLarge),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: Text(
        'Products',
        style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
          tooltip: 'Scan Barcode',
          onPressed: () => context.read<ProductBloc>().add(ScanBarcode()),
        ),
        const SizedBox(width: AppSpacing.xs),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppSpacing.inputFieldHeightDense),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.pageHorizontal,
            vertical: AppSpacing.sm,
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search products...',
              hintStyle: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textTertiary),
              prefixIcon:
                  const Icon(Icons.search, color: AppColors.textSecondary),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear,
                          color: AppColors.textSecondary),
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<ProductBloc>()
                            .add(const SearchProducts(query: ''));
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                borderSide: BorderSide.none,
              ),
            ),
            style: AppTextStyles.bodyMedium,
            onChanged: (query) {
              context.read<ProductBloc>().add(SearchProducts(query: query));
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, ProductState state) {
    if (state is ProductScanned) {
      context.pushNamed(
        AppRouter.productDetailName,
        pathParameters: {'id': state.product.id},
      );
    }
    if (state is BarcodeNotFound) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No product found for barcode: ${state.barcode}'),
          backgroundColor: AppColors.warning,
          action: SnackBarAction(
            label: 'Create',
            textColor: Colors.white,
            onPressed: () => context.pushNamed(
              AppRouter.productAddName,
              extra: {'barcode': state.barcode},
            ),
          ),
        ),
      );
    }
    if (state is ProductSaved) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product saved: ${state.product.nameEn}'),
          backgroundColor: AppColors.success,
        ),
      );
      context.read<ProductBloc>().add(const LoadProducts());
    }
  }

  Widget _buildContent(
    BuildContext context, {
    required List<Product> products,
    List<dynamic>? categories,
    List<Product>? lowStockAlerts,
    String? selectedCategoryId,
  }) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(RefreshProducts());
      },
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Low stock alert banner
          if (lowStockAlerts != null && lowStockAlerts.isNotEmpty)
            SliverToBoxAdapter(
              child: LowStockAlertBanner(
                count: lowStockAlerts.length,
                onTap: () => context.pushNamed(AppRouter.inventoryName),
              ),
            ),

          // Category pills
          if (categories != null && categories.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: CategoryPillRowWithAll(
                  categories: categories
                      .map((c) => CategoryPillData(
                            id: c.id,
                            name: c.nameEn,
                            nameKhmer: c.nameKh,
                          ))
                      .toList(),
                  selectedId: selectedCategoryId,
                  onSelected: (id) {
                    context
                        .read<ProductBloc>()
                        .add(SelectCategory(categoryId: id));
                  },
                ),
              ),
            ),

          // Product grid or empty state
          if (products.isEmpty)
            SliverFillRemaining(
              child: EmptyState(
                variant: EmptyStateVariant.noProducts,
                actionLabel: 'Add Product',
                onAction: () => context.pushNamed(AppRouter.productAddName),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.pageHorizontal,
                vertical: AppSpacing.sm,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisSpacing: AppSpacing.sm,
                  crossAxisSpacing: AppSpacing.sm,
                  childAspectRatio: 0.75,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final product = products[index];
                    return ProductGridItem(
                      product: product,
                      onTap: () => context.pushNamed(
                        AppRouter.productDetailName,
                        pathParameters: {'id': product.id},
                      ),
                      onLongPress: () => _showProductActions(context, product),
                    );
                  },
                  childCount: products.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.base),
      child: ProductGridSkeleton(),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: AppSpacing.base),
          Text(message, style: AppTextStyles.bodyMedium),
          const SizedBox(height: AppSpacing.base),
          ElevatedButton(
            onPressed: () =>
                context.read<ProductBloc>().add(const LoadProducts()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _showProductActions(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusExtraLarge),
        ),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppSpacing.base),
            Text(
              product.nameEn,
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Edit Product'),
              onTap: () {
                Navigator.pop(ctx);
                context.pushNamed(
                  AppRouter.productEditName,
                  pathParameters: {'id': product.id},
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory, color: AppColors.info),
              title: const Text('Adjust Stock'),
              onTap: () {
                Navigator.pop(ctx);
                context.pushNamed(
                  AppRouter.inventoryAdjustName,
                  extra: product,
                );
              },
            ),
            ListTile(
              leading: Icon(
                product.isActive ? Icons.visibility_off : Icons.visibility,
                color: AppColors.warning,
              ),
              title: Text(product.isActive ? 'Deactivate' : 'Activate'),
              onTap: () {
                Navigator.pop(ctx);
                context
                    .read<ProductBloc>()
                    .add(ToggleProductActive(id: product.id));
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Delete'),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDelete(context, product);
              },
            ),
            const SizedBox(height: AppSpacing.base),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.nameEn}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<ProductBloc>()
                  .add(DeleteProduct(id: product.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
