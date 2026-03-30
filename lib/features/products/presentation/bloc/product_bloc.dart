import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_event.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_state.dart';

/// Debounce duration for search events.
const _searchDebounce = Duration(milliseconds: 300);

/// Page size for product pagination.
const _pageSize = 50;

/// Threshold for in-memory search vs DB search.
const _inMemorySearchThreshold = 500;

EventTransformer<E> _debounceDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.debounce(duration), mapper);
  };
}

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc({
    required ProductRepository productRepository,
  })  : _productRepository = productRepository,
        super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts,
        transformer: _debounceDroppable(_searchDebounce));
    on<SelectCategory>(_onSelectCategory);
    on<ScanBarcode>(_onScanBarcode);
    on<BarcodeDetected>(_onBarcodeDetected);
    on<AddProduct>(_onAddProduct);
    on<UpdateProduct>(_onUpdateProduct);
    on<DeleteProduct>(_onDeleteProduct);
    on<ToggleProductActive>(_onToggleProductActive);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  final ProductRepository _productRepository;
  StreamSubscription<dynamic>? _productsSubscription;
  StreamSubscription<dynamic>? _categoriesSubscription;

  /// Cached full product list from stream for in-memory search.
  List<Product> _allProducts = [];
  List<Category> _allCategories = [];

  // ── LoadProducts ─────────────────────────────────────────────────────────

  Future<void> _onLoadProducts(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductsLoading());

    await _productsSubscription?.cancel();
    await _categoriesSubscription?.cancel();

    // Subscribe to categories stream
    _categoriesSubscription =
        _productRepository.watchActiveCategories().listen((either) {
      either.fold(
        (_) {},
        (cats) {
          _allCategories = cats;
          _emitLoadedIfReady();
        },
      );
    });

    // Subscribe to products stream
    final stream = event.categoryId != null
        ? _productRepository.watchProductsByCategory(event.categoryId!)
        : _productRepository.watchAllActiveProducts();

    _productsSubscription = stream.listen((either) {
      either.fold(
        (failure) => add(const LoadProducts()),
        (products) {
          _allProducts = products;
          _emitLoadedIfReady(
            selectedCategoryId: event.categoryId,
          );
        },
      );
    });
  }

  void _emitLoadedIfReady({String? selectedCategoryId, String? searchQuery}) {
    final lowStock = _allProducts
        .where((p) => p.stock <= p.lowStockThreshold)
        .toList();

    final currentState = state;
    final effectiveCategoryId = selectedCategoryId ??
        (currentState is ProductsLoaded
            ? currentState.selectedCategoryId
            : null);
    final effectiveSearchQuery = searchQuery ??
        (currentState is ProductsLoaded ? currentState.searchQuery : null);

    // Apply in-memory search if active
    var displayProducts = _allProducts;
    if (effectiveSearchQuery != null && effectiveSearchQuery.isNotEmpty) {
      final query = effectiveSearchQuery.toLowerCase();
      displayProducts = _allProducts.where((p) {
        return p.nameKh.toLowerCase().contains(query) ||
            p.nameEn.toLowerCase().contains(query) ||
            (p.barcode?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // ignore: invalid_use_of_visible_for_testing_member
    emit(ProductsLoaded(
      products: displayProducts,
      categories: _allCategories,
      lowStockAlerts: lowStock,
      selectedCategoryId: effectiveCategoryId,
      searchQuery: effectiveSearchQuery,
      hasMore: _allProducts.length >= _pageSize,
    ));
  }

  // ── SearchProducts ───────────────────────────────────────────────────────

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    if (event.query.isEmpty) {
      _emitLoadedIfReady(searchQuery: '');
      return;
    }

    // For small datasets, search in-memory
    if (_allProducts.length < _inMemorySearchThreshold) {
      _emitLoadedIfReady(searchQuery: event.query);
      return;
    }

    // For large datasets, use DB search
    final result =
        await _productRepository.searchProducts(event.query).first;
    result.fold(
      (failure) => emit(ProductsError(failure: failure)),
      (products) {
        final lowStock = products
            .where((p) => p.stock <= p.lowStockThreshold)
            .toList();

        emit(ProductsLoaded(
          products: products,
          categories: _allCategories,
          lowStockAlerts: lowStock,
          searchQuery: event.query,
          selectedCategoryId: state is ProductsLoaded
              ? (state as ProductsLoaded).selectedCategoryId
              : null,
        ));
      },
    );
  }

  // ── SelectCategory ───────────────────────────────────────────────────────

  Future<void> _onSelectCategory(
      SelectCategory event, Emitter<ProductState> emit) async {
    add(LoadProducts(categoryId: event.categoryId));
  }

  // ── Barcode ──────────────────────────────────────────────────────────────

  void _onScanBarcode(ScanBarcode event, Emitter<ProductState> emit) {
    emit(BarcodeScanning());
  }

  Future<void> _onBarcodeDetected(
      BarcodeDetected event, Emitter<ProductState> emit) async {
    final result =
        await _productRepository.getProductByBarcode(event.barcode);
    result.fold(
      (failure) => emit(BarcodeNotFound(barcode: event.barcode)),
      (product) {
        if (product != null) {
          emit(ProductScanned(product: product));
        } else {
          emit(BarcodeNotFound(barcode: event.barcode));
        }
      },
    );
  }

  // ── CRUD ─────────────────────────────────────────────────────────────────

  Future<void> _onAddProduct(
      AddProduct event, Emitter<ProductState> emit) async {
    final result = await _productRepository.createProduct(event.input);
    await result.fold(
      (failure) async => emit(ProductsError(failure: failure)),
      (id) async {
        final productResult = await _productRepository.getProductById(id);
        productResult.fold(
          (failure) => emit(ProductsError(failure: failure)),
          (product) {
            if (product != null) {
              emit(ProductSaved(product: product));
            }
          },
        );
      },
    );
  }

  Future<void> _onUpdateProduct(
      UpdateProduct event, Emitter<ProductState> emit) async {
    final result =
        await _productRepository.updateProduct(event.id, event.input);
    await result.fold(
      (failure) async => emit(ProductsError(failure: failure)),
      (_) async {
        final productResult =
            await _productRepository.getProductById(event.id);
        productResult.fold(
          (failure) => emit(ProductsError(failure: failure)),
          (product) {
            if (product != null) {
              emit(ProductSaved(product: product));
            }
          },
        );
      },
    );
  }

  Future<void> _onDeleteProduct(
      DeleteProduct event, Emitter<ProductState> emit) async {
    final result = await _productRepository.deleteProduct(event.id);
    result.fold(
      (failure) => emit(ProductsError(failure: failure)),
      (_) {},
    );
  }

  Future<void> _onToggleProductActive(
      ToggleProductActive event, Emitter<ProductState> emit) async {
    final result = await _productRepository.toggleProductActive(event.id);
    result.fold(
      (failure) => emit(ProductsError(failure: failure)),
      (_) {},
    );
  }

  // ── Pagination ───────────────────────────────────────────────────────────

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (state is! ProductsLoaded) return;
    final currentState = state as ProductsLoaded;
    if (currentState.isLoadingMore || !currentState.hasMore) return;

    emit(currentState.copyWith(isLoadingMore: true));
    emit(currentState.copyWith(isLoadingMore: false, hasMore: false));
  }

  // ── Refresh ──────────────────────────────────────────────────────────────

  Future<void> _onRefreshProducts(
      RefreshProducts event, Emitter<ProductState> emit) async {
    final categoryId = state is ProductsLoaded
        ? (state as ProductsLoaded).selectedCategoryId
        : null;
    add(LoadProducts(categoryId: categoryId));
  }

  @override
  Future<void> close() {
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    return super.close();
  }
}
