import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/sync_queue_item.dart';

/// Repository interface for offline-first synchronization management.
abstract class SyncQueueRepository {
  /// Watches the number of pending items in the sync queue.
  Stream<Either<Failure, int>> watchPendingCount();

  /// Retrieves a batch of pending items from the queue.
  Future<Either<Failure, List<SyncQueueItem>>> getPendingItems({
    int limit = 10,
  });

  /// Marks a queue item as currently being processed.
  Future<Either<Failure, void>> markProcessing(String id);

  /// Marks a queue item as successfully synchronized.
  Future<Either<Failure, void>> markCompleted(String id);

  /// Marks a queue item as failed with a specific [errorMessage].
  Future<Either<Failure, void>> markFailed(String id, String errorMessage);

  /// Increments the attempt count for a queue item.
  Future<Either<Failure, void>> incrementAttempt(String id);

  /// Deletes sync queue items that have already been processed.
  Future<Either<Failure, void>> cleanupCompleted();
}
