import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';

part 'sync_queue_dao.g.dart';

/// Data Access Object for SyncQueue table.
///
/// Manages the local queue of items waiting to be synchronized with the server.
@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase>
    with _$SyncQueueDaoMixin {
  /// Creates a new [SyncQueueDao] with the given [db].
  SyncQueueDao(super.db);

  /// Returns a stream of the number of items currently pending or failed.
  Stream<int> watchPendingCount() {
    final countExp = syncQueue.id.count();
    final query = selectOnly(syncQueue)
      ..addColumns([countExp])
      ..where(syncQueue.status.equals('pending') |
          syncQueue.status.equals('failed'),);
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  /// Retrieves a list of pending or failed items, limited by [limit].
  ///
  /// Items are ordered by [priority] then [createdAt].
  Future<List<SyncQueueModel>> getPendingItems({int limit = 10}) {
    return (select(syncQueue)
          ..where((tbl) =>
              tbl.status.equals('pending') | tbl.status.equals('failed'),)
          ..orderBy([
            (t) => OrderingTerm.asc(t.priority),
            (t) => OrderingTerm.asc(t.createdAt),
          ])
          ..limit(limit))
        .get();
  }

  /// Marks a sync item as currently being processed.
  Future<void> markProcessing(String id) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        status: const Value('processing'),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Marks a sync item as successfully completed.
  Future<void> markCompleted(String id) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(const SyncQueueCompanion(status: Value('completed')));
  }

  /// Marks a sync item as failed with an [errorMessage].
  Future<void> markFailed(String id, String errorMessage) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id))).write(
      SyncQueueCompanion(
        status: const Value('failed'),
        errorMessage: Value(errorMessage),
      ),
    );
  }

  /// Increments the attempt count for a sync item and updates [lastAttemptAt].
  Future<void> incrementAttempt(String id) async {
    await customUpdate(
      'UPDATE sync_queue SET attemptCount = attemptCount + 1, lastAttemptAt = ? WHERE id = ?',
      variables: [
        Variable.withDateTime(DateTime.now()),
        Variable.withString(id),
      ],
      updates: {syncQueue},
    );
  }

  /// Permanently deletes sync items that have been completed for more than 7 days.
  Future<void> cleanupCompleted() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    await (delete(syncQueue)
          ..where((tbl) =>
              tbl.status.equals('completed') &
              tbl.createdAt.isSmallerThanValue(cutoff),))
        .go();
  }

  /// Inserts a new item into the sync queue.
  Future<void> insertItem(SyncQueueCompanion item) async {
    await into(syncQueue).insert(item);
  }
}
