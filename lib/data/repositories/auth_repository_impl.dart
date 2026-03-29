import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/user.dart';
import 'package:khmerbiz_pos/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
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
    final hashedPin = _hashPin(pin);
    if (userModel.pinHash == hashedPin) {
      return true;
    }

    if (userModel.pinHash == pin) {
      // Upgrade legacy plaintext PIN storage after the first successful login.
      await (_db.update(_db.users)..where((tbl) => tbl.id.equals(userModel.id)))
          .write(UsersCompanion(pinHash: Value(hashedPin)));
      return true;
    }

    return false;
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

  String _hashPin(String pin) {
    return 'sha256:${sha256.convert(utf8.encode(pin))}';
  }
}
