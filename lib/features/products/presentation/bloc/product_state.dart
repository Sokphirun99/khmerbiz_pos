import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

/// Base class for all product-related states.
sealed class ProductState extends Equatable {
  /// Creates a [ProductState].
  const ProductState();

  @override
  List<Object?> get props => [];
}

/// Initial state for the products feature.
final class ProductsInitial extends ProductState {}

/// State indicating that product data is currently being loaded.
final class ProductsLoading extends ProductState {}

/// State when products and categories have been successfully loaded.
final class ProductsLoaded extends ProductState {
  /// Creates a [ProductsLoaded] state.
  const ProductsLoaded({
    required this.products,
    required this.categories,
    required this.lowStockAlerts,
    this.selectedCategoryId,
    this.searchQuery,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  /// The list of products to display.
  final List<Product> products;

  /// The list of available categories.
  final List<Category> categories;

  /// The list of products triggered by low stock thresholds.
  final List<Product> lowStockAlerts;

  /// The currently selected category filter ID.
  final String? selectedCategoryId;

  /// The current search query string.
  final String? searchQuery;

  /// Whether there are more products to load (pagination).
  final bool hasMore;

  /// Whether a "load more" operation is currently in progress.
  final bool isLoadingMore;

  /// Creates a copy of this state with the given fields replaced by the new values.
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

/// State indicating an error occurred in the products feature.
final class ProductsError extends ProductState {
  /// Creates a [ProductsError] state.
  const ProductsError({required this.failure});

  /// The failure that caused the error.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// State when barcode scanning is active.
final class BarcodeScanning extends ProductState {}

/// State when a product has been successfully scanned via barcode.
final class ProductScanned extends ProductState {
  /// Creates a [ProductScanned] state.
  const ProductScanned({required this.product});

  /// The scanned product.
  final Product product;

  @override
  List<Object?> get props => [product];
}

/// State when a scanned barcode does not match any existing product.
final class BarcodeNotFound extends ProductState {
  /// Creates a [BarcodeNotFound] state.
  const BarcodeNotFound({required this.barcode});

  /// The barcode value that was not found.
  final String barcode;

  @override
  List<Object?> get props => [barcode];
}

/// State indicating a product operation (add/update) was successful.
final class ProductSaved extends ProductState {
  /// Creates a [ProductSaved] state.
  const ProductSaved({required this.product});

  /// The saved product.
  final Product product;

  @override
  List<Object?> get props => [product];
}
