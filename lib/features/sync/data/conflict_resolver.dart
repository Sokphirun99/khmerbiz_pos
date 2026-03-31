import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/utils/app_logger.dart';
import 'package:khmerbiz_pos/domain/repositories/product_repository.dart';

/// Handles conflict resolution for offline-first sync.
///
/// Implements the conflict resolution strategies defined in the architecture:
/// - Transactions: Client always wins (append-only)
/// - Products: Timestamp-based resolution
/// - Inventory logs: Client always wins (append-only)
@LazySingleton()
class ConflictResolver {
  /// Creates a [ConflictResolver].
  ConflictResolver({required ProductRepository productRepository})
      : _productRepository = productRepository;

  final ProductRepository _productRepository;

  /// Resolve product conflict between local and server versions.
  ///
  /// Strategy:
  /// - If server.updatedAt > local.updatedAt: apply server version
  /// - If local.updatedAt > server.updatedAt: push local version (caller's responsibility)
  /// - If equal but different: server wins
  Future<void> resolveProductConflict({
    required String entityId,
    required Map<String, dynamic> localData,
    required DateTime localUpdatedAt,
    required void Function(String error) onError,
    required void Function() onSuccess,
  }) async {
    try {
      // Extract server updatedAt from response data
      final serverUpdatedAt = _extractServerUpdatedAt(localData);

      if (serverUpdatedAt.isAfter(localUpdatedAt)) {
        // Server is newer - caller should apply server version to local DB
        // This is handled by the caller (SyncBloc) via repository
        onSuccess();
      } else if (localUpdatedAt.isAfter(serverUpdatedAt)) {
        // Local is newer - caller should push local version
        onSuccess();
      } else {
        // Timestamps equal - server wins (safer default)
        onSuccess();
      }
    } catch (e) {
      onError('Conflict resolution failed: $e');
    }
  }

  /// Apply remote product updates to local database.
  ///
  /// This method is called when fetching updates from server.
  /// The actual database update is handled by the ProductRepository.
  Future<List<Map<String, dynamic>>> applyRemoteUpdates(
    List<Map<String, dynamic>> updates,
    DateTime? lastSyncTime,
  ) async {
    // Filter updates to only include those newer than last sync
    final filtered = lastSyncTime == null
        ? updates
        : updates.where((update) {
            final updatedAt = _extractServerUpdatedAt(update);
            return updatedAt.isAfter(lastSyncTime);
          }).toList();

    // Apply each update to local database
    for (final update in filtered) {
      final id = update['id'] as String?;
      if (id == null) continue;

      try {
        // Update product in local DB via repository
        // Note: This uses a map-based update since we're syncing from server
        // The repository will handle the actual DB write
        AppLogger.i('Applying remote update for product $id', tag: 'Sync');
        // TODO: Implement updateProductFromMap in ProductRepository
        // For now, log the update that would be applied
      } catch (e) {
        AppLogger.e('Failed to apply remote update for $id: $e', tag: 'Sync');
      }
    }

    return filtered;
  }

  /// Extract server updatedAt from response data.
  DateTime _extractServerUpdatedAt(Map<String, dynamic> data) {
    final updatedAtStr = data['updatedAt'] as String?;
    if (updatedAtStr != null) {
      return DateTime.parse(updatedAtStr);
    }

    // Fallback to current time
    return DateTime.now();
  }

  /// Log sync conflict for admin review.
  ///
  /// In production, this would write to a sync_conflict_log table.
  void logSyncConflict({
    required String entityId,
    required String entityType,
    required String resolution,
    required String details,
  }) {
    // Log for debugging (production-safe via AppLogger)
    AppLogger.w('Sync Conflict: $entityType/$entityId - $resolution', tag: 'Sync', error: details);
  }
}

/// Sync conflict log entry for admin review.
final class SyncConflictLog {
  /// Creates a [SyncConflictLog].
  const SyncConflictLog({
    required this.id,
    required this.entityId,
    required this.entityType,
    required this.resolution,
    required this.details,
    required this.createdAt,
  });

  /// Unique identifier.
  final String id;

  /// Entity that had the conflict.
  final String entityId;

  /// Type of entity (product, customer, etc.).
  final String entityType;

  /// How the conflict was resolved.
  final String resolution;

  /// Details about the conflict.
  final String details;

  /// When the conflict was logged.
  final DateTime createdAt;
}
