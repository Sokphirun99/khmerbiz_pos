import 'package:equatable/equatable.dart';

/// Product category for organization and filtering.
class Category extends Equatable {
  /// Creates a [Category] entity.
  const Category({
    required this.id,
    required this.nameKh,
    required this.nameEn,
    this.parentId,
    this.iconName,
    this.colorHex,
    this.sortOrder = 0,
    this.isActive = true,
  });

  /// Unique identifier for the category.
  final String id;

  /// Category name in Khmer.
  final String nameKh;

  /// Category name in English.
  final String nameEn;

  /// Optional ID of the parent category (for subcategories).
  final String? parentId;

  /// Name of the icon to display for this category.
  final String? iconName;

  /// Hexadecimal color code associated with the category.
  final String? colorHex;

  /// Sorting order for display in the category list.
  final int sortOrder;

  /// Whether the category is active and should be shown.
  final bool isActive;

  @override
  List<Object?> get props => [
        id,
        nameKh,
        nameEn,
        parentId,
        iconName,
        colorHex,
        sortOrder,
        isActive,
      ];
}
