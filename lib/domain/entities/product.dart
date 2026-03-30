import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.nameKh,
    required this.nameEn,
    required this.retailPrice,
    required this.updatedAt,
    required this.createdAt,
    this.barcode,
    this.categoryId,
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
  final String id;
  final String? barcode;
  final String nameKh;
  final String nameEn;
  final String? categoryId;
  final String unit;
  final double costPrice;
  final double retailPrice;
  final double? wholesalePrice;
  final double stock;
  final double reservedStock;
  final double lowStockThreshold;
  final String? imagePath;
  final bool isActive;
  final bool isFeatured;
  final int sortOrder;
  final DateTime updatedAt;
  final DateTime createdAt;
  final String? remoteId;
  final bool isSynced;

  Product copyWith({
    String? id,
    String? barcode,
    String? nameKh,
    String? nameEn,
    String? categoryId,
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

  @override
  List<Object?> get props => [
        id,
        barcode,
        nameKh,
        nameEn,
        categoryId,
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
}
