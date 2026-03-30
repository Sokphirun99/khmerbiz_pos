import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductsInitial extends ProductState {}

final class ProductsLoading extends ProductState {}

final class ProductsLoaded extends ProductState {
  const ProductsLoaded({
    required this.products,
    required this.categories,
    required this.lowStockAlerts,
    this.selectedCategoryId,
    this.searchQuery,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<Product> products;
  final List<Category> categories;
  final List<Product> lowStockAlerts;
  final String? selectedCategoryId;
  final String? searchQuery;
  final bool hasMore;
  final bool isLoadingMore;

  ProductsLoaded copyWith({
    List<Product>? products,
    List<Category>? categories,
    List<Product>? lowStockAlerts,
    String? selectedCategoryId,
    String? searchQuery,
    bool? hasMore,
    bool? isLoadingMore,
    bool clearCategoryId = false,
    bool clearSearchQuery = false,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      lowStockAlerts: lowStockAlerts ?? this.lowStockAlerts,
      selectedCategoryId: clearCategoryId
          ? null
          : (selectedCategoryId ?? this.selectedCategoryId),
      searchQuery:
          clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
        products,
        categories,
        lowStockAlerts,
        selectedCategoryId,
        searchQuery,
        hasMore,
        isLoadingMore,
      ];
}

final class ProductsError extends ProductState {
  const ProductsError({required this.failure});
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class BarcodeScanning extends ProductState {}

final class ProductScanned extends ProductState {
  const ProductScanned({required this.product});
  final Product product;

  @override
  List<Object?> get props => [product];
}

final class BarcodeNotFound extends ProductState {
  const BarcodeNotFound({required this.barcode});
  final String barcode;

  @override
  List<Object?> get props => [barcode];
}

final class ProductSaved extends ProductState {
  const ProductSaved({required this.product});
  final Product product;

  @override
  List<Object?> get props => [product];
}
