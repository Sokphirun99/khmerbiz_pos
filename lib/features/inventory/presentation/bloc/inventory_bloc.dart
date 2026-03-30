import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/inventory_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc({
    required InventoryRepository inventoryRepository,
    required ProductRepository productRepository,
    required AuthRepository authRepository,
  })  : _inventoryRepository = inventoryRepository,
        _productRepository = productRepository,
        _authRepository = authRepository,
        super(InventoryInitial()) {
    on<LoadInventoryLog>(_onLoadInventoryLog);
    on<AdjustStock>(_onAdjustStock);
    on<LoadLowStockReport>(_onLoadLowStockReport);
    on<BulkImportStock>(_onBulkImportStock);
  }

  final InventoryRepository _inventoryRepository;
  final ProductRepository _productRepository;
  final AuthRepository _authRepository;

  // ── LoadInventoryLog ─────────────────────────────────────────────────────

  Future<void> _onLoadInventoryLog(
      LoadInventoryLog event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());

    final logsResult = await _inventoryRepository.getInventoryLogs(
      productId: event.productId,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    final lowStockResult = await _inventoryRepository.getLowStockProducts();

    logsResult.fold(
      (failure) => emit(InventoryError(failure: failure)),
      (logs) {
        lowStockResult.fold(
          (failure) => emit(InventoryError(failure: failure)),
          (lowStockItems) {
            emit(InventoryLoaded(
              logs: logs,
              lowStockItems: lowStockItems,
            ));
          },
        );
      },
    );
  }

  // ── AdjustStock ──────────────────────────────────────────────────────────

  Future<void> _onAdjustStock(
      AdjustStock event, Emitter<InventoryState> emit) async {
    // Get current product for previousStock
    final productResult =
        await _productRepository.getProductById(event.productId);

    final product = productResult.fold(
      (failure) {
        emit(InventoryError(failure: failure));
        return null;
      },
      (p) => p,
    );

    if (product == null) return;

    final previousStock = product.stock;

    // Get current staff ID
    final userResult = await _authRepository.getCurrentUser();
    final staffId = userResult.fold((l) => 'unknown', (u) => u.id);

    final result = await _inventoryRepository.adjustStock(
      productId: event.productId,
      quantity: event.quantity,
      reason: event.reason.value,
      staffId: staffId,
      notes: event.notes,
    );

    await result.fold(
      (failure) async => emit(InventoryError(failure: failure)),
      (_) async {
        // Fetch updated product
        final updatedResult =
            await _productRepository.getProductById(event.productId);
        updatedResult.fold(
          (failure) => emit(InventoryError(failure: failure)),
          (updatedProduct) {
            if (updatedProduct != null) {
              emit(StockAdjusted(
                updatedProduct: updatedProduct,
                previousStock: previousStock,
              ));
            }
          },
        );
      },
    );
  }

  // ── LoadLowStockReport ───────────────────────────────────────────────────

  Future<void> _onLoadLowStockReport(
      LoadLowStockReport event, Emitter<InventoryState> emit) async {
    emit(InventoryLoading());

    final result = await _inventoryRepository.getLowStockProducts();

    result.fold(
      (failure) => emit(InventoryError(failure: failure)),
      (lowStockItems) {
        final currentLogs =
            state is InventoryLoaded
                ? (state as InventoryLoaded).logs
                : <dynamic>[];
        emit(InventoryLoaded(
          logs: List.from(currentLogs),
          lowStockItems: lowStockItems,
        ));
      },
    );
  }

  // ── BulkImportStock ──────────────────────────────────────────────────────

  Future<void> _onBulkImportStock(
      BulkImportStock event, Emitter<InventoryState> emit) async {
    final userResult = await _authRepository.getCurrentUser();
    final staffId = userResult.fold((l) => 'unknown', (u) => u.id);

    for (final item in event.items) {
      await _inventoryRepository.adjustStock(
        productId: item.productId,
        quantity: item.quantity,
        reason: item.reason.value,
        staffId: staffId,
        notes: item.notes,
      );
    }

    // Reload after bulk import
    add(const LoadInventoryLog());
  }
}
