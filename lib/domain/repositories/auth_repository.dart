import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login({required String username, required String pin});
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}
