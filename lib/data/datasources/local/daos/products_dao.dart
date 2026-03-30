import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:uuid/uuid.dart';

part 'products_dao.g.dart';

@DriftAccessor(tables: [Products, Categories])
class ProductsDao extends DatabaseAccessor<AppDatabase>
    with _$ProductsDaoMixin {
  ProductsDao(super.db);

  final Uuid _uuid = const Uuid();

  Stream<List<ProductModel>> watchAllActiveProducts() {
    return (select(products)..where((tbl) => tbl.isActive.equals(true)))
        .watch();
  }

  Stream<List<ProductModel>> watchProductsByCategory(String categoryId) {
    return (select(products)
          ..where((tbl) =>
              tbl.isActive.equals(true) & tbl.categoryId.equals(categoryId)))
        .watch();
  }

  Stream<List<ProductModel>> watchFeaturedProducts() {
    return (select(products)
          ..where(
              (tbl) => tbl.isActive.equals(true) & tbl.isFeatured.equals(true)))
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
          ))
        .watch();
  }

  Future<ProductModel?> getProductByBarcode(String barcode) {
    return (select(products)..where((tbl) => tbl.barcode.equals(barcode)))
        .getSingleOrNull();
  }

  Future<ProductModel?> getProductById(String id) {
    return (select(products)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
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

  Future<void> updateStock(String productId, double delta) async {
    await customUpdate(
      'UPDATE products SET stock = stock + ? WHERE id = ?',
      variables: [Variable.withReal(delta), Variable.withString(productId)],
      updates: {products},
    );
  }

  Future<String> insertProduct(ProductsCompanion product) async {
    final id = product.id.present ? product.id.value : _uuid.v4();
    await into(products).insert(product);
    return id;
  }

  Future<void> updateProduct(ProductsCompanion product) async {
    await update(products).replace(product);
  }

  Future<void> softDeleteProduct(String id) async {
    await (update(products)..where((tbl) => tbl.id.equals(id)))
        .write(const ProductsCompanion(isActive: Value(false)));
  }
}
