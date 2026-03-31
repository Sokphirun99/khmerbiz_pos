import 'package:equatable/equatable.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

final class LoadTransactions extends TransactionEvent {
  const LoadTransactions({this.dateRange});

  final CustomDateRange? dateRange;

  @override
  List<Object?> get props => [dateRange];
}

final class LoadTransactionDetail extends TransactionEvent {
  const LoadTransactionDetail({required this.transactionId});

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

final class VoidTransaction extends TransactionEvent {
  const VoidTransaction({
    required this.transactionId,
    required this.staffId,
  });

  final String transactionId;
  final String staffId;

  @override
  List<Object?> get props => [transactionId, staffId];
}

final class RefreshTransactions extends TransactionEvent {
  const RefreshTransactions();
}

final class SelectDateRange extends TransactionEvent {
  const SelectDateRange({this.dateRange});

  final CustomDateRange? dateRange;

  @override
  List<Object?> get props => [dateRange];
}

final class ClearTransactionDetail extends TransactionEvent {
  const ClearTransactionDetail();
}

class CustomDateRange extends Equatable {
  const CustomDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  List<Object?> get props => [start, end];
}
