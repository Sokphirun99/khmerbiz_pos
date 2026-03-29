import 'package:equatable/equatable.dart';

class User extends Equatable {

  const User({
    required this.id,
    required this.username,
    required this.fullNameKh,
    required this.fullNameEn,
    required this.role,
    required this.createdAt, this.avatarPath,
    this.isActive = true,
    this.lastLoginAt,
  });
  final String id;
  final String username;
  final String fullNameKh;
  final String fullNameEn;
  final String role;
  final String? avatarPath;
  final bool isActive;
  final DateTime? lastLoginAt;
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
