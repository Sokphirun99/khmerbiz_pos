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
  Future<Either<Failure, User>> login({required String username, required String pin}) async {
    try {
      final userModel = await (_db.select(_db.users)..where((tbl) => tbl.username.equals(username))).getSingleOrNull();
      if (userModel == null) return left(ServerFailure.notFound());
      if (userModel.pinHash != pin) return left(ValidationFailure.custom(messageEn: 'Invalid PIN', messageKm: 'លេខសម្ងាត់មិនត្រឹមត្រូវ')); // Note: Should hash pin before compare
      
      final user = User(
        id: userModel.id,
        username: userModel.username,
        pinHash: userModel.pinHash,
        fullNameKh: userModel.fullNameKh,
        fullNameEn: userModel.fullNameEn,
        role: userModel.role,
        avatarPath: userModel.avatarPath,
        isActive: userModel.isActive,
        lastLoginAt: userModel.lastLoginAt,
        createdAt: userModel.createdAt,
      );
      return right(user);
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
}
