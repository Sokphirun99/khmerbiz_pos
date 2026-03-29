import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/products_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {

  ProductRepositoryImpl(this._dao);
  final ProductsDao _dao;

  Product _mapToDomain(ProductModel model) {
    return Product(
      id: model.id,
      barcode: model.barcode,
      nameKh: model.nameKh,
      nameEn: model.nameEn,
      categoryId: model.categoryId,
      unit: model.unit,
      costPrice: model.costPrice,
      retailPrice: model.retailPrice,
      wholesalePrice: model.wholesalePrice,
      stock: model.stock,
      reservedStock: model.reservedStock,
      lowStockThreshold: model.lowStockThreshold,
      imagePath: model.imagePath,
      isActive: model.isActive,
      isFeatured: model.isFeatured,
      sortOrder: model.sortOrder,
      updatedAt: model.updatedAt,
      createdAt: model.createdAt,
      remoteId: model.remoteId,
      isSynced: model.isSynced,
    );
  }

  @override
  Stream<Either<Failure, List<Product>>> watchAllActiveProducts() {
    return _dao.watchAllActiveProducts().map((models) {
      return right<Failure, List<Product>>(models.map(_mapToDomain).toList());
    }).handleError((error) {
      return left<Failure, List<Product>>(CacheFailure.defaultError(details: error.toString()));
    });
  }

  @override
  Stream<Either<Failure, List<Product>>> watchProductsByCategory(String categoryId) {
    return _dao.watchProductsByCategory(categoryId).map((models) {
      return right<Failure, List<Product>>(models.map(_mapToDomain).toList());
    }).handleError((error) {
      return left<Failure, List<Product>>(CacheFailure.defaultError(details: error.toString()));
    });
  }

  @override
  Stream<Either<Failure, List<Product>>> watchFeaturedProducts() {
    return _dao.watchFeaturedProducts().map((models) {
      return right<Failure, List<Product>>(models.map(_mapToDomain).toList());
    }).handleError((error) {
      return left<Failure, List<Product>>(CacheFailure.defaultError(details: error.toString()));
    });
  }

  @override
  Stream<Either<Failure, List<Product>>> searchProducts(String query) {
    return _dao.searchProducts(query).map((models) {
      return right<Failure, List<Product>>(models.map(_mapToDomain).toList());
    }).handleError((error) {
      return left<Failure, List<Product>>(CacheFailure.defaultError(details: error.toString()));
    });
  }

  @override
  Future<Either<Failure, Product?>> getProductByBarcode(String barcode) async {
    try {
      final raw = await _dao.getProductByBarcode(barcode);
      return right(raw != null ? _mapToDomain(raw) : null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product?>> getProductById(String id) async {
    try {
      final raw = await _dao.getProductById(id);
      return right(raw != null ? _mapToDomain(raw) : null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts() async {
    try {
      final list = await _dao.getLowStockProducts();
      return right(list.map(_mapToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> createProduct(Product product) async {
    try {
      final id = await _dao.insertProduct(ProductsCompanion(
        id: product.id.isNotEmpty ? Value(product.id) : const Value.absent(),
        nameKh: Value(product.nameKh),
        nameEn: Value(product.nameEn),
        categoryId: Value(product.categoryId),
        retailPrice: Value(product.retailPrice),
        costPrice: Value(product.costPrice),
        updatedAt: Value(DateTime.now()),
        createdAt: Value(DateTime.now()),
      ),);
      return right(id);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(Product product) async {
    try {
      // Basic implementation mapping
      await _dao.updateProduct(ProductsCompanion(
        id: Value(product.id),
        nameKh: Value(product.nameKh),
        nameEn: Value(product.nameEn),
        retailPrice: Value(product.retailPrice),
        updatedAt: Value(DateTime.now()),
      ),);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await _dao.softDeleteProduct(id);
      return right(null);
    } catch(e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }
}
