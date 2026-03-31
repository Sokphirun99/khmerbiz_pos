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
  /// Creates an [AuthCheckRequested] event.
  const AuthCheckRequested();
}

/// Event to login with email and password.
final class AuthLoginRequested extends AuthEvent {
  /// Creates an [AuthLoginRequested] event.
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
  /// Creates an [AuthRegisterRequested] event.
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.displayName,
    required this.phoneNumber,
    required this.businessName,
  });

  /// User's email.
  final String email;

  /// User's password.
  final String password;

  /// User's display name.
  final String displayName;

  /// User's phone number.
  final String phoneNumber;

  /// Business/shop name.
  final String businessName;

  @override
  List<Object?> get props =>
      [email, password, displayName, phoneNumber, businessName];
}

/// Event to logout current user.
final class AuthLogoutRequested extends AuthEvent {
  /// Creates an [AuthLogoutRequested] event.
  const AuthLogoutRequested();
}

/// Event to refresh authentication token.
final class AuthTokenRefreshRequested extends AuthEvent {
  /// Creates an [AuthTokenRefreshRequested] event.
  const AuthTokenRefreshRequested();
}

/// Event to clear authentication state.
final class AuthClearRequested extends AuthEvent {
  /// Creates an [AuthClearRequested] event.
  const AuthClearRequested();
}
