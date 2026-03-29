import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username;
  final String pinHash;
  final String fullNameKh;
  final String fullNameEn;
  final String role;
  final String? avatarPath;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.username,
    required this.pinHash,
    required this.fullNameKh,
    required this.fullNameEn,
    required this.role,
    this.avatarPath,
    this.isActive = true,
    this.lastLoginAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        pinHash,
        fullNameKh,
        fullNameEn,
        role,
        avatarPath,
        isActive,
        lastLoginAt,
        createdAt,
      ];
}
