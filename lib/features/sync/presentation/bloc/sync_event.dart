import 'package:equatable/equatable.dart';

/// Connectivity status for offline-first sync.
enum ConnectivityStatus {
  /// Device is online and connected
  online,

  /// Device is offline
  offline,

  /// Connectivity unknown (initial state)
  unknown,
}

/// Base class for all sync-related events.
sealed class SyncEvent extends Equatable {
  /// Creates a [SyncEvent].
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

/// Start synchronization process.
final class StartSync extends SyncEvent {
  /// Creates a [StartSync] event.
  const StartSync();
}

/// Process next batch of sync items.
final class ProcessNextBatch extends SyncEvent {
  /// Creates a [ProcessNextBatch] event.
  const ProcessNextBatch();
}

/// Sync item succeeded.
final class SyncItemSuccess extends SyncEvent {
  /// Creates a [SyncItemSuccess] event.
  const SyncItemSuccess({required this.entityId});

  /// The entity ID that was synced.
  final String entityId;

  @override
  List<Object?> get props => [entityId];
}

/// Sync item failed.
final class SyncItemFailed extends SyncEvent {
  /// Creates a [SyncItemFailed] event.
  const SyncItemFailed({required this.entityId, required this.error});

  /// The entity ID that failed.
  final String entityId;

  /// The error message.
  final String error;

  @override
  List<Object?> get props => [entityId, error];
}

/// Connectivity changed.
final class ConnectivityChanged extends SyncEvent {
  /// Creates a [ConnectivityChanged] event.
  const ConnectivityChanged({required this.status});

  /// The new connectivity status.
  final ConnectivityStatus status;

  @override
  List<Object?> get props => [status];
}

/// Force sync now (user-initiated).
final class ForceSync extends SyncEvent {
  /// Creates a [ForceSync] event.
  const ForceSync();
}

/// Fetch remote updates from server.
final class FetchRemoteUpdates extends SyncEvent {
  /// Creates a [FetchRemoteUpdates] event.
  const FetchRemoteUpdates();
}

/// Cleanup completed sync items.
final class CleanupCompleted extends SyncEvent {
  /// Creates a [CleanupCompleted] event.
  const CleanupCompleted();
}

/// Retry failed sync items.
final class RetryFailed extends SyncEvent {
  /// Creates a [RetryFailed] event.
  const RetryFailed();
}
