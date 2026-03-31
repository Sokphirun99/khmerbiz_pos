import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/sync_queue_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/sync_queue_item.dart';
import 'package:khmerbiz_pos/domain/repositories/sync_queue_repository.dart';

/// Implementation of [SyncQueueRepository] using [SyncQueueDao].
///
/// Manages the queue of outbound synchronization tasks.
@LazySingleton(as: SyncQueueRepository)
class SyncQueueRepositoryImpl implements SyncQueueRepository {
  /// Creates a new [SyncQueueRepositoryImpl] with the given [SyncQueueDao].
  SyncQueueRepositoryImpl(this._dao);
  final SyncQueueDao _dao;

  SyncQueueItem _mapToDomain(SyncQueueModel model) {
    return SyncQueueItem(
      id: model.id,
      operationType: model.operationType,
      entityType: model.entityType,
      entityId: model.entityId,
      payload: model.payload,
      attemptCount: model.attemptCount,
      lastAttemptAt: model.lastAttemptAt,
      status: model.status,
      errorMessage: model.errorMessage,
      priority: model.priority,
      createdAt: model.createdAt,
    );
  }

  @override
  Stream<Either<Failure, int>> watchPendingCount() {
    return _dao.watchPendingCount().map((count) {
      return right<Failure, int>(count);
    }).handleError((Object err) =>
        left<Failure, int>(CacheFailure.defaultError(details: err.toString())),);
  }

  @override
  Future<Either<Failure, List<SyncQueueItem>>> getPendingItems(
      {int limit = 10,}) async {
    try {
      final items = await _dao.getPendingItems(limit: limit);
      return right(items.map(_mapToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markProcessing(String id) async {
    try {
      await _dao.markProcessing(id);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markCompleted(String id) async {
    try {
      await _dao.markCompleted(id);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markFailed(
      String id, String errorMessage,) async {
    try {
      await _dao.markFailed(id, errorMessage);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> incrementAttempt(String id) async {
    try {
      await _dao.incrementAttempt(id);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cleanupCompleted() async {
    try {
      await _dao.cleanupCompleted();
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }
}
