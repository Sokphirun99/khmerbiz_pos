import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

final class LoadDashboard extends HomeEvent {
  const LoadDashboard();
}

final class RefreshDashboard extends HomeEvent {
  const RefreshDashboard();
}

final class UpdateRecentTransactions extends HomeEvent {
  const UpdateRecentTransactions({required this.transactions});

  final List<Transaction> transactions;

  @override
  List<Object?> get props => [transactions];
}

final class UpdateLowStockCount extends HomeEvent {
  const UpdateLowStockCount({required this.count});

  final int count;

  @override
  List<Object?> get props => [count];
}

final class UpdatePendingSync extends HomeEvent {
  const UpdatePendingSync({required this.count});

  final int count;

  @override
  List<Object?> get props => [count];
}
