import 'package:equatable/equatable.dart';

/// Product entity representing an item for sale.
///
/// This is a pure domain object with no dependencies on Flutter or data layers.
final class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.priceKhr,
    required this.createdAt,
    this.description,
    this.sku,
    this.barcode,
    this.categoryId,
    this.categoryName,
    this.priceUsd,
    this.costPrice,
    this.quantity = 0,
    this.lowStockThreshold,
    this.unit,
    this.images = const [],
    this.isActive = true,
    this.isTaxable = true,
    this.taxRate,
    this.discountPercent,
    this.minQuantity,
    this.maxQuantity,
    this.updatedAt,
    this.syncedAt,
  });

  /// Unique product identifier
  final String id;

  /// Product name
  final String name;

  /// Product description
  final String? description;

  /// SKU (Stock Keeping Unit)
  final String? sku;

  /// Barcode
  final String? barcode;

  /// Category ID
  final String? categoryId;

  /// Category name
  final String? categoryName;

  /// Price in KHR
  final double priceKhr;

  /// Price in USD (optional, if different from exchange rate)
  final double? priceUsd;

  /// Cost price in KHR (for profit calculation)
  final double? costPrice;

  /// Current stock quantity
  final int quantity;

  /// Low stock threshold for this product
  final int? lowStockThreshold;

  /// Unit of measurement (e.g., 'pcs', 'kg', 'liter')
  final String? unit;

  /// Product image URLs
  final List<String> images;

  /// Whether product is active/available for sale
  final bool isActive;

  /// Whether product is taxable
  final bool isTaxable;

  /// Tax rate percentage (if different from default)
  final double? taxRate;

  /// Discount percentage
  final double? discountPercent;

  /// Minimum quantity for sale
  final int? minQuantity;

  /// Maximum quantity for sale
  final int? maxQuantity;

  /// Product creation timestamp
  final DateTime createdAt;

  /// Last update timestamp
  final DateTime? updatedAt;

  /// Last synced timestamp
  final DateTime? syncedAt;

  /// Check if product is low on stock
  bool get isLowStock {
    final threshold = lowStockThreshold ?? 10;
    return quantity <= threshold;
  }

  /// Check if product is out of stock
  bool get isOutOfStock => quantity <= 0;

  /// Check if product is in stock
  bool get isInStock => quantity > 0;

  /// Get the effective price (after discount)
  double get effectivePrice {
    if (discountPercent == null || discountPercent! <= 0) {
      return priceKhr;
    }
    return priceKhr * (1 - discountPercent! / 100);
  }

  /// Get profit per unit
  double? get profitPerUnit {
    if (costPrice == null) return null;
    return effectivePrice - costPrice!;
  }

  /// Get profit margin percentage
  double? get profitMargin {
    if (costPrice == null || costPrice! == 0) return null;
    return ((effectivePrice - costPrice!) / costPrice!) * 100;
  }

  /// Create a copy of this product with updated fields.
  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? sku,
    String? barcode,
    String? categoryId,
    String? categoryName,
    double? priceKhr,
    double? priceUsd,
    double? costPrice,
    int? quantity,
    int? lowStockThreshold,
    String? unit,
    List<String>? images,
    bool? isActive,
    bool? isTaxable,
    double? taxRate,
    double? discountPercent,
    int? minQuantity,
    int? maxQuantity,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      priceKhr: priceKhr ?? this.priceKhr,
      priceUsd: priceUsd ?? this.priceUsd,
      costPrice: costPrice ?? this.costPrice,
      quantity: quantity ?? this.quantity,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      unit: unit ?? this.unit,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive,
      isTaxable: isTaxable ?? this.isTaxable,
      taxRate: taxRate ?? this.taxRate,
      discountPercent: discountPercent ?? this.discountPercent,
      minQuantity: minQuantity ?? this.minQuantity,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        sku,
        barcode,
        categoryId,
        categoryName,
        priceKhr,
        priceUsd,
        costPrice,
        quantity,
        lowStockThreshold,
        unit,
        images,
        isActive,
        isTaxable,
        taxRate,
        discountPercent,
        minQuantity,
        maxQuantity,
        createdAt,
        updatedAt,
        syncedAt,
      ];

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $priceKhr, quantity: $quantity)';
  }
}
