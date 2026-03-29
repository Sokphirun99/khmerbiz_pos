import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String id;
  final String phone;
  final String name;
  final String? email;
  final double loyaltyPoints;
  final double totalSpent;
  final int totalTransactions;
  final String tier;
  final String? notes;
  final DateTime createdAt;

  const Customer({
    required this.id,
    required this.phone,
    required this.name,
    this.email,
    this.loyaltyPoints = 0,
    this.totalSpent = 0,
    this.totalTransactions = 0,
    this.tier = 'regular',
    this.notes,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        phone,
        name,
        email,
        loyaltyPoints,
        totalSpent,
        totalTransactions,
        tier,
        notes,
        createdAt,
      ];
}
