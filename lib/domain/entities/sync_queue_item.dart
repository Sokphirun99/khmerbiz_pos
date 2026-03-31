import 'package:equatable/equatable.dart';

/// Represents a pending synchronization task for offline-first operations.
class SyncQueueItem extends Equatable {
  /// Creates a [SyncQueueItem] record.
  const SyncQueueItem({
    required this.id,
    required this.operationType,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.createdAt,
    this.attemptCount = 0,
    this.lastAttemptAt,
    this.status = 'pending',
    this.errorMessage,
    this.priority = 5,
  });

  /// Unique identifier for the sync queue item (usually a UUID).
  final String id;

  /// The type of operation (e.g., "create", "update", "delete").
  final String operationType;

  /// The category of entity being synced (e.g., "product", "transaction").
  final String entityType;

  /// The local ID of the entity.
  final String entityId;

  /// JSON-encoded data representing the changes or entity state.
  final String payload;

  /// Number of times synchronization has been attempted.
  final int attemptCount;

  /// Timestamp of the last sync attempt.
  final DateTime? lastAttemptAt;

  /// Current sync status (e.g., "pending", "failed", "completed").
  final String status;

  /// Last error message if status is "failed".
  final String? errorMessage;

  /// Priority of the sync task (lower number = higher priority).
  final int priority;

  /// Timestamp when the item was added to the queue.
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        operationType,
        entityType,
        entityId,
        payload,
        attemptCount,
        lastAttemptAt,
        status,
        errorMessage,
        priority,
        createdAt,
      ];
}
