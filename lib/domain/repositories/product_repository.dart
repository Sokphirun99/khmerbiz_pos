import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';

/// Pagination result for product queries.
final class ProductPagedResult {
  /// Creates a [ProductPagedResult].
  const ProductPagedResult({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  /// Factory constructor for an empty result page.
  factory ProductPagedResult.empty({int currentPage = 1, int pageSize = 20}) {
    return ProductPagedResult(
      products: [],
      currentPage: currentPage,
      totalPages: 0,
      totalItems: 0,
      pageSize: pageSize,
    );
  }

  /// List of products in the current page.
  final List<Product> products;

  /// The current page number (1-indexed).
  final int currentPage;

  /// Total number of pages available.
  final int totalPages;

  /// Total number of items across all pages.
  final int totalItems;

  /// Maximum number of items per page.
  final int pageSize;

  /// Whether there is a subsequent page.
  final bool hasNextPage;

  /// Whether there is a preceding page.
  final bool hasPreviousPage;
}

/// Filter options for product queries.
final class ProductFilter {
  /// Creates a [ProductFilter] with specified criteria.
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

  /// Optional search string for name or barcode.
  final String? searchQuery;

  /// Optional category filter.
  final String? categoryId;

  /// Minimum retail price filter (in KHR).
  final double? minPrice;

  /// Maximum retail price filter (in KHR).
  final double? maxPrice;

  /// Whether to only include products at or below low stock threshold.
  final bool? lowStockOnly;

  /// Whether to only include products with zero or negative stock.
  final bool? outOfStockOnly;

  /// Whether to only include active products (default is typically true).
  final bool? activeOnly;

  /// Field to sort results by.
  final ProductSortField sortField;

  /// Direction of sorting.
  final SortOrder sortOrder;

  /// Returns a copy of this filter with updated fields.
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

/// Fields available for sorting products.
enum ProductSortField {
  /// Sort by product name.
  name,

  /// Sort by retail price.
  price,

  /// Sort by current stock quantity.
  quantity,

  /// Sort by creation date.
  createdAt,

  /// Sort by last update date.
  updatedAt
}

/// Order of sorting.
enum SortOrder {
  /// Smallest to largest (or A to Z).
  ascending,

  /// Largest to smallest (or Z to A).
  descending
}

/// Repository interface for product and category management.
abstract class ProductRepository {
  // ── Streams ──────────────────────────────────────────────────────────────

  /// Watches all products marked as active.
  Stream<Either<Failure, List<Product>>> watchAllActiveProducts();

  /// Watches products belonging to a specific [categoryId].
  Stream<Either<Failure, List<Product>>> watchProductsByCategory(
    String categoryId,
  );

  /// Watches products marked as featured.
  Stream<Either<Failure, List<Product>>> watchFeaturedProducts();

  /// Performs a fuzzy search for products by name or barcode.
  Stream<Either<Failure, List<Product>>> searchProducts(String query);

  // ── Single lookups ───────────────────────────────────────────────────────

  /// Finds a product by its [barcode].
  Future<Either<Failure, Product?>> getProductByBarcode(String barcode);

  /// Retrieves a product by its unique [id].
  Future<Either<Failure, Product?>> getProductById(String id);

  /// Retrieves a list of products matching the provided [ids].
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> ids);

  /// Returns products currently at or below their low stock threshold.
  Future<Either<Failure, List<Product>>> getLowStockProducts();

  // ── Categories ───────────────────────────────────────────────────────────

  /// Watches all categories marked as active.
  Stream<Either<Failure, List<Category>>> watchActiveCategories();

  /// Creates a new product [category].
  Future<Either<Failure, String>> createCategory(Category category);

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Creates a new product from the provided [input].
  Future<Either<Failure, String>> createProduct(ProductInput input);

  /// Updates an existing product identified by [id] with new [input].
  Future<Either<Failure, void>> updateProduct(String id, ProductInput input);

  /// Permanently deletes a product by [id].
  Future<Either<Failure, void>> deleteProduct(String id);

  /// Toggles the active status of a product.
  Future<Either<Failure, void>> toggleProductActive(String id);
}
