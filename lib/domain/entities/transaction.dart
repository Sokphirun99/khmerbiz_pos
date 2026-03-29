import 'package:equatable/equatable.dart';

class Transaction extends Equatable {

  const Transaction({
    required this.id,
    required this.receiptNumber,
    required this.transactionDate,
    required this.staffId,
    required this.subtotal, required this.totalAmount, required this.totalAmountUSD, required this.paymentMethod, required this.createdAt, this.customerId,
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
  final String id;
  final String receiptNumber;
  final DateTime transactionDate;
  final String staffId;
  final String? customerId;
  final double subtotal;
  final String? discountType;
  final double discountValue;
  final double discountAmount;
  final double taxRate;
  final double taxAmount;
  final double totalAmount;
  final double totalAmountUSD;
  final String paymentMethod;
  final double? cashReceived;
  final double? changeGiven;
  final String? khqrReference;
  final String? khqrMd5;
  final String status;
  final bool isSynced;
  final DateTime? syncedAt;
  final String? notes;
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
