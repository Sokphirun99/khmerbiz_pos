import 'package:drift/drift.dart';

/// Opens a connection to the Drift database.
QueryExecutor openConnection() {
  throw UnsupportedError('Cannot open a database without dart:html or dart:io');
}
