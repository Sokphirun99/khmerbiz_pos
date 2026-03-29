import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String nameKh;
  final String nameEn;
  final String? parentId;
  final String? iconName;
  final String? colorHex;
  final int sortOrder;
  final bool isActive;

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
