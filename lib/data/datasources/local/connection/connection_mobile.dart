import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

QueryExecutor openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'khmerbiz_pos.db'));

    // Get encryption key from secure storage
    const storage = FlutterSecureStorage();
    var dbKey = await storage.read(key: 'db_encryption_key');
    if (dbKey == null) {
      final secureRandom = Random.secure();
      final keyBytes = List<int>.generate(32, (_) => secureRandom.nextInt(256));
      dbKey = base64UrlEncode(keyBytes);
      await storage.write(key: 'db_encryption_key', value: dbKey);
    }

    return NativeDatabase(
      file,
      setup: (db) {
        db.execute("PRAGMA key = '$dbKey'");
      },
    );
  });
}
