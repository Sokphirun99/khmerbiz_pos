import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_event.dart';

sealed class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object?> get props => [];
}

final class TransactionsInitial extends TransactionState {}

final class TransactionsLoading extends TransactionState {}

final class TransactionsLoaded extends TransactionState {
  const TransactionsLoaded({
    required this.transactions,
    this.dateRange,
    this.isLoadingMore = false,
  });

  final List<Transaction> transactions;
  final CustomDateRange? dateRange;
  final bool isLoadingMore;

  TransactionsLoaded copyWith({
    List<Transaction>? transactions,
    CustomDateRange? dateRange,
    bool? isLoadingMore,
    bool clearDateRange = false,
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      dateRange: clearDateRange ? null : (dateRange ?? this.dateRange),
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [transactions, dateRange, isLoadingMore];
}

final class TransactionDetailLoading extends TransactionState {}

final class TransactionDetailLoaded extends TransactionState {
  const TransactionDetailLoaded({required this.transactionWithItems});

  final TransactionWithItems transactionWithItems;

  @override
  List<Object?> get props => [transactionWithItems];
}

final class TransactionError extends TransactionState {
  const TransactionError({required this.failure});

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}

final class TransactionVoiding extends TransactionState {}

final class TransactionVoided extends TransactionState {}
