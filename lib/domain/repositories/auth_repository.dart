import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/user.dart';

/// Repository interface for user authentication and session management.
abstract class AuthRepository {
  /// Authenticates a user with [username] and [pin].
  ///
  /// Returns a [User] entity on success, or a [Failure] on error.
  Future<Either<Failure, User>> login({
    required String username,
    required String pin,
  });

  /// Terminates the current user session and clears local credentials.
  Future<Either<Failure, void>> logout();

  /// Retrieves the currently authenticated user from local storage.
  ///
  /// Returns a [User] if a session exists, or a [Failure] otherwise.
  Future<Either<Failure, User>> getCurrentUser();
}
