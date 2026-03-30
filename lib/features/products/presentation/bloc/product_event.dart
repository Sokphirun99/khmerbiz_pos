import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Load all active products, optionally filtered by category.
final class LoadProducts extends ProductEvent {
  const LoadProducts({this.categoryId});
  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// Search products with debounce (droppable transformer).
final class SearchProducts extends ProductEvent {
  const SearchProducts({required this.query});
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Select a category filter. Null = show all.
final class SelectCategory extends ProductEvent {
  const SelectCategory({this.categoryId});
  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// Initiate barcode scanning.
final class ScanBarcode extends ProductEvent {}

/// A barcode was detected by the scanner.
final class BarcodeDetected extends ProductEvent {
  const BarcodeDetected({required this.barcode});
  final String barcode;

  @override
  List<Object?> get props => [barcode];
}

/// Add a new product.
final class AddProduct extends ProductEvent {
  const AddProduct({required this.input});
  final ProductInput input;

  @override
  List<Object?> get props => [input];
}

/// Update an existing product.
final class UpdateProduct extends ProductEvent {
  const UpdateProduct({required this.id, required this.input});
  final String id;
  final ProductInput input;

  @override
  List<Object?> get props => [id, input];
}

/// Soft-delete a product.
final class DeleteProduct extends ProductEvent {
  const DeleteProduct({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Toggle a product's active status.
final class ToggleProductActive extends ProductEvent {
  const ToggleProductActive({required this.id});
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Trigger loading more products (pagination).
final class LoadMoreProducts extends ProductEvent {}

/// Pull-to-refresh products.
final class RefreshProducts extends ProductEvent {}
