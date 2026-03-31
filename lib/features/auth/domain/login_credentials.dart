import 'package:equatable/equatable.dart';

/// Login credentials for authentication.
final class LoginCredentials extends Equatable {
  /// Creates [LoginCredentials].
  const LoginCredentials({
    required this.email,
    required this.password,
    this.rememberMe = false,
  });

  /// User's email
  final String email;

  /// User's password
  final String password;

  /// Whether to remember the session
  final bool rememberMe;

  @override
  List<Object?> get props => [email, password, rememberMe];
}
