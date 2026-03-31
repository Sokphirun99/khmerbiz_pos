import 'package:equatable/equatable.dart';

/// Customer entity for loyalty tracking and sales history.
class Customer extends Equatable {
  /// Creates a [Customer] entity.
  const Customer({
    required this.id,
    required this.phone,
    required this.name,
    required this.createdAt,
    this.email,
    this.loyaltyPoints = 0,
    this.totalSpent = 0,
    this.totalTransactions = 0,
    this.tier = 'regular',
    this.notes,
  });

  /// Unique identifier for the customer.
  final String id;

  /// Primary contact phone number.
  final String phone;

  /// Full name of the customer.
  final String name;

  /// Optional email address.
  final String? email;

  /// Accumulated loyalty points for rewards.
  final double loyaltyPoints;

  /// Liftime total amount spent by this customer.
  final double totalSpent;

  /// Total number of successful transactions.
  final int totalTransactions;

  /// Customer tier (e.g., "regular", "silver", "gold").
  final String tier;

  /// Optional notes or preferences.
  final String? notes;

  /// Date and time when the customer was registered.
  final DateTime createdAt;

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
