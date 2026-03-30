import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/data/repositories/auth_repository_impl.dart';

void main() {
  late AppDatabase database;
  late AuthRepositoryImpl repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = AuthRepositoryImpl(database);
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> insertUser({required String pinHash}) async {
    await database.into(database.users).insert(
          UsersCompanion.insert(
            username: 'admin',
            pinHash: pinHash,
            fullNameKh: 'រដ្ឋបាល',
            fullNameEn: 'Admin User',
            role: 'admin',
            createdAt: DateTime(2026, 1, 1),
          ),
        );
  }

  group('AuthRepositoryImpl.login', () {
    test('upgrades legacy plaintext PIN storage after successful login',
        () async {
      await insertUser(pinHash: '1234');

      final result = await repository.login(username: 'admin', pin: '1234');

      result.match(
        (failure) =>
            fail('Expected login to succeed, got ${failure.messageEn}'),
        (user) {
          expect(user.id, isNotEmpty);
          expect(user.username, 'admin');
          expect(user.fullNameEn, 'Admin User');
        },
      );

      final storedUser = await (database.select(database.users)
            ..where((tbl) => tbl.username.equals('admin')))
          .getSingle();

      expect(storedUser.pinHash, isNot('1234'));

      final secondResult =
          await repository.login(username: 'admin', pin: '1234');

      secondResult.match(
        (failure) => fail(
          'Expected login with upgraded PIN hash to succeed, got ${failure.messageEn}',
        ),
        (_) {},
      );
    });

    test('rejects invalid PINs', () async {
      await insertUser(pinHash: '1234');

      final result = await repository.login(username: 'admin', pin: '9999');

      result.match(
        (failure) => expect(failure, isA<ValidationFailure>()),
        (_) => fail('Expected login to fail for an invalid PIN'),
      );
    });
  });
}
