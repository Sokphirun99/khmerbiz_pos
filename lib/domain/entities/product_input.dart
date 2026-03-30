import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';

/// Value object for product creation/update form data.
///
/// Contains all editable product fields with built-in validation.
/// Use [validate] to check all fields and [toProductsCompanion] to
/// convert to a Drift companion for database operations.
class ProductInput extends Equatable {
  const ProductInput({
    this.barcode,
    this.nameKh = '',
    this.nameEn = '',
    this.categoryId,
    this.unit = 'pcs',
    this.costPrice = 0,
    this.retailPrice = 0,
    this.wholesalePrice,
    this.stock = 0,
    this.lowStockThreshold = 5,
    this.imagePath,
    this.isFeatured = false,
    this.isActive = true,
  });

  final String? barcode;
  final String nameKh;
  final String nameEn;
  final String? categoryId;
  final String unit;
  final double costPrice;
  final double retailPrice;
  final double? wholesalePrice;
  final double stock;
  final double lowStockThreshold;
  final String? imagePath;
  final bool isFeatured;
  final bool isActive;

  /// Khmer Unicode range check.
  static final _khmerRegex = RegExp(r'[\u1780-\u17FF]');

  /// Computed profit amount.
  double get profit => retailPrice - costPrice;

  /// Computed profit margin percentage.
  double get profitMargin =>
      retailPrice > 0 ? ((retailPrice - costPrice) / retailPrice) * 100 : 0;

  /// Whether retail price is at or below cost (margin warning).
  bool get hasMarginWarning => retailPrice > 0 && retailPrice <= costPrice;

  /// Validate all fields. Returns a map of field name → error message.
  /// Empty map means all fields are valid.
  Map<String, String> validate() {
    final errors = <String, String>{};

    // nameKh: required, min 2 chars, must contain Khmer Unicode
    if (nameKh.trim().isEmpty) {
      errors['nameKh'] = 'Khmer name is required';
    } else if (nameKh.trim().length < 2) {
      errors['nameKh'] = 'Khmer name must be at least 2 characters';
    } else if (!_khmerRegex.hasMatch(nameKh)) {
      errors['nameKh'] = 'Khmer name must contain Khmer characters';
    }

    // nameEn: required, min 2 chars
    if (nameEn.trim().isEmpty) {
      errors['nameEn'] = 'English name is required';
    } else if (nameEn.trim().length < 2) {
      errors['nameEn'] = 'English name must be at least 2 characters';
    }

    // retailPrice: required, > 0
    if (retailPrice <= 0) {
      errors['retailPrice'] = 'Retail price must be greater than 0';
    }

    // retailPrice > costPrice warning (not blocking, but flag it)
    if (retailPrice > 0 && retailPrice <= costPrice) {
      errors['retailPriceWarning'] =
          'Retail price should be greater than cost price';
    }

    // stock: >= 0
    if (stock < 0) {
      errors['stock'] = 'Stock cannot be negative';
    }

    // lowStockThreshold: >= 0
    if (lowStockThreshold < 0) {
      errors['lowStockThreshold'] = 'Low stock threshold cannot be negative';
    }

    return errors;
  }

  /// Whether the input passes all required validations (ignoring warnings).
  bool get isValid {
    final errors = validate();
    // Remove warning-only keys
    errors.remove('retailPriceWarning');
    return errors.isEmpty;
  }

  /// Convert to Drift [ProductsCompanion] for insert operations.
  ProductsCompanion toProductsCompanion({String? id}) {
    final now = DateTime.now();
    return ProductsCompanion(
      id: id != null ? Value(id) : const Value.absent(),
      barcode: Value(barcode),
      nameKh: Value(nameKh.trim()),
      nameEn: Value(nameEn.trim()),
      categoryId: Value(categoryId),
      unit: Value(unit),
      costPrice: Value(costPrice),
      retailPrice: Value(retailPrice),
      wholesalePrice: Value(wholesalePrice),
      stock: Value(stock),
      lowStockThreshold: Value(lowStockThreshold),
      imagePath: Value(imagePath),
      isFeatured: Value(isFeatured),
      isActive: Value(isActive),
      updatedAt: Value(now),
      createdAt: Value(now),
    );
  }

  /// Convert to Drift [ProductsCompanion] for update operations.
  /// Does not set [createdAt].
  ProductsCompanion toUpdateCompanion(String id) {
    return ProductsCompanion(
      id: Value(id),
      barcode: Value(barcode),
      nameKh: Value(nameKh.trim()),
      nameEn: Value(nameEn.trim()),
      categoryId: Value(categoryId),
      unit: Value(unit),
      costPrice: Value(costPrice),
      retailPrice: Value(retailPrice),
      wholesalePrice: Value(wholesalePrice),
      lowStockThreshold: Value(lowStockThreshold),
      imagePath: Value(imagePath),
      isFeatured: Value(isFeatured),
      isActive: Value(isActive),
      updatedAt: Value(DateTime.now()),
    );
  }

  ProductInput copyWith({
    String? barcode,
    String? nameKh,
    String? nameEn,
    String? categoryId,
    String? unit,
    double? costPrice,
    double? retailPrice,
    double? wholesalePrice,
    double? stock,
    double? lowStockThreshold,
    String? imagePath,
    bool? isFeatured,
    bool? isActive,
    bool clearBarcode = false,
    bool clearCategoryId = false,
    bool clearWholesalePrice = false,
    bool clearImagePath = false,
  }) {
    return ProductInput(
      barcode: clearBarcode ? null : (barcode ?? this.barcode),
      nameKh: nameKh ?? this.nameKh,
      nameEn: nameEn ?? this.nameEn,
      categoryId:
          clearCategoryId ? null : (categoryId ?? this.categoryId),
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: clearWholesalePrice
          ? null
          : (wholesalePrice ?? this.wholesalePrice),
      stock: stock ?? this.stock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imagePath: clearImagePath ? null : (imagePath ?? this.imagePath),
      isFeatured: isFeatured ?? this.isFeatured,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        barcode,
        nameKh,
        nameEn,
        categoryId,
        unit,
        costPrice,
        retailPrice,
        wholesalePrice,
        stock,
        lowStockThreshold,
        imagePath,
        isFeatured,
        isActive,
      ];
}
