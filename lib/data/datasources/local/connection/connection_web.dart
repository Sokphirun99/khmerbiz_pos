import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Opens a connection to the Drift database on web.
QueryExecutor openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    final result = await WasmDatabase.open(
      databaseName: 'khmerbiz_pos',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.js'),
    );

    if (result.missingFeatures.isNotEmpty) {
      // ignore: avoid_print
      print(
          'Using fallback database implementation because of missing browser features: ${result.missingFeatures}',);
    }

    return result.resolvedExecutor;
  }),);
}
