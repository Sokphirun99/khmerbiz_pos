import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user in the system.
///
/// This is a pure domain object with no dependencies on Flutter or data layers.
final class User extends Equatable {

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.phoneNumber,
    this.role = UserRole.cashier,
    this.businessId,
    this.avatarUrl,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
  });
  /// Unique user identifier
  final String id;

  /// User's email address (used for login)
  final String email;

  /// User's display name
  final String displayName;

  /// User's phone number (optional)
  final String? phoneNumber;

  /// User's role/permissions
  final UserRole role;

  /// Associated business/shop ID
  final String? businessId;

  /// User's profile avatar URL (optional)
  final String? avatarUrl;

  /// Whether the user is active
  final bool isActive;

  /// Account creation timestamp
  final DateTime createdAt;

  /// Last login timestamp
  final DateTime? lastLoginAt;

  /// Check if user has admin role
  bool get isAdmin => role == UserRole.admin;

  /// Check if user has manager role
  bool get isManager => role == UserRole.manager || role == UserRole.admin;

  /// Check if user has cashier role
  bool get isCashier => role == UserRole.cashier;

  /// Create a copy of this user with updated fields.
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? phoneNumber,
    UserRole? role,
    String? businessId,
    String? avatarUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      businessId: businessId ?? this.businessId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        phoneNumber,
        role,
        businessId,
        avatarUrl,
        isActive,
        createdAt,
        lastLoginAt,
      ];

  @override
  String toString() {
    return 'User(id: $id, email: $email, displayName: $displayName, role: $role)';
  }
}

/// User roles defining permissions in the system.
enum UserRole {
  /// Admin - Full access to all features and settings
  admin,

  /// Manager - Access to most features except system settings
  manager,

  /// Cashier - Limited to POS, cart, and transaction viewing
  cashier,

  /// Inventory - Limited to inventory management
  inventory,
}

extension UserRoleExtension on UserRole {
  /// Display name for the role
  String get displayName {
    return switch (this) {
      UserRole.admin => 'Admin',
      UserRole.manager => 'Manager',
      UserRole.cashier => 'Cashier',
      UserRole.inventory => 'Inventory',
    };
  }

  /// Display name in Khmer
  String get displayKhmer {
    return switch (this) {
      UserRole.admin => 'អ្នកគ្រប់គ្រងកំពូល',
      UserRole.manager => 'អ្នកគ្រប់គ្រង',
      UserRole.cashier => 'គណនីករ',
      UserRole.inventory => 'អ្នកគ្រប់គ្រងស្តុក',
    };
  }
}
