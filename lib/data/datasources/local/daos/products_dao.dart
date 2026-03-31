import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:uuid/uuid.dart';

part 'products_dao.g.dart';

/// Data Access Object for Product and Category tables.
///
/// Handles CRUD operations and reactive streams for products and categories.
@DriftAccessor(tables: [Products, Categories])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  /// Creates a new [ProductsDao] with the given [db].
  ProductsDao(super.db);

  final Uuid _uuid = const Uuid();

  // ── Product Streams ──────────────────────────────────────────────────────

  /// Returns a stream of all active products, ordered by [sortOrder].
  Stream<List<ProductModel>> watchAllActiveProducts() {
    return (select(products)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Returns a stream of active products filtered by [categoryId].
  Stream<List<ProductModel>> watchProductsByCategory(String categoryId) {
    return (select(products)
          ..where((tbl) =>
              tbl.isActive.equals(true) & tbl.categoryId.equals(categoryId),)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Returns a stream of active products that are marked as featured.
  Stream<List<ProductModel>> watchFeaturedProducts() {
    return (select(products)
          ..where(
              (tbl) => tbl.isActive.equals(true) & tbl.isFeatured.equals(true),)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Searches active products by [query] in name (Khmer/English) or barcode.
  Stream<List<ProductModel>> searchProducts(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(products)
          ..where(
            (tbl) =>
                tbl.isActive.equals(true) &
                (tbl.nameKh.like(lowerQuery) |
                    tbl.nameEn.like(lowerQuery) |
                    tbl.barcode.like(lowerQuery)),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  // ── Single Lookups ───────────────────────────────────────────────────────

  /// Retrieves a single product by its [barcode].
  Future<ProductModel?> getProductByBarcode(String barcode) {
    return (select(products)..where((tbl) => tbl.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  /// Retrieves a single product by its [id].
  Future<ProductModel?> getProductById(String id) {
    return (select(products)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  /// Retrieves a list of products matching the provided [ids].
  Future<List<ProductModel>> getProductsByIds(List<String> ids) {
    return (select(products)..where((tbl) => tbl.id.isIn(ids))).get();
  }

  /// Retrieves active products where stock is at or below the low stock threshold.
  Future<List<ProductModel>> getLowStockProducts() {
    return (select(products)
          ..where(
            (tbl) =>
                tbl.isActive.equals(true) &
                tbl.stock.isSmallerOrEqual(tbl.lowStockThreshold),
          ))
        .get();
  }

  // ── Pagination ───────────────────────────────────────────────────────────

  /// Retrieves a paginated list of active products.
  ///
  /// [limit] defines the page size, [offset] defines the starting point.
  /// Optionally filters by [categoryId].
  Future<List<ProductModel>> getProductsPage({
    required int limit,
    required int offset,
    String? categoryId,
  }) {
    final query = select(products)
      ..where((tbl) => tbl.isActive.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])
      ..limit(limit, offset: offset);

    if (categoryId != null) {
      query.where((tbl) => tbl.categoryId.equals(categoryId));
    }

    return query.get();
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  /// Updates the stock quantity for a [productId] by the specified [delta].
  Future<void> updateStock(String productId, double delta) async {
    await customUpdate(
      'UPDATE products SET stock = stock + ? WHERE id = ?',
      variables: [Variable.withReal(delta), Variable.withString(productId)],
      updates: {products},
    );
  }

  /// Inserts a new product into the database.
  ///
  /// Generates a UUID if [product.id] is not present.
  /// Returns the inserted product ID.
  Future<String> insertProduct(ProductsCompanion product) async {
    final id = product.id.present ? product.id.value : _uuid.v4();
    final companion = product.id.present
        ? product
        : product.copyWith(id: Value(id));
    await into(products).insert(companion);
    return id;
  }

  /// Updates an existing product's data.
  Future<void> updateProduct(ProductsCompanion product) async {
    await (update(products)..where((tbl) => tbl.id.equals(product.id.value)))
        .write(product);
  }

  /// Soft deletes a product by setting [isActive] to false.
  Future<void> softDeleteProduct(String id) async {
    await (update(products)..where((tbl) => tbl.id.equals(id)))
        .write(const ProductsCompanion(isActive: Value(false)));
  }

  /// Toggles the [isActive] status of a product.
  Future<void> toggleProductActive(String id) async {
    final product = await getProductById(id);
    if (product != null) {
      await (update(products)..where((tbl) => tbl.id.equals(id)))
          .write(ProductsCompanion(isActive: Value(!product.isActive)));
    }
  }

  // ── Category Queries ─────────────────────────────────────────────────────

  /// Returns a stream of all active categories, ordered by [sortOrder].
  Stream<List<CategoryModel>> watchActiveCategories() {
    return (select(categories)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  /// Inserts a new category into the database.
  ///
  /// Generates a UUID if [category.id] is not present.
  /// Returns the inserted category ID.
  Future<String> insertCategory(CategoriesCompanion category) async {
    final id = category.id.present ? category.id.value : _uuid.v4();
    final companion = category.id.present
        ? category
        : category.copyWith(id: Value(id));
    await into(categories).insert(companion);
    return id;
  }
}
