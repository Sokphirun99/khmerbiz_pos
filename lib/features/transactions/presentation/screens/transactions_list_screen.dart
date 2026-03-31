import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/di/injection.dart';
import 'package:khmerbiz_pos/core/router/app_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/transaction.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/widgets/transaction_list_tile.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/empty_state.dart';

class TransactionsListScreen extends StatelessWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>()..add(const LoadTransactions()),
      child: const _TransactionsBody(),
    );
  }
}

class _TransactionsBody extends StatelessWidget {
  const _TransactionsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transactions',
                  style: AppTextStyles.headlineLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'ប្រវត្តិប្រតិបត្តិការ',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: () => _pickDateRange(context, state),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  context.read<TransactionBloc>().add(
                        const RefreshTransactions(),
                      );
                },
              ),
              const SizedBox(width: AppSpacing.sm),
            ],
          ),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, TransactionState state) {
    return switch (state) {
      TransactionsInitial() || TransactionsLoading() => const _LoadingBody(),
      TransactionsLoaded() => _LoadedBody(state: state),
      TransactionError() => _ErrorBody(failure: state.failure),
      _ => const _LoadingBody(),
    };
  }

  Future<void> _pickDateRange(
    BuildContext context,
    TransactionState currentState,
  ) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      initialDateRange:
          currentState is TransactionsLoaded && currentState.dateRange != null
              ? DateTimeRange(
                  start: currentState.dateRange!.start,
                  end: currentState.dateRange!.end,
                )
              : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.onPrimary,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      context.read<TransactionBloc>().add(
            SelectDateRange(
              dateRange: CustomDateRange(
                start: picked.start,
                end: picked.end.add(const Duration(hours: 23, minutes: 59)),
              ),
            ),
          );
    }
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          ),
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final TransactionsLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TransactionBloc>().add(const RefreshTransactions());
      },
      child: CustomScrollView(
        slivers: [
          if (state.dateRange != null) _DateRangeBanner(state.dateRange!),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            sliver: state.transactions.isEmpty
                ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: const EmptyState(
                        variant: EmptyStateVariant.noTransactions,
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final tx = state.transactions[index];
                        return TransactionListTile(
                          transaction: tx,
                          onTap: () => _navigateToDetail(context, tx),
                        );
                      },
                      childCount: state.transactions.length,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, Transaction tx) {
    context.read<TransactionBloc>().add(
          LoadTransactionDetail(transactionId: tx.id),
        );
    context.pushNamed(
      AppRouter.transactionDetailName,
      pathParameters: {'id': tx.id},
    );
  }
}

class _DateRangeBanner extends StatelessWidget {
  const _DateRangeBanner(this.dateRange);

  final CustomDateRange dateRange;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd MMM yyyy');
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.pageHorizontal,
          vertical: AppSpacing.sm,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                '${formatter.format(dateRange.start)} – ${formatter.format(dateRange.end)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<TransactionBloc>().add(
                      const SelectDateRange(dateRange: null),
                    );
              },
              child: Text(
                'Today',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.failure});

  final dynamic failure;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Failed to load transactions',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'បរាជ័យក្នុងការផ្ទុកប្រវត្តិប្រតិបត្តិការ',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () {
                context.read<TransactionBloc>().add(
                      const RefreshTransactions(),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.base,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
