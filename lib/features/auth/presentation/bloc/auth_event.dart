import 'package:equatable/equatable.dart';

/// Events for the authentication BLoC.
///
/// All events extend this sealed class for type safety.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check if user is already authenticated.
final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Event to login with email and password.
final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
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

/// Event to register a new user.
final class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.displayName,
    required this.phoneNumber,
    required this.businessName,
  });
  final String email;
  final String password;
  final String displayName;
  final String phoneNumber;
  final String businessName;

  @override
  List<Object?> get props =>
      [email, password, displayName, phoneNumber, businessName];
}

/// Event to logout current user.
final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// Event to refresh authentication token.
final class AuthTokenRefreshRequested extends AuthEvent {
  const AuthTokenRefreshRequested();
}

/// Event to clear authentication state.
final class AuthClearRequested extends AuthEvent {
  const AuthClearRequested();
}
