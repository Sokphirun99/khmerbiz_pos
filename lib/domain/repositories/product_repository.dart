import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';

abstract class ProductRepository {
  Stream<Either<Failure, List<Product>>> watchAllActiveProducts();
  Stream<Either<Failure, List<Product>>> watchProductsByCategory(
      String categoryId);
  Stream<Either<Failure, List<Product>>> watchFeaturedProducts();
  Stream<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, Product?>> getProductByBarcode(String barcode);
  Future<Either<Failure, Product?>> getProductById(String id);
  Future<Either<Failure, List<Product>>> getProductsByIds(List<String> ids);
  Future<Either<Failure, List<Product>>> getLowStockProducts();
  Future<Either<Failure, String>> createProduct(Product product);
  Future<Either<Failure, void>> updateProduct(Product product);
  Future<Either<Failure, void>> deleteProduct(String id);
}
