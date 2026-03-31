import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/core/utils/app_logger.dart';
import 'package:khmerbiz_pos/domain/entities/sync_queue_item.dart';
import 'package:khmerbiz_pos/domain/repositories/sync_queue_repository.dart';
import 'package:khmerbiz_pos/features/sync/data/conflict_resolver.dart';
import 'package:khmerbiz_pos/features/sync/data/sync_api_service.dart';
import 'package:khmerbiz_pos/features/sync/presentation/bloc/sync_event.dart';
import 'package:khmerbiz_pos/features/sync/presentation/bloc/sync_state.dart';

/// BLoC managing offline-first synchronization.
///
/// Handles:
/// - Connectivity monitoring
/// - Background sync processing
/// - Conflict resolution
/// - Progress tracking
@LazySingleton()
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  /// Creates a [SyncBloc].
  SyncBloc({
    required SyncQueueRepository syncQueueRepository,
    required SyncApiService syncApiService,
    required ConflictResolver conflictResolver,
  })  : _syncQueueRepository = syncQueueRepository,
        _syncApiService = syncApiService,
        _conflictResolver = conflictResolver,
        super(const SyncIdle(pendingCount: 0)) {
    on<StartSync>(_onStartSync);
    on<ProcessNextBatch>(_onProcessNextBatch);
    on<SyncItemSuccess>(_onSyncItemSuccess);
    on<SyncItemFailed>(_onSyncItemFailed);
    on<ConnectivityChanged>(_onConnectivityChanged);
    on<ForceSync>(_onForceSync);
    on<FetchRemoteUpdates>(_onFetchRemoteUpdates);
    on<CleanupCompleted>(_onCleanupCompleted);
    on<RetryFailed>(_onRetryFailed);

    _initConnectivity();
    _loadPendingCount();
  }

  final SyncQueueRepository _syncQueueRepository;
  final SyncApiService _syncApiService;
  final ConflictResolver _conflictResolver;

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  ConnectivityStatus _currentConnectivity = ConnectivityStatus.unknown;

  int _totalInBatch = 0;
  int _processedInBatch = 0;
  int _failedInBatch = 0;
  DateTime? _lastSyncTime;

  // Debounce timer for connectivity changes
  Timer? _connectivityDebounce;

  // ── Initialization ────────────────────────────────────────────────────────

  void _initConnectivity() {
    // Check initial connectivity
    _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final hasConnection = results.any(
          (r) => r != ConnectivityResult.none,
        );

        // Debounce connectivity changes (wait 2s for stabilization)
        _connectivityDebounce?.cancel();
        _connectivityDebounce = Timer(const Duration(seconds: 2), () {
          final newStatus = hasConnection
              ? ConnectivityStatus.online
              : ConnectivityStatus.offline;

          if (newStatus != _currentConnectivity) {
            _currentConnectivity = newStatus;
            add(ConnectivityChanged(status: newStatus));
          }
        });
      },
    );
  }

  Future<void> _checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasConnection = results.any(
        (r) => r != ConnectivityResult.none,
      );
      _currentConnectivity = hasConnection
          ? ConnectivityStatus.online
          : ConnectivityStatus.offline;
    } catch (e) {
      _currentConnectivity = ConnectivityStatus.offline;
    }
  }

  void _loadPendingCount() {
    _syncQueueRepository.watchPendingCount().listen((result) {
      result.fold(
        (failure) => null,
        (count) {
          if (state is! SyncInProgress) {
            if (_currentConnectivity == ConnectivityStatus.offline) {
              emit(Offline(pendingCount: count));
            } else {
              emit(SyncIdle(pendingCount: count));
            }
          }
        },
      );
    });
  }

  // ── Connectivity Changes ─────────────────────────────────────────────────

  Future<void> _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<SyncState> emit,
  ) async {
    if (event.status == ConnectivityStatus.online) {
      // Wait 2 seconds for connection to stabilize, then start sync
      await Future.delayed(const Duration(seconds: 2));
      add(const StartSync());
    } else {
      // Go offline
      final result = await _syncQueueRepository.watchPendingCount().first;
      final count = result.fold((_) => 0, (c) => c);
      emit(Offline(pendingCount: count));
    }
  }

  // ── Start Sync ───────────────────────────────────────────────────────────

  Future<void> _onStartSync(
    StartSync event,
    Emitter<SyncState> emit,
  ) async {
    if (_currentConnectivity != ConnectivityStatus.online) {
      return; // Don't sync when offline
    }

    // Get first batch
    add(const ProcessNextBatch());
  }

  // ── Process Batch ────────────────────────────────────────────────────────

  Future<void> _onProcessNextBatch(
    ProcessNextBatch event,
    Emitter<SyncState> emit,
  ) async {
    // Get pending items
    final result = await _syncQueueRepository.getPendingItems();

    final items = result.fold(
      (failure) => <SyncQueueItem>[],
      (items) => items,
    );

    if (items.isEmpty) {
      // No more items - sync complete
      _lastSyncTime = DateTime.now();
      emit(SyncCompleted(
        synced: _processedInBatch,
        failed: _failedInBatch,
        at: _lastSyncTime!,
      ),);

      // Cleanup old completed items
      add(const CleanupCompleted());
      return;
    }

    // Start processing batch
    _totalInBatch = items.length;
    _processedInBatch = 0;
    _failedInBatch = 0;

    emit(SyncInProgress(
      total: _totalInBatch,
      processed: 0,
      failed: 0,
    ),);

    // Process each item
    for (final item in items) {
      await _processItem(item);
    }

    // Process next batch after this one completes
    add(const ProcessNextBatch());
  }

  // ── Process Single Item ──────────────────────────────────────────────────

  Future<void> _processItem(SyncQueueItem item) async {
    // Mark as processing
    await _syncQueueRepository.markProcessing(item.id);

    try {
      // Deserialize payload
      final payload = _parsePayload(item.payload);

      // Route to correct API endpoint based on entity type
      Either<Failure, void> syncResult;

      switch (item.entityType.toLowerCase()) {
        case 'transaction':
          syncResult = await _syncTransaction(item, payload);
        case 'inventory_log':
          syncResult = await _syncInventoryLog(item, payload);
        case 'product':
          syncResult = await _syncProduct(item, payload);
        case 'customer':
          syncResult = await _syncCustomer(item, payload);
        default:
          syncResult = left(SystemFailure(
            messageEn: 'Unknown entity type: ${item.entityType}',
            messageKm: 'ប្រភេទអង្គភាពមិនស្គាល់៖ ${item.entityType}',
          ),);
      }

      syncResult.fold(
        (failure) {
          // Handle failure
          if (_isConflictError(failure)) {
            // Apply conflict resolution
            _handleConflict(item, payload, failure);
          } else if (_isClientError(failure)) {
            // 4xx error - don't retry, mark as failed
            _syncQueueRepository.markFailed(item.id, failure.messageEn);
            add(SyncItemFailed(entityId: item.entityId, error: failure.messageEn));
            _failedInBatch++;
          } else {
            // 5xx or timeout - increment attempt, retry later
            _syncQueueRepository.incrementAttempt(item.id);
            // Don't count as failed yet - will retry
          }
        },
        (_) {
          // Success
          _syncQueueRepository.markCompleted(item.id);
          add(SyncItemSuccess(entityId: item.entityId));
          _processedInBatch++;
        },
      );
    } catch (e) {
      // Unexpected error
      _syncQueueRepository.incrementAttempt(item.id);
      _failedInBatch++;
    }

    // Update progress
    emit(SyncInProgress(
      total: _totalInBatch,
      processed: _processedInBatch + _failedInBatch,
      failed: _failedInBatch,
    ),);
  }

  Map<String, dynamic> _parsePayload(String payload) {
    try {
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (e) {
      AppLogger.w('Failed to parse sync payload: $e', tag: 'Sync');
      return {};
    }
  }

  // ── Sync Methods ─────────────────────────────────────────────────────────

  Future<Either<Failure, void>> _syncTransaction(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    // Transactions are append-only - client always wins
    // POST to /api/v1/transactions
    return _syncApiService.syncTransactions([payload]);
  }

  Future<Either<Failure, void>> _syncInventoryLog(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    // Inventory logs are append-only - client always wins
    // POST to /api/v1/inventory-logs
    return _syncApiService.syncInventoryLogs([payload]);
  }

  Future<Either<Failure, void>> _syncProduct(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    // Products can have conflicts - need to check timestamps
    // PUT to /api/v1/products/{id}
    return _syncApiService.updateProduct(item.entityId, payload);
  }

  Future<Either<Failure, void>> _syncCustomer(
    SyncQueueItem item,
    Map<String, dynamic> payload,
  ) async {
    // Customers can have conflicts
    return _syncApiService.updateCustomer(item.entityId, payload);
  }

  // ── Conflict Resolution ──────────────────────────────────────────────────

  bool _isConflictError(Failure failure) {
    // Check for 409 Conflict status
    return failure is ServerFailure && failure.statusCode == 409;
  }

  bool _isClientError(Failure failure) {
    // 4xx errors (except 409) - don't retry
    return failure is ServerFailure &&
        failure.statusCode != null &&
        failure.statusCode! >= 400 &&
        failure.statusCode! < 500 &&
        failure.statusCode != 409;
  }

  void _handleConflict(
    SyncQueueItem item,
    Map<String, dynamic> payload,
    Failure failure,
  ) {
    // Apply conflict resolution strategy based on entity type
    switch (item.entityType.toLowerCase()) {
      case 'transaction':
        // Client always wins for transactions - retry sync
        _syncTransaction(item, payload).then((result) {
          result.fold(
            (_) {
              _syncQueueRepository.markFailed(item.id, 'Conflict resolution failed');
              _failedInBatch++;
            },
            (_) {
              _syncQueueRepository.markCompleted(item.id);
              _processedInBatch++;
            },
          );
        });

      case 'product':
        // Compare timestamps and resolve
        _conflictResolver.resolveProductConflict(
          entityId: item.entityId,
          localData: payload,
          localUpdatedAt: item.createdAt, // Use createdAt as proxy for updatedAt
          onError: (error) {
            _syncQueueRepository.markFailed(item.id, error);
            _failedInBatch++;
          },
          onSuccess: () {
            // For products, server wins - mark as completed
            _syncQueueRepository.markCompleted(item.id);
            _processedInBatch++;
            // Log conflict for admin review
            _conflictResolver.logSyncConflict(
              entityId: item.entityId,
              entityType: item.entityType,
              resolution: 'server_wins',
              details: failure.messageEn,
            );
          },
        );

      case 'inventory_log':
        // Client always wins - retry sync
        _syncInventoryLog(item, payload).then((result) {
          result.fold(
            (_) {
              _syncQueueRepository.markFailed(item.id, 'Conflict resolution failed');
              _failedInBatch++;
            },
            (_) {
              _syncQueueRepository.markCompleted(item.id);
              _processedInBatch++;
            },
          );
        });

      default:
        // Server wins by default
        _syncQueueRepository.markFailed(
          item.id,
          'Conflict resolved: server version kept',
        );
        _failedInBatch++;
    }
  }

  // ── Item Success/Failure ─────────────────────────────────────────────────

  void _onSyncItemSuccess(
    SyncItemSuccess event,
    Emitter<SyncState> emit,
  ) {
    // Item synced successfully - state updated in _processItem
  }

  void _onSyncItemFailed(
    SyncItemFailed event,
    Emitter<SyncState> emit,
  ) {
    // Item failed - state updated in _processItem
  }

  // ── Force Sync ───────────────────────────────────────────────────────────

  Future<void> _onForceSync(
    ForceSync event,
    Emitter<SyncState> emit,
  ) async {
    if (_currentConnectivity != ConnectivityStatus.online) {
      emit(const SyncError(
        failure: NetworkFailure(
          messageEn: 'Cannot sync while offline',
          messageKm: 'មិនអាចធ្វើសមកាលកម្មនៅពេលក្រៅបណ្តាញ',
        ),
      ),);
      return;
    }

    // Reset batch counters and start fresh
    _processedInBatch = 0;
    _failedInBatch = 0;
    add(const StartSync());
  }

  // ── Fetch Remote Updates ─────────────────────────────────────────────────

  Future<void> _onFetchRemoteUpdates(
    FetchRemoteUpdates event,
    Emitter<SyncState> emit,
  ) async {
    if (_currentConnectivity != ConnectivityStatus.online) {
      return;
    }

    // Fetch product updates from server
    final result = await _syncApiService.getProductUpdates(
      since: _lastSyncTime?.toIso8601String() ?? '2024-01-01T00:00:00Z',
      deviceId: 'local-device',
    );

    result.fold(
      (failure) {
        // Log but don't fail - this is background sync
      },
      (updates) async {
        // Apply remote updates to local DB
        await _conflictResolver.applyRemoteUpdates(updates, _lastSyncTime);
      },
    );
  }

  // ── Cleanup ──────────────────────────────────────────────────────────────

  Future<void> _onCleanupCompleted(
    CleanupCompleted event,
    Emitter<SyncState> emit,
  ) async {
    await _syncQueueRepository.cleanupCompleted();
  }

  // ── Retry Failed ─────────────────────────────────────────────────────────

  Future<void> _onRetryFailed(
    RetryFailed event,
    Emitter<SyncState> emit,
  ) async {
    if (_currentConnectivity != ConnectivityStatus.online) {
      return;
    }

    // Reset failed items to pending status
    // This would need a new repository method
    add(const StartSync());
  }

  // ── Dispose ──────────────────────────────────────────────────────────────

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _connectivityDebounce?.cancel();
    return super.close();
  }

  // ── Getters ──────────────────────────────────────────────────────────────

  /// Get current connectivity status.
  ConnectivityStatus get connectivityStatus => _currentConnectivity;

  /// Get last sync time.
  DateTime? get lastSyncTime => _lastSyncTime;
}
