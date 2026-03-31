import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';
import 'package:khmerbiz_pos/domain/entities/transaction_item.dart';

/// Transaction with all its items, used for receipt generation and display.
final class TransactionWithItems extends Equatable {
  /// Creates a [TransactionWithItems].
  const TransactionWithItems({
    required this.transaction,
    required this.items,
    this.customer,
  });

  /// The parent transaction.
  final Transaction transaction;

  /// List of items in this transaction.
  final List<TransactionItem> items;

  /// Customer associated with this transaction, if any.
  final Customer? customer;

  @override
  List<Object?> get props => [transaction, items, customer];

  /// Get the transaction date.
  DateTime get transactionDate => transaction.transactionDate;

  /// Get the receipt number.
  String get receiptNumber => transaction.receiptNumber;

  /// Get the total amount in KHR.
  double get totalAmount => transaction.totalAmount;

  /// Get the total amount in USD.
  double get totalAmountUSD => transaction.totalAmountUSD;

  /// Get the payment method.
  String get paymentMethod => transaction.paymentMethod;

  /// Get the subtotal.
  double get subtotal => transaction.subtotal;

  /// Get the discount amount.
  double get discountAmount => transaction.discountAmount;

  /// Get the tax amount.
  double get taxAmount => transaction.taxAmount;

  /// Get the cash received (if cash payment).
  double? get cashReceived => transaction.cashReceived;

  /// Get the change given (if cash payment).
  double? get changeGiven => transaction.changeGiven;

  /// Get the KHQR reference (if KHQR payment).
  String? get khqrReference => transaction.khqrReference;
}
