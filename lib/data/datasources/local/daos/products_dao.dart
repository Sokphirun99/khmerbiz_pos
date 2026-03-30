import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:uuid/uuid.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products, Categories])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  final Uuid _uuid = const Uuid();

  // ── Product Streams ──────────────────────────────────────────────────────

  Stream<List<ProductModel>> watchAllActiveProducts() {
    return (select(products)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Stream<List<ProductModel>> watchProductsByCategory(String categoryId) {
    return (select(products)
          ..where((tbl) =>
              tbl.isActive.equals(true) & tbl.categoryId.equals(categoryId))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Stream<List<ProductModel>> watchFeaturedProducts() {
    return (select(products)
          ..where(
              (tbl) => tbl.isActive.equals(true) & tbl.isFeatured.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

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

  Future<ProductModel?> getProductByBarcode(String barcode) {
    return (select(products)..where((tbl) => tbl.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  Future<ProductModel?> getProductById(String id) {
    return (select(products)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<ProductModel>> getProductsByIds(List<String> ids) {
    return (select(products)..where((tbl) => tbl.id.isIn(ids))).get();
  }

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

  Future<void> updateStock(String productId, double delta) async {
    await customUpdate(
      'UPDATE products SET stock = stock + ? WHERE id = ?',
      variables: [Variable.withReal(delta), Variable.withString(productId)],
      updates: {products},
    );
  }

  Future<String> insertProduct(ProductsCompanion product) async {
    final id = product.id.present ? product.id.value : _uuid.v4();
    final companion = product.id.present
        ? product
        : product.copyWith(id: Value(id));
    await into(products).insert(companion);
    return id;
  }

  Future<void> updateProduct(ProductsCompanion product) async {
    await (update(products)..where((tbl) => tbl.id.equals(product.id.value)))
        .write(product);
  }

  Future<void> softDeleteProduct(String id) async {
    await (update(products)..where((tbl) => tbl.id.equals(id)))
        .write(const ProductsCompanion(isActive: Value(false)));
  }

  Future<void> toggleProductActive(String id) async {
    final product = await getProductById(id);
    if (product != null) {
      await (update(products)..where((tbl) => tbl.id.equals(id)))
          .write(ProductsCompanion(isActive: Value(!product.isActive)));
    }
  }

  // ── Category Queries ─────────────────────────────────────────────────────

  Stream<List<CategoryModel>> watchActiveCategories() {
    return (select(categories)
          ..where((tbl) => tbl.isActive.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<String> insertCategory(CategoriesCompanion category) async {
    final id = category.id.present ? category.id.value : _uuid.v4();
    final companion = category.id.present
        ? category
        : category.copyWith(id: Value(id));
    await into(categories).insert(companion);
    return id;
  }
}
