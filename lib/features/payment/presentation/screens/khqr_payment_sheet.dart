import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/core/utils/currency_formatter.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_bloc.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_event.dart';
import 'package:khmerbiz_pos/features/payment/presentation/bloc/payment_state.dart';
import 'package:khmerbiz_pos/features/payment/presentation/widgets/qr_code_widget.dart';
import 'package:khmerbiz_pos/features/payment/presentation/widgets/payment_countdown_ring.dart';

/// Full-screen KHQR payment bottom sheet.
///
/// Shows the QR code, countdown timer, polling indicator, and handles
/// all payment states: generating, awaiting, confirmed, timed out,
/// failed, offline, and cancelled.
///
/// Usage:
/// ```dart
/// showModalBottomSheet(
///   context: context,
///   isScrollControlled: true,
///   builder: (_) => BlocProvider.value(
///     value: paymentBloc,
///     child: KhqrPaymentSheet(
///       amountKHR: 50000,
///       invoiceId: 'TXN-20260330-0001',
///     ),
///   ),
/// );
/// ```
class KhqrPaymentSheet extends StatelessWidget {
  const KhqrPaymentSheet({
    super.key,
    required this.amountKHR,
    required this.invoiceId,
    this.onPaymentConfirmed,
    this.onPaymentCancelled,
  });

  final double amountKHR;
  final String invoiceId;

  /// Callback when payment is confirmed — parent should process checkout.
  final void Function(String reference, String md5Hash)? onPaymentConfirmed;

  /// Callback when user cancels — parent should reset payment state.
  final VoidCallback? onPaymentCancelled;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        if (state is PaymentConfirmed) {
          // Auto-close after 2 seconds on success
          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              Navigator.of(context).pop();
              onPaymentConfirmed?.call(state.reference, state.md5Hash);
            }
          });
        } else if (state is PaymentCancelled) {
          Navigator.of(context).pop();
          onPaymentCancelled?.call();
        }
      },
      builder: (context, state) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.lg),
            ),
          ),
          child: Column(
            children: [
              _buildDragHandle(),
              _buildHeader(context, state),
              const Divider(height: 1),
              Expanded(
                child: _buildContent(context, state),
              ),
              _buildBottomActions(context, state),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PaymentState state) {
    final statusColor = switch (state) {
      PaymentConfirmed() => AppColors.success,
      PaymentTimedOut() || PaymentFailed() => AppColors.error,
      PaymentOffline() => AppColors.warning,
      _ => AppColors.khqrBlue,
    };

    final statusText = switch (state) {
      PaymentInitial() || PaymentGenerating() => 'Generating QR...',
      PaymentAwaitingConfirmation() => 'Scan to Pay',
      PaymentConfirmed() => 'Payment Confirmed',
      PaymentTimedOut() => 'QR Expired',
      PaymentFailed() => 'Payment Failed',
      PaymentOffline() => 'No Internet',
      PaymentCancelled() => 'Cancelled',
      PaymentDeepLinkLaunched() => 'Waiting for Payment',
    };

    final statusTextKm = switch (state) {
      PaymentInitial() || PaymentGenerating() => 'កំពុងបង្កើត QR...',
      PaymentAwaitingConfirmation() => 'ស្កេនដើម្បីបង់ប្រាក់',
      PaymentConfirmed() => 'ការទូទាត់បានបញ្ជាក់',
      PaymentTimedOut() => 'QR ផុតកំណត់',
      PaymentFailed() => 'ការទូទាត់បរាជ័យ',
      PaymentOffline() => 'គ្មានអ៊ីនធឺណិត',
      PaymentCancelled() => 'បានបោះបង់',
      PaymentDeepLinkLaunched() => 'កំពុងរង់ចាំការទូទាត់',
    };

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: statusColor,
                  ),
                ),
                Text(
                  statusTextKm,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Amount display
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amountKHR.formatKHR,
                style: AppTextStyles.priceDisplay.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                ),
              ),
              Text(
                amountKHR.formatUSD,
                style: AppTextStyles.priceSub.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaymentState state) {
    return switch (state) {
      PaymentInitial() || PaymentGenerating() => _buildGeneratingState(),
      PaymentAwaitingConfirmation() => _buildAwaitingState(context, state),
      PaymentConfirmed() => _buildConfirmedState(context, state),
      PaymentTimedOut() => _buildTimedOutState(context, state),
      PaymentFailed() => _buildFailedState(context, state),
      PaymentOffline() => _buildOfflineState(context, state),
      PaymentDeepLinkLaunched() => _buildDeepLinkState(context, state),
      PaymentCancelled() => const SizedBox.shrink(),
    };
  }

  // ── Generating State ────────────────────────────────────────────────────

  Widget _buildGeneratingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              color: AppColors.khqrBlue,
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text('Generating KHQR code...'),
          SizedBox(height: AppSpacing.xs),
          Text(
            'កំពុងបង្កើតកូដ KHQR...',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ── Awaiting Confirmation State ─────────────────────────────────────────

  Widget _buildAwaitingState(
      BuildContext context, PaymentAwaitingConfirmation state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        children: [
          // Countdown ring with QR inside
          PaymentCountdownRing(
            remaining: state.remaining,
            total: const Duration(minutes: 5),
            child: QrCodeWidget(
              data: state.khqrData.qrString,
              size: 220,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Remaining time
          Text(
            state.remainingFormatted,
            style: AppTextStyles.priceDisplay.copyWith(
              color: state.remaining.inSeconds <= 60
                  ? AppColors.error
                  : AppColors.khqrBlue,
              fontSize: 32,
            ),
          ),
          Text(
            'Time remaining / ពេលវេលានៅសល់',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // Invoice info
          Container(
            padding: const EdgeInsets.all(AppSpacing.base),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                    'Invoice / វិក្កយបត្រ', state.khqrData.invoiceId),
                const SizedBox(height: AppSpacing.xs),
                _buildInfoRow(
                    'Amount / ចំនួន', amountKHR.formatDual),
                const SizedBox(height: AppSpacing.xs),
                _buildInfoRow(
                  'Poll attempts / ការពិនិត្យ',
                  '${state.pollAttempts}',
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Polling indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.khqrBlue,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Checking payment status...',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Confirmed State ─────────────────────────────────────────────────────

  Widget _buildConfirmedState(
      BuildContext context, PaymentConfirmed state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.successLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Payment Confirmed!',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'ការទូទាត់បានបញ្ជាក់!',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              state.amountKHR.formatDual,
              style: AppTextStyles.priceDisplay.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Text(
                'Ref: ${state.reference}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Timed Out State ─────────────────────────────────────────────────────

  Widget _buildTimedOutState(
      BuildContext context, PaymentTimedOut state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.timer_off,
                color: AppColors.warning,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'QR Code Expired',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'កូដ QR ផុតកំណត់',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'The 5-minute payment window has elapsed.\nTap "Retry" to generate a new QR code.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Failed State ────────────────────────────────────────────────────────

  Widget _buildFailedState(BuildContext context, PaymentFailed state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Payment Failed',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              state.messageKm,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              state.messageEn,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Offline State ───────────────────────────────────────────────────────

  Widget _buildOfflineState(BuildContext context, PaymentOffline state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.wifi_off,
                color: AppColors.warning,
                size: 64,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'No Internet Connection',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'គ្មានការតភ្ជាប់អ៊ីនធឺណិត',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'KHQR requires internet to generate QR codes.\n'
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tip: Switch to Cash payment for offline transactions.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Deep Link State ─────────────────────────────────────────────────────

  Widget _buildDeepLinkState(
      BuildContext context, PaymentDeepLinkLaunched state) {
    final appName = state.method.name.toUpperCase();
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                color: AppColors.khqrBlue,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Waiting for $appName payment...',
              style: AppTextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Complete the payment in the $appName app,\nthen return here to confirm.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Bottom Actions ──────────────────────────────────────────────────────

  Widget _buildBottomActions(BuildContext context, PaymentState state) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.base),
        child: switch (state) {
          PaymentAwaitingConfirmation() || PaymentGenerating() =>
            _buildCancelButton(context),
          PaymentTimedOut() || PaymentOffline() =>
            _buildRetryAndCancelButtons(context),
          PaymentFailed() => _buildRetryAndCancelButtons(context),
          PaymentConfirmed() => const SizedBox(height: AppSpacing.base),
          PaymentDeepLinkLaunched() =>
            _buildDeepLinkActions(context, state as PaymentDeepLinkLaunched),
          _ => _buildCancelButton(context),
        },
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: () {
          context.read<PaymentBloc>().add(const CancelPayment());
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
          ),
        ),
        child: const Text('Cancel / បោះបង់'),
      ),
    );
  }

  Widget _buildRetryAndCancelButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                context.read<PaymentBloc>().add(const CancelPayment());
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
              ),
              child: const Text('Cancel / បោះបង់'),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: SizedBox(
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.read<PaymentBloc>().add(const RetryPayment());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.khqrBlue,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
              ),
              child: const Text('Retry / ព្យាយាមម្ដងទៀត'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeepLinkActions(
      BuildContext context, PaymentDeepLinkLaunched state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              // Manual confirmation — user confirms payment was made
              context.read<PaymentBloc>().add(
                    ConfirmManualPayment(
                      reference:
                          '${state.method.name.toUpperCase()}-MANUAL-${DateTime.now().millisecondsSinceEpoch}',
                    ),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
            child: const Text('I\'ve Paid / ខ្ញុំបានបង់រួចហើយ'),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              context.read<PaymentBloc>().add(const CancelPayment());
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
            child: const Text('Cancel / បោះបង់'),
          ),
        ),
      ],
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
