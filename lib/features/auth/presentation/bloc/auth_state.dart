import 'package:equatable/equatable.dart';

import 'package:khmerbiz_pos/features/auth/domain/user.dart';

/// States for the authentication BLoC.
///
/// All states extend this sealed class for type safety.
sealed class AuthState extends Equatable {
  /// Creates an [AuthState].
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state - authentication status unknown.
final class AuthInitial extends AuthState {
  /// Creates an [AuthInitial] state.
  const AuthInitial();
}

/// Loading state - authentication in progress.
final class AuthLoading extends AuthState {
  /// Creates an [AuthLoading] state.
  const AuthLoading({this.message});

  /// Optional loading message
  final String? message;

  @override
  List<Object?> get props => [message];
}

/// Authenticated state - user is logged in.
final class AuthAuthenticated extends AuthState {
  /// Creates an [AuthAuthenticated] state.
  const AuthAuthenticated(this.user);

  /// Logged in user
  final User user;

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state - user is logged out.
final class AuthUnauthenticated extends AuthState {
  /// Creates an [AuthUnauthenticated] state.
  const AuthUnauthenticated();
}

/// Error state - authentication failed.
final class AuthError extends AuthState {
  /// Creates an [AuthError] state.
  const AuthError(this.message, {this.messageKm});

  /// Error message
  final String message;

  /// Error message in Khmer
  final String? messageKm;

  @override
  List<Object?> get props => [message, messageKm];
}
