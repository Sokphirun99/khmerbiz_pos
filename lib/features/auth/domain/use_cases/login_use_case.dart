import 'package:khmerbiz_pos/core/error/exceptions.dart';
import 'package:khmerbiz_pos/features/auth/domain/auth_repository.dart';
import 'package:khmerbiz_pos/features/auth/domain/auth_result.dart';
import 'package:khmerbiz_pos/features/auth/domain/login_credentials.dart';

/// Use case for user login.
final class LoginUseCase {

  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  /// Execute the login use case.
  Future<AuthResult> call(LoginCredentials credentials) async {
    // Validate input
    if (credentials.email.isEmpty) {
      throw const ValidationException(message: 'Email is required');
    }
    if (credentials.password.isEmpty) {
      throw const ValidationException(message: 'Password is required');
    }

    // Execute login through repository
    return _repository.login(credentials);
  }
}
