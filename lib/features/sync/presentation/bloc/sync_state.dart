import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';

/// Base class for all sync-related states.
sealed class SyncState extends Equatable {
  /// Creates a [SyncState].
  const SyncState();

  @override
  List<Object?> get props => [];
}

/// Sync is idle with pending items.
final class SyncIdle extends SyncState {
  /// Creates a [SyncIdle] state.
  const SyncIdle({required this.pendingCount});

  /// Number of pending items in sync queue.
  final int pendingCount;

  @override
  List<Object?> get props => [pendingCount];
}

/// Sync is in progress.
final class SyncInProgress extends SyncState {
  /// Creates a [SyncInProgress] state.
  const SyncInProgress({
    required this.total,
    required this.processed,
    required this.failed,
  });

  /// Total items in current batch.
  final int total;

  /// Number of items processed.
  final int processed;

  /// Number of items failed.
  final int failed;

  @override
  List<Object?> get props => [total, processed, failed];
}

/// Sync completed successfully.
final class SyncCompleted extends SyncState {
  /// Creates a [SyncCompleted] state.
  const SyncCompleted({
    required this.synced,
    required this.failed,
    required this.at,
  });

  /// Number of items synced.
  final int synced;

  /// Number of items failed.
  final int failed;

  /// Completion timestamp.
  final DateTime at;

  @override
  List<Object?> get props => [synced, failed, at];
}

/// Sync error occurred.
final class SyncError extends SyncState {
  /// Creates a [SyncError] state.
  const SyncError({required this.failure});

  /// The failure that occurred.
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

/// Offline mode.
final class Offline extends SyncState {
  /// Creates an [Offline] state.
  const Offline({required this.pendingCount});

  /// Number of pending items while offline.
  final int pendingCount;

  @override
  List<Object?> get props => [pendingCount];
}
