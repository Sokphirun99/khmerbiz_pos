import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> with _$SyncQueueDaoMixin {
  SyncQueueDao(super.db);

  Stream<int> watchPendingCount() {
    final countExp = syncQueue.id.count();
    final query = selectOnly(syncQueue)
      ..addColumns([countExp])
      ..where(syncQueue.status.equals('pending') | syncQueue.status.equals('failed'));
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  Future<List<SyncQueueModel>> getPendingItems({int limit = 10}) {
    return (select(syncQueue)
          ..where((tbl) => tbl.status.equals('pending') | tbl.status.equals('failed'))
          ..orderBy([(t) => OrderingTerm.asc(t.priority), (t) => OrderingTerm.asc(t.createdAt)])
          ..limit(limit))
        .get();
  }

  Future<void> markProcessing(String id) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(SyncQueueCompanion(
            status: const Value('processing'),
            lastAttemptAt: Value(DateTime.now()),),);
  }

  Future<void> markCompleted(String id) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(const SyncQueueCompanion(status: Value('completed')));
  }

  Future<void> markFailed(String id, String errorMessage) async {
    await (update(syncQueue)..where((tbl) => tbl.id.equals(id)))
        .write(SyncQueueCompanion(
            status: const Value('failed'), errorMessage: Value(errorMessage),),);
  }

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

  Future<void> cleanupCompleted() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    await (delete(syncQueue)
          ..where((tbl) => tbl.status.equals('completed') & tbl.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }

  Future<void> insertItem(SyncQueueCompanion item) async {
    await into(syncQueue).insert(item);
  }
}
