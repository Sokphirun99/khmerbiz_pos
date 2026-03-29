import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/sync_queue_item.dart';

abstract class SyncQueueRepository {
  Stream<Either<Failure, int>> watchPendingCount();
  Future<Either<Failure, List<SyncQueueItem>>> getPendingItems({int limit = 10});
  Future<Either<Failure, void>> markProcessing(String id);
  Future<Either<Failure, void>> markCompleted(String id);
  Future<Either<Failure, void>> markFailed(String id, String errorMessage);
  Future<Either<Failure, void>> incrementAttempt(String id);
  Future<Either<Failure, void>> cleanupCompleted();
}
