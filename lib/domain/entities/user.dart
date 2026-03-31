import 'package:equatable/equatable.dart';

/// Represents a system user (staff or admin).
class User extends Equatable {
  /// Creates a [User] entity.
  const User({
    required this.id,
    required this.username,
    required this.fullNameKh,
    required this.fullNameEn,
    required this.role,
    required this.createdAt,
    this.avatarPath,
    this.isActive = true,
    this.lastLoginAt,
  });

  /// Unique identifier for the user.
  final String id;

  /// Unique login name.
  final String username;

  /// User's full name in Khmer.
  final String fullNameKh;

  /// User's full name in English.
  final String fullNameEn;

  /// Access role (e.g., "admin", "cashier", "manager").
  final String role;

  /// Path to the user's profile picture.
  final String? avatarPath;

  /// Whether the user account is active.
  final bool isActive;

  /// Last recorded successful login.
  final DateTime? lastLoginAt;

  /// Date and time when the user was created.
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        username,
        fullNameKh,
        fullNameEn,
        role,
        avatarPath,
        isActive,
        lastLoginAt,
        createdAt,
      ];
}
