import 'package:equatable/equatable.dart';

/// Product entity representing an item for sale.
///
/// This is the primary domain object for products, aligned with the database schema.
class Product extends Equatable {
  /// Creates a [Product] entity.
  const Product({
    required this.id,
    required this.nameKh,
    required this.nameEn,
    required this.retailPrice,
    required this.updatedAt,
    required this.createdAt,
    this.barcode,
    this.categoryId,
    this.categoryName,
    this.unit = 'pcs',
    this.costPrice = 0,
    this.wholesalePrice,
    this.stock = 0,
    this.reservedStock = 0,
    this.lowStockThreshold = 5,
    this.imagePath,
    this.isActive = true,
    this.isFeatured = false,
    this.sortOrder = 0,
    this.remoteId,
    this.isSynced = false,
  });

  /// Unique identifier for the product.
  final String id;

  /// Optional barcode or QR code string.
  final String? barcode;

  /// Product name in Khmer.
  final String nameKh;

  /// Product name in English.
  final String nameEn;

  /// ID of the category this product belongs to.
  final String? categoryId;

  /// Name of the category (cached for display).
  final String? categoryName;

  /// Unit of measurement (e.g., "pcs", "kg", "box").
  final String unit;

  /// Cost price (purchase price) per unit.
  final double costPrice;

  /// Standard retail selling price per unit.
  final double retailPrice;

  /// Optional wholesale selling price.
  final double? wholesalePrice;

  /// Current physical stock quantity.
  final double stock;

  /// Stock quantity reserved for pending orders.
  final double reservedStock;

  /// Threshold at which the product is considered "low stock".
  final double lowStockThreshold;

  /// Local or remote path to the product image.
  final String? imagePath;

  /// Whether the product is currently active and saleable.
  final bool isActive;

  /// Whether the product should be featured in the highlights section.
  final bool isFeatured;

  /// Sorting order for display in the product list.
  final int sortOrder;

  /// Timestamp of the last local update.
  final DateTime updatedAt;

  /// Timestamp of when the product was first created.
  final DateTime createdAt;

  /// Server-side unique identifier (for sync).
  final String? remoteId;

  /// Whether the product changes have been synced to the server.
  final bool isSynced;

  /// Check if product is low on stock.
  bool get isLowStock => stock <= lowStockThreshold;

  /// Check if product is out of stock.
  bool get isOutOfStock => stock <= 0;

  /// Check if product is in stock.
  bool get isInStock => stock > 0;

  /// Computed profit amount per unit.
  double get profit => retailPrice - costPrice;

  /// Computed profit margin percentage.
  double get profitMargin =>
      retailPrice > 0 ? ((retailPrice - costPrice) / retailPrice) * 100 : 0;

  @override
  List<Object?> get props => [
        id,
        barcode,
        nameKh,
        nameEn,
        categoryId,
        categoryName,
        unit,
        costPrice,
        retailPrice,
        wholesalePrice,
        stock,
        reservedStock,
        lowStockThreshold,
        imagePath,
        isActive,
        isFeatured,
        sortOrder,
        updatedAt,
        createdAt,
        remoteId,
        isSynced,
      ];

  /// Creates a copy of [Product] with the given fields replaced.
  Product copyWith({
    String? id,
    String? barcode,
    String? nameKh,
    String? nameEn,
    String? categoryId,
    String? categoryName,
    String? unit,
    double? costPrice,
    double? retailPrice,
    double? wholesalePrice,
    double? stock,
    double? reservedStock,
    double? lowStockThreshold,
    String? imagePath,
    bool? isActive,
    bool? isFeatured,
    int? sortOrder,
    DateTime? updatedAt,
    DateTime? createdAt,
    String? remoteId,
    bool? isSynced,
  }) {
    return Product(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      nameKh: nameKh ?? this.nameKh,
      nameEn: nameEn ?? this.nameEn,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      unit: unit ?? this.unit,
      costPrice: costPrice ?? this.costPrice,
      retailPrice: retailPrice ?? this.retailPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      stock: stock ?? this.stock,
      reservedStock: reservedStock ?? this.reservedStock,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      isFeatured: isFeatured ?? this.isFeatured,
      sortOrder: sortOrder ?? this.sortOrder,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt,
      remoteId: remoteId ?? this.remoteId,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
