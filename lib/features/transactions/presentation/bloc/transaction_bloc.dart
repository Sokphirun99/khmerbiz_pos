import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required TransactionRepository transactionRepository,
  })  : _transactionRepository = transactionRepository,
        super(TransactionsInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<LoadTransactionDetail>(_onLoadTransactionDetail);
    on<VoidTransaction>(_onVoidTransaction);
    on<RefreshTransactions>(_onRefreshTransactions);
    on<SelectDateRange>(_onSelectDateRange);
    on<ClearTransactionDetail>(_onClearTransactionDetail);
  }

  final TransactionRepository _transactionRepository;

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionsLoading());

    final range = event.dateRange;
    final stream = range != null
        ? _transactionRepository.watchTransactionsByDateRange(
            range.start,
            range.end,
          )
        : _transactionRepository.watchTodayTransactions();

    await emit.forEach<Either<Failure, List<Transaction>>>(
      stream,
      onData: (either) {
        return either.fold(
          (failure) => TransactionError(failure: failure),
          (transactions) => TransactionsLoaded(
            transactions: transactions,
            dateRange: event.dateRange,
          ),
        );
      },
    );
  }

  Future<void> _onLoadTransactionDetail(
    LoadTransactionDetail event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionDetailLoading());

    final result = await _transactionRepository.getTransactionWithItems(
      event.transactionId,
    );

    result.fold(
      (failure) => emit(TransactionError(failure: failure)),
      (transactionWithItems) => emit(
        TransactionDetailLoaded(transactionWithItems: transactionWithItems),
      ),
    );
  }

  Future<void> _onVoidTransaction(
    VoidTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionVoiding());

    final result = await _transactionRepository.voidTransaction(
      event.transactionId,
      event.staffId,
    );

    result.fold(
      (failure) => emit(TransactionError(failure: failure)),
      (_) {
        emit(TransactionVoided());
        add(const RefreshTransactions());
      },
    );
  }

  Future<void> _onRefreshTransactions(
    RefreshTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    final dateRange = state is TransactionsLoaded
        ? (state as TransactionsLoaded).dateRange
        : null;
    add(LoadTransactions(dateRange: dateRange));
  }

  Future<void> _onSelectDateRange(
    SelectDateRange event,
    Emitter<TransactionState> emit,
  ) async {
    add(LoadTransactions(dateRange: event.dateRange));
  }

  void _onClearTransactionDetail(
    ClearTransactionDetail event,
    Emitter<TransactionState> emit,
  ) {
    if (state is TransactionsLoaded) return;
    add(const RefreshTransactions());
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
