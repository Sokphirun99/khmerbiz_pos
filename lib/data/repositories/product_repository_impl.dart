import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/products_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';

/// Implementation of [ProductRepository] using [ProductsDao].
///
/// Handles product and category CRUD operations, reactive updates, and search.
@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  /// Creates a new [ProductRepositoryImpl] with the given [ProductsDao].
  ProductRepositoryImpl(this._dao);
  final ProductsDao _dao;

  // ── Mappers ──────────────────────────────────────────────────────────────

  Product _mapProductToDomain(ProductModel model) {
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

  Category _mapCategoryToDomain(CategoryModel model) {
    return Category(
      id: model.id,
      nameKh: model.nameKh,
      nameEn: model.nameEn,
      parentId: model.parentId,
      iconName: model.iconName,
      colorHex: model.colorHex,
      sortOrder: model.sortOrder,
      isActive: model.isActive,
    );
  }

  // ── Product Streams ──────────────────────────────────────────────────────

  @override
  Stream<Either<Failure, List<Product>>> watchAllActiveProducts() {
    return _dao.watchAllActiveProducts().map((models) {
      return right<Failure, List<Product>>(
          models.map(_mapProductToDomain).toList(),);
    }).handleError((Object error) {
      return left<Failure, List<Product>>(
          CacheFailure.defaultError(details: error.toString()),);
    });
  }

  @override
  Stream<Either<Failure, List<Product>>> watchProductsByCategory(
      String categoryId,) {
    return _dao.watchProductsByCategory(categoryId).map((models) {
      return right<Failure, List<Product>>(
          models.map(_mapProductToDomain).toList(),);
    }).handleError((Object error) {
      return left<Failure, List<Product>>(
          CacheFailure.defaultError(details: error.toString()),);
    });
  }

  @override
  Stream<Either<Failure, List<Product>>> watchFeaturedProducts() {
    return _dao.watchFeaturedProducts().map((models) {
      return right<Failure, List<Product>>(
          models.map(_mapProductToDomain).toList(),);
    }).handleError((Object error) {
      return left<Failure, List<Product>>(
          CacheFailure.defaultError(details: error.toString()),);
    });
  }

  @override
  Stream<Either<Failure, List<Product>>> searchProducts(String query) {
    return _dao.searchProducts(query).map((models) {
      return right<Failure, List<Product>>(
          models.map(_mapProductToDomain).toList(),);
    }).handleError((Object error) {
      return left<Failure, List<Product>>(
          CacheFailure.defaultError(details: error.toString()),);
    });
  }

  // ── Single Lookups ───────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Product?>> getProductByBarcode(String barcode) async {
    try {
      final raw = await _dao.getProductByBarcode(barcode);
      return right(raw != null ? _mapProductToDomain(raw) : null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product?>> getProductById(String id) async {
    try {
      final raw = await _dao.getProductById(id);
      return right(raw != null ? _mapProductToDomain(raw) : null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByIds(
      List<String> ids,) async {
    try {
      final list = await _dao.getProductsByIds(ids);
      return right(list.map(_mapProductToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getLowStockProducts() async {
    try {
      final list = await _dao.getLowStockProducts();
      return right(list.map(_mapProductToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  // ── Categories ───────────────────────────────────────────────────────────

  @override
  Stream<Either<Failure, List<Category>>> watchActiveCategories() {
    return _dao.watchActiveCategories().map((models) {
      return right<Failure, List<Category>>(
          models.map(_mapCategoryToDomain).toList(),);
    }).handleError((Object error) {
      return left<Failure, List<Category>>(
          CacheFailure.defaultError(details: error.toString()),);
    });
  }

  @override
  Future<Either<Failure, String>> createCategory(Category category) async {
    try {
      final id = await _dao.insertCategory(
        CategoriesCompanion(
          id: category.id.isNotEmpty
              ? Value(category.id)
              : const Value.absent(),
          nameKh: Value(category.nameKh),
          nameEn: Value(category.nameEn),
          parentId: Value(category.parentId),
          iconName: Value(category.iconName),
          colorHex: Value(category.colorHex),
          sortOrder: Value(category.sortOrder),
          isActive: Value(category.isActive),
        ),
      );
      return right(id);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  // ── Mutations ────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, String>> createProduct(ProductInput input) async {
    try {
      final id = await _dao.insertProduct(input.toProductsCompanion());
      return right(id);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
      String id, ProductInput input,) async {
    try {
      await _dao.updateProduct(input.toUpdateCompanion(id));
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
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> toggleProductActive(String id) async {
    try {
      await _dao.toggleProductActive(id);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }
}
