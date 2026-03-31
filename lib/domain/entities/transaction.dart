import 'package:equatable/equatable.dart';

/// Transaction entity representing a completed sale.
///
/// Contains all financial details, payment information, and receipt metadata.
class Transaction extends Equatable {
  /// Creates a [Transaction] entity.
  const Transaction({
    required this.id,
    required this.receiptNumber,
    required this.transactionDate,
    required this.staffId,
    required this.subtotal,
    required this.totalAmount,
    required this.totalAmountUSD,
    required this.paymentMethod,
    required this.createdAt,
    this.customerId,
    this.discountType,
    this.discountValue = 0,
    this.discountAmount = 0,
    this.taxRate = 0.10,
    this.taxAmount = 0,
    this.cashReceived,
    this.changeGiven,
    this.khqrReference,
    this.khqrMd5,
    this.status = 'completed',
    this.isSynced = false,
    this.syncedAt,
    this.notes,
  });

  /// Unique identifier for the transaction.
  final String id;

  /// User-facing receipt number (e.g., "RCP-2026-0001").
  final String receiptNumber;

  /// The official date and time of the transaction.
  final DateTime transactionDate;

  /// ID of the staff member who processed the sale.
  final String staffId;

  /// Optional ID of the customer associated with this sale.
  final String? customerId;

  /// Subtotal amount before discounts and taxes (in KHR).
  final double subtotal;

  /// Type of discount applied (e.g., "percentage", "fixed").
  final String? discountType;

  /// The value of the discount (e.g., 10 for 10% or 5000 for ៛5,000).
  final double discountValue;

  /// The actual calculated discount amount in KHR.
  final double discountAmount;

  /// The tax rate applied (e.g., 0.10 for 10% VAT).
  final double taxRate;

  /// The actual calculated tax amount in KHR.
  final double taxAmount;

  /// The final total amount in KHR (subtotal - discount + tax).
  final double totalAmount;

  /// The final total amount converted to USD at the time of sale.
  final double totalAmountUSD;

  /// Payment method used (e.g., "cash", "khqr").
  final String paymentMethod;

  /// Amount of physical cash received from the customer (if cash sale).
  final double? cashReceived;

  /// Amount of change returned to the customer (if cash sale).
  final double? changeGiven;

  /// Reference number returned by the KHQR provider.
  final String? khqrReference;

  /// MD5 hash or unique signature of the KHQR transaction.
  final String? khqrMd5;

  /// Current status of the transaction (e.g., "completed", "refunded").
  final String status;

  /// Whether the transaction has been synced to the remote server.
  final bool isSynced;

  /// Timestamp of when the transaction was synced.
  final DateTime? syncedAt;

  /// Optional notes or comments about the transaction.
  final String? notes;

  /// Local creation timestamp.
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        receiptNumber,
        transactionDate,
        staffId,
        customerId,
        subtotal,
        discountType,
        discountValue,
        discountAmount,
        taxRate,
        taxAmount,
        totalAmount,
        totalAmountUSD,
        paymentMethod,
        cashReceived,
        changeGiven,
        khqrReference,
        khqrMd5,
        status,
        isSynced,
        syncedAt,
        notes,
        createdAt,
      ];
}
