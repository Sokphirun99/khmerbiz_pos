import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';

abstract class ProductRepository {
  // ── Streams ──────────────────────────────────────────────────────────────
  Stream<Either<Failure, List<Product>>> watchAllActiveProducts();
  Stream<Either<Failure, List<Product>>> watchProductsByCategory(
      String categoryId);
  Stream<Either<Failure, List<Product>>> watchFeaturedProducts();
  Stream<Either<Failure, List<Product>>> searchProducts(String query);

  // ── Single lookups ───────────────────────────────────────────────────────
  Future<Either<Failure, Product?>> getProductByBarcode(String barcode);
  Future<Either<Failure, Product?>> getProductById(String id);
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> ids);
  Future<Either<Failure, List<Product>>> getLowStockProducts();

  // ── Categories ───────────────────────────────────────────────────────────
  Stream<Either<Failure, List<Category>>> watchActiveCategories();
  Future<Either<Failure, String>> createCategory(Category category);

  // ── Mutations ────────────────────────────────────────────────────────────
  Future<Either<Failure, String>> createProduct(ProductInput input);
  Future<Either<Failure, void>> updateProduct(String id, ProductInput input);
  Future<Either<Failure, void>> deleteProduct(String id);
  Future<Either<Failure, void>> toggleProductActive(String id);
}
