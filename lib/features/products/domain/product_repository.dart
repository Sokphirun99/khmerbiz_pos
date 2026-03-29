import 'package:khmerbiz_pos/features/products/domain/product.dart';

/// Pagination result for product queries.
final class ProductPagedResult {
  const ProductPagedResult({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory ProductPagedResult.empty({int currentPage = 1, int pageSize = 20}) {
    return ProductPagedResult(
      products: [],
      currentPage: currentPage,
      totalPages: 0,
      totalItems: 0,
      pageSize: pageSize,
    );
  }

  /// List of products in this page
  final List<Product> products;

  /// Current page number (1-based)
  final int currentPage;

  /// Total number of pages
  final int totalPages;

  /// Total number of products
  final int totalItems;

  /// Page size
  final int pageSize;

  /// Whether there's a next page
  final bool hasNextPage;

  /// Whether there's a previous page
  final bool hasPreviousPage;
}

/// Filter options for product queries.
final class ProductFilter {
  const ProductFilter({
    this.searchQuery,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.lowStockOnly,
    this.outOfStockOnly,
    this.activeOnly,
    this.sortField = ProductSortField.name,
    this.sortOrder = SortOrder.ascending,
  });

  /// Search query (matches name, sku, barcode)
  final String? searchQuery;

  /// Category ID filter
  final String? categoryId;

  /// Minimum price filter
  final double? minPrice;

  /// Maximum price filter
  final double? maxPrice;

  /// Only show low stock products
  final bool? lowStockOnly;

  /// Only show out of stock products
  final bool? outOfStockOnly;

  /// Only show active products
  final bool? activeOnly;

  /// Sort field
  final ProductSortField sortField;

  /// Sort order
  final SortOrder sortOrder;

  ProductFilter copyWith({
    String? searchQuery,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    bool? lowStockOnly,
    bool? outOfStockOnly,
    bool? activeOnly,
    ProductSortField? sortField,
    SortOrder? sortOrder,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      categoryId: categoryId ?? this.categoryId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      lowStockOnly: lowStockOnly ?? this.lowStockOnly,
      outOfStockOnly: outOfStockOnly ?? this.outOfStockOnly,
      activeOnly: activeOnly ?? this.activeOnly,
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// Sort fields for products
enum ProductSortField {
  name,
  price,
  quantity,
  createdAt,
  updatedAt,
}

/// Sort order
enum SortOrder {
  ascending,
  descending,
}
