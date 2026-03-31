import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:khmerbiz_pos/core/di/injection.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/bloc/transaction_state.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/widgets/transaction_detail_items.dart';
import 'package:khmerbiz_pos/features/transactions/presentation/widgets/transaction_summary_row.dart';

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({required this.transactionId, super.key});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TransactionBloc>()
        ..add(LoadTransactionDetail(transactionId: transactionId)),
      child: _TransactionDetailBody(transactionId: transactionId),
    );
  }
}

class _TransactionDetailBody extends StatelessWidget {
  const _TransactionDetailBody({required this.transactionId});

  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.read<TransactionBloc>().add(
                      const ClearTransactionDetail(),
                    );
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              'Transaction Detail',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            actions: [
              if (state is TransactionDetailLoaded &&
                  state.transactionWithItems.transaction.status == 'completed')
                TextButton.icon(
                  onPressed: () => _confirmVoid(context, transactionId),
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: Text(
                    'Void',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              if (state is TransactionDetailLoaded &&
                  state.transactionWithItems.transaction.status != 'completed')
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
      TransactionDetailLoading() => const _LoadingBody(),
      TransactionDetailLoaded() => _LoadedBody(state: state),
      TransactionError() =>
        _ErrorBody(failure: state.failure, transactionId: transactionId),
      _ => const _LoadingBody(),
    };
  }

  void _confirmVoid(BuildContext context, String transactionId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Void Transaction',
            style: AppTextStyles.headlineMedium,
          ),
          content: Text(
            'This will reverse the stock and mark the transaction as voided. This action cannot be undone.',
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<TransactionBloc>().add(
                      VoidTransaction(
                        transactionId: transactionId,
                        staffId: 'local-staff',
                      ),
                    );
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Confirm Void'),
            ),
          ],
        );
      },
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final TransactionDetailLoaded state;

  @override
  Widget build(BuildContext context) {
    final tx = state.transactionWithItems.transaction;
    final items = state.transactionWithItems.items;
    final formatter = DateFormat('dd MMM yyyy, HH:mm');

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tx.receiptNumber,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _StatusChip(status: tx.status),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _InfoRow(
                label: 'Date',
                labelKm: 'កាលបរិច្ឆេទ',
                value: formatter.format(tx.transactionDate),
              ),
              const Divider(height: AppSpacing.md),
              _InfoRow(
                label: 'Payment',
                labelKm: 'ការទូទាត់',
                value: _paymentMethodLabel(tx.paymentMethod),
                icon: _paymentMethodIcon(tx.paymentMethod),
              ),
              if (tx.customerId != null) ...[
                const Divider(height: AppSpacing.md),
                _InfoRow(
                  label: 'Customer',
                  labelKm: 'អតិថិជន',
                  value: tx.customerId!,
                ),
              ],
              if (tx.notes != null && tx.notes!.isNotEmpty) ...[
                const Divider(height: AppSpacing.md),
                _InfoRow(
                  label: 'Notes',
                  labelKm: 'កំណត់ចំណាំ',
                  value: tx.notes!,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Items',
                style: AppTextStyles.headlineSmall,
              ),
              Text(
                'មុខទំនិញ',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TransactionDetailItems(items: items),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            children: [
              TransactionSummaryRow(
                label: 'Subtotal',
                value: '${tx.subtotal.toStringAsFixed(0)}៛',
              ),
              if (tx.discountAmount > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                TransactionSummaryRow(
                  label: 'Discount',
                  value: '-${tx.discountAmount.toStringAsFixed(0)}៛',
                  isNegative: true,
                ),
              ],
              if (tx.taxAmount > 0) ...[
                const SizedBox(height: AppSpacing.xs),
                TransactionSummaryRow(
                  label: 'Tax',
                  value: '+${tx.taxAmount.toStringAsFixed(0)}៛',
                ),
              ],
              const Divider(height: AppSpacing.md),
              TransactionSummaryRow(
                label: 'Total (KHR)',
                value: '${tx.totalAmount.toStringAsFixed(0)}៛',
                isTotal: true,
              ),
              const SizedBox(height: AppSpacing.xs),
              TransactionSummaryRow(
                label: 'Total (USD)',
                value: '\$${tx.totalAmountUSD.toStringAsFixed(2)}',
                isTotal: true,
              ),
              if (tx.paymentMethod.toLowerCase() == 'cash') ...[
                const Divider(height: AppSpacing.md),
                if (tx.cashReceived != null)
                  TransactionSummaryRow(
                    label: 'Cash Received',
                    value: '${tx.cashReceived!.toStringAsFixed(0)}៛',
                  ),
                if (tx.changeGiven != null)
                  TransactionSummaryRow(
                    label: 'Change',
                    value: '${tx.changeGiven!.toStringAsFixed(0)}៛',
                  ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  IconData _paymentMethodIcon(String method) {
    return switch (method.toLowerCase()) {
      'cash' => Icons.attach_money,
      'khqr' => Icons.qr_code,
      'aba' => Icons.account_balance,
      'wing' => Icons.wifi,
      _ => Icons.payment,
    };
  }

  String _paymentMethodLabel(String method) {
    return switch (method.toLowerCase()) {
      'cash' => 'Cash',
      'khqr' => 'KHQR',
      'aba' => 'ABA',
      'wing' => 'Wing',
      _ => method,
    };
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status.toLowerCase()) {
      'completed' => AppColors.success,
      'voided' => AppColors.error,
      'refunded' => AppColors.warning,
      _ => AppColors.textSecondary,
    };

    final label = switch (status.toLowerCase()) {
      'completed' => 'Completed',
      'voided' => 'Voided',
      'refunded' => 'Refunded',
      _ => status,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.labelKm,
    required this.value,
    this.icon,
  });

  final String label;
  final String labelKm;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.sm),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.labelSmall),
              Text(
                labelKm,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.failure, required this.transactionId});

  final dynamic failure;
  final String transactionId;

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
              'Failed to load transaction',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              onPressed: () {
                context.read<TransactionBloc>().add(
                      LoadTransactionDetail(transactionId: transactionId),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
