import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';

/// Base class for all product-related events.
sealed class ProductEvent extends Equatable {
  /// Creates a [ProductEvent].
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load all active products, optionally filtered by category.
final class LoadProducts extends ProductEvent {
  /// Creates a [LoadProducts] event.
  const LoadProducts({this.categoryId});

  /// Optional category ID to filter products.
  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// Event to search products with debounce (droppable transformer).
final class SearchProducts extends ProductEvent {
  /// Creates a [SearchProducts] event.
  const SearchProducts({required this.query});

  /// The search query string.
  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to select a category filter. Null = show all.
final class SelectCategory extends ProductEvent {
  /// Creates a [SelectCategory] event.
  const SelectCategory({this.categoryId});

  /// The ID of the selected category.
  final String? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// Event to initiate barcode scanning.
final class ScanBarcode extends ProductEvent {
  /// Creates a [ScanBarcode] event.
  const ScanBarcode();
}

/// Event indicating a barcode was detected by the scanner.
final class BarcodeDetected extends ProductEvent {
  /// Creates a [BarcodeDetected] event.
  const BarcodeDetected({required this.barcode});

  /// The scanned barcode value.
  final String barcode;

  @override
  List<Object?> get props => [barcode];
}

/// Event to add a new product.
final class AddProduct extends ProductEvent {
  /// Creates an [AddProduct] event.
  const AddProduct({required this.input});

  /// The input data for the new product.
  final ProductInput input;

  @override
  List<Object?> get props => [input];
}

/// Event to update an existing product.
final class UpdateProduct extends ProductEvent {
  /// Creates an [UpdateProduct] event.
  const UpdateProduct({required this.id, required this.input});

  /// The unique ID of the product to update.
  final String id;

  /// The updated product data.
  final ProductInput input;

  @override
  List<Object?> get props => [id, input];
}

/// Event to soft-delete a product.
final class DeleteProduct extends ProductEvent {
  /// Creates a [DeleteProduct] event.
  const DeleteProduct({required this.id});

  /// The unique ID of the product to delete.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to toggle a product's active status.
final class ToggleProductActive extends ProductEvent {
  /// Creates a [ToggleProductActive] event.
  const ToggleProductActive({required this.id});

  /// The unique ID of the product to toggle.
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Event to trigger loading more products (pagination).
final class LoadMoreProducts extends ProductEvent {
  /// Creates a [LoadMoreProducts] event.
  const LoadMoreProducts();
}

/// Event to pull-to-refresh products.
final class RefreshProducts extends ProductEvent {
  /// Creates a [RefreshProducts] event.
  const RefreshProducts();
}
