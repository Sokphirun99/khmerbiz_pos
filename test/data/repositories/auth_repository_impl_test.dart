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
      expect(storedUser.pinHash, startsWith('sha256:'));
      expect(storedUser.pinHash.split(':').length, 3);

      final secondResult =
          await repository.login(username: 'admin', pin: '1234');

      secondResult.match(
        (failure) => fail(
          'Expected login with upgraded PIN hash to succeed, got ${failure.messageEn}',
        ),
        (_) {},
      );
    });

    test('upgrades legacy unsalted PIN hash storage after successful login',
        () async {
      // Legacy unsalted hash of '1234'
      await insertUser(pinHash: 'sha256:03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4');

      final result = await repository.login(username: 'admin', pin: '1234');

      result.match(
        (failure) =>
            fail('Expected login to succeed, got ${failure.messageEn}'),
        (user) {
          expect(user.id, isNotEmpty);
          expect(user.username, 'admin');
        },
      );

      final storedUser = await (database.select(database.users)
            ..where((tbl) => tbl.username.equals('admin')))
          .getSingle();

      expect(storedUser.pinHash, isNot('sha256:03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4'));
      expect(storedUser.pinHash, startsWith('sha256:'));
      expect(storedUser.pinHash.split(':').length, 3);

      final secondResult =
          await repository.login(username: 'admin', pin: '1234');

      secondResult.match(
        (failure) => fail(
          'Expected login with upgraded PIN hash to succeed, got ${failure.messageEn}',
        ),
        (_) {},
      );
    });

    test('accepts valid salted PIN hash', () async {
      // Create a user with a valid salted hash
      // PIN: 1234, Salt: c2FsdA==, Hash: hash('c2FsdA==1234') -> adcadd85c45df5f122418df018fdfac30b8c4b3e2b843eda251669897dd4a98c
      await insertUser(pinHash: 'sha256:c2FsdA==:adcadd85c45df5f122418df018fdfac30b8c4b3e2b843eda251669897dd4a98c');

      final result = await repository.login(username: 'admin', pin: '1234');

      result.match(
        (failure) =>
            fail('Expected login to succeed, got ${failure.messageEn}'),
        (user) {
          expect(user.id, isNotEmpty);
        },
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
