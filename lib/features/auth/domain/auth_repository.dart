import 'package:khmerbiz_pos/core/error/failures.dart' show ServerFailure, NetworkFailure, ValidationFailure;

import 'package:khmerbiz_pos/features/auth/domain/auth_result.dart';
import 'package:khmerbiz_pos/features/auth/domain/login_credentials.dart';
import 'package:khmerbiz_pos/features/auth/domain/user.dart';

/// Abstract repository interface for authentication operations.
///
/// This interface defines the contract for authentication functionality.
/// Implementation is in the data layer.
///
/// Usage:
/// ```dart
/// final authRepo = sl<AuthRepository>();
/// final result = await authRepo.login(credentials);
/// ```
abstract class AuthRepository {
  /// Get the current authenticated user.
  ///
  /// Returns [User] if authenticated, `null` otherwise.
  User? get currentUser;

  /// Get the current access token.
  ///
  /// Returns token string if authenticated, `null` otherwise.
  String? get accessToken;

  /// Check if user is authenticated.
  ///
  /// Returns `true` if user has valid session.
  bool get isAuthenticated;

  /// Stream of authentication state changes.
  ///
  /// Emits [User] when logged in, `null` when logged out.
  Stream<User?> get authStateChanges;

  /// Login with email and password.
  ///
  /// [credentials] - Login credentials
  /// Returns [AuthResult] on success
  /// Throws [ServerFailure] for server errors
  /// Throws [NetworkFailure] for connectivity issues
  /// Throws [ValidationFailure] for invalid credentials
  Future<AuthResult> login(LoginCredentials credentials);

  /// Register a new user.
  ///
  /// [email] - User's email
  /// [password] - User's password
  /// Returns [AuthResult] on success
  Future<AuthResult> register(String email, String password);

  /// Logout current session.
  ///
  /// [notifyServer] - Whether to invalidate token on server
  Future<void> logout({bool notifyServer = true});

  /// Refresh the authentication token.
  ///
  /// Returns new [AuthResult] with refreshed tokens
  Future<AuthResult> refreshToken();

  /// Get current user profile from server.
  ///
  /// Returns updated [User] object
  Future<User> getCurrentUser();

  /// Update user profile.
  ///
  /// [displayName] - New display name
  /// [phoneNumber] - New phone number
  /// [avatarUrl] - New avatar URL
  /// Returns updated [User]
  Future<User> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? avatarUrl,
  });

  /// Change user password.
  ///
  /// [currentPassword] - Current password for verification
  /// [newPassword] - New password to set
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Request password reset.
  ///
  /// [email] - Email address to send reset link
  Future<void> requestPasswordReset(String email);

  /// Reset password with token.
  ///
  /// [token] - Reset token from email
  /// [newPassword] - New password to set
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });

  /// Clear all stored auth data.
  ///
  /// Used for cleanup, doesn't notify server.
  void clearAuthData();
}
