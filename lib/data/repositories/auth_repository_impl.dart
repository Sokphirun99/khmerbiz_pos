import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/user.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';

/// Implementation of [AuthRepository] using a local SQLite database.
///
/// Handles user login, logout, and PIN verification with automated security upgrades.
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  /// Creates a new [AuthRepositoryImpl] with the given [AppDatabase].
  AuthRepositoryImpl(this._db);
  final AppDatabase _db;

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String pin,
  }) async {
    try {
      final userModel = await (_db.select(_db.users)
            ..where((tbl) => tbl.username.equals(username)))
          .getSingleOrNull();

      if (userModel == null) {
        return left(ServerFailure.notFound());
      }

      final isValidPin = await _verifyPin(userModel, pin);
      if (!isValidPin) {
        return left(
          ValidationFailure.custom(
            messageEn: 'Invalid PIN',
            messageKm: 'លេខសម្ងាត់មិនត្រឹមត្រូវ',
          ),
        );
      }

      return right(_mapUser(userModel));
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return right(null);
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    // Demo implementation
    return left(ServerFailure.notFound());
  }

  Future<bool> _verifyPin(UserModel userModel, String pin) async {
    final storedHash = userModel.pinHash;
    if (storedHash.startsWith('sha256:')) {
      final parts = storedHash.split(':');
      if (parts.length == 3) {
        // Salted hash
        final salt = parts[1];
        if (storedHash == _hashPinWithSalt(pin, salt)) {
          return true;
        }
      } else if (parts.length == 2) {
        // Unsalted legacy hash
        final legacyHash = 'sha256:${sha256.convert(utf8.encode(pin))}';
        if (storedHash == legacyHash) {
          // Upgrade to salted hash
          await _upgradePinHash(userModel.id, pin);
          return true;
        }
      }
    } else {
      // Plaintext legacy PIN
      if (storedHash == pin) {
        // Upgrade legacy plaintext PIN storage after the first successful login.
        await _upgradePinHash(userModel.id, pin);
        return true;
      }
    }

    return false;
  }

  Future<void> _upgradePinHash(String userId, String pin) async {
    final newHashedPin = _hashNewPin(pin);
    await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userId)))
        .write(UsersCompanion(pinHash: Value(newHashedPin)));
  }

  User _mapUser(UserModel userModel) {
    return User(
      id: userModel.id,
      username: userModel.username,
      fullNameKh: userModel.fullNameKh,
      fullNameEn: userModel.fullNameEn,
      role: userModel.role,
      avatarPath: userModel.avatarPath,
      isActive: userModel.isActive,
      lastLoginAt: userModel.lastLoginAt,
      createdAt: userModel.createdAt,
    );
  }

  String _hashNewPin(String pin) {
    final random = Random.secure();
    final saltBytes = List<int>.generate(16, (_) => random.nextInt(256));
    final salt = base64Encode(saltBytes);
    return _hashPinWithSalt(pin, salt);
  }

  String _hashPinWithSalt(String pin, String salt) {
    return 'sha256:$salt:${sha256.convert(utf8.encode('$salt$pin'))}';
  }
}
