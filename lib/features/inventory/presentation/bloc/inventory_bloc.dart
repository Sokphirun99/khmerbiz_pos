import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/inventory_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_state.dart';

/// Bloc responsible for managing inventory-related state and actions.
///
/// Handles stock adjustments, loading inventory logs, and low stock reporting.
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  /// Creates an [InventoryBloc].
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

  Future<void> _onLoadInventoryLog(
      LoadInventoryLog event, Emitter<InventoryState> emit,) async {
    emit(InventoryLoading());
    final result = await _inventoryRepository.getInventoryLogs(
      productId: event.productId,
      startDate: event.startDate,
      endDate: event.endDate,
    );

    result.fold(
      (failure) => emit(InventoryError(failure: failure)),
      (logs) async {
        final lowStockResult = await _inventoryRepository.getLowStockProducts();
        lowStockResult.fold(
          (failure) => emit(InventoryError(failure: failure)),
          (lowStockItems) => emit(InventoryLoaded(
            logs: logs,
            lowStockItems: lowStockItems,
          ),),
        );
      },
    );
  }

  Future<void> _onAdjustStock(
      AdjustStock event, Emitter<InventoryState> emit,) async {
    final currentState = state;
    emit(InventoryLoading());

    // Get current product state first to know previous stock
    final productResult = await _productRepository.getProductById(event.productId);
    
    await productResult.fold(
      (failure) async => emit(InventoryError(failure: failure)),
      (product) async {
        if (product == null) {
          emit(InventoryError(failure: ServerFailure.defaultError(details: 'Product not found')));
          return;
        }

        var staffId = event.staffId;
        if (staffId == null) {
          final userResult = await _authRepository.getCurrentUser();
          staffId = userResult.fold(
            (failure) => 'unknown',
            (user) => user.id,
          );
        }

        final result = await _inventoryRepository.adjustStock(
          productId: event.productId,
          quantity: event.quantity,
          reason: event.reason.value,
          staffId: staffId!,
          notes: event.notes,
        );

        await result.fold(
          (failure) async => emit(InventoryError(failure: failure)),
          (_) async {
            final updatedProductResult = await _productRepository.getProductById(event.productId);
            updatedProductResult.fold(
              (failure) => emit(InventoryError(failure: failure)),
              (updatedProduct) {
                if (updatedProduct != null) {
                  emit(StockAdjusted(
                    updatedProduct: updatedProduct,
                    previousStock: product.stock,
                  ),);
                  // Reload logs if we were previously in Loaded state
                  if (currentState is InventoryLoaded) {
                    add(LoadInventoryLog(productId: currentState.selectedProduct?.id));
                  }
                }
              },
            );
          },
        );
      },
    );
  }

  Future<void> _onLoadLowStockReport(
      LoadLowStockReport event, Emitter<InventoryState> emit,) async {
    emit(InventoryLoading());
    final result = await _inventoryRepository.getLowStockProducts();
    result.fold(
      (failure) => emit(InventoryError(failure: failure)),
      (items) => emit(InventoryLoaded(
        logs: const [],
        lowStockItems: items,
      ),),
    );
  }

  Future<void> _onBulkImportStock(
      BulkImportStock event, Emitter<InventoryState> emit,) async {
    // Implementation for bulk import
    // This would typically involve looping through items and calling adjustStock
    // or a dedicated bulk repository method.
    emit(InventoryLoading());
    // Simplified for now
    emit(InventoryError(failure: ServerFailure.defaultError(details: 'Bulk import not fully implemented')));
  }
}
