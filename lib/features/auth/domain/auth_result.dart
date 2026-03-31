import 'package:equatable/equatable.dart';

import 'package:khmerbiz_pos/features/auth/domain/user.dart';

/// Authentication result containing user data and tokens.
final class AuthResult extends Equatable {
  /// Creates an [AuthResult].
  const AuthResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  /// Authenticated user
  final User user;

  /// JWT access token
  final String accessToken;

  /// JWT refresh token
  final String refreshToken;

  /// Token expiry timestamp
  final DateTime expiresAt;

  /// Check if token is expired
  bool get isTokenExpired => DateTime.now().isAfter(expiresAt);

  /// Check if token is about to expire (within 5 minutes)
  bool get isTokenExpiringSoon {
    final threshold = DateTime.now().add(const Duration(minutes: 5));
    return expiresAt.isBefore(threshold);
  }

  @override
  List<Object?> get props => [user, accessToken, refreshToken, expiresAt];
}

/// Registration data for new user signup.
final class RegisterData extends Equatable {
  /// Creates registration data.
  const RegisterData({
    required this.email,
    required this.password,
    required this.displayName,
    required this.phoneNumber,
    required this.businessName,
    this.invitationCode,
  });

  /// User's email
  final String email;

  /// User's password
  final String password;

  /// User's display name
  final String displayName;

  /// User's phone number
  final String phoneNumber;

  /// Business/shop name
  final String businessName;

  /// Invitation code (optional)
  final String? invitationCode;

  @override
  List<Object?> get props => [
        email,
        password,
        displayName,
        phoneNumber,
        businessName,
        invitationCode,
      ];
}
