import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../domain/entities/checkout_enums.dart';
import '../../../../shared/widgets/widgets.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CheckoutSuccessScreen extends StatefulWidget {
  final CartCheckoutSuccess state;
  const CheckoutSuccessScreen({super.key, required this.state});

  @override
  State<CheckoutSuccessScreen> createState() => _CheckoutSuccessScreenState();
}

class _CheckoutSuccessScreenState extends State<CheckoutSuccessScreen> with SingleTickerProviderStateMixin {
  int _countdown = 30;
  Timer? _timer;
  late AnimationController _flashController;
  late Animation<Color?> _flashColorAnimation;

  @override
  void initState() {
    super.initState();
    _startCountdown();

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _flashColorAnimation = ColorTween(
      begin: AppColors.success.withOpacity(0.5),
      end: AppColors.background,
    ).animate(_flashController);

    _flashController.forward();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _newSale();
      }
    });
  }

  void _newSale() {
    _timer?.cancel();
    context.read<CartBloc>().add(ClearCart());
    context.go('/app/pos');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flashController.dispose();
    super.dispose();
  }

  String _getLocalizedPaymentMethod(BuildContext context, PaymentMethod method) {
    final l10n = AppLocalizations.of(context)!;
    switch (method) {
      case PaymentMethod.cash:
        return l10n.paymentCash;
      case PaymentMethod.khqr:
        return l10n.paymentKHQR;
      case PaymentMethod.aba:
        return 'ABA';
      case PaymentMethod.wing:
        return 'Wing';
      case PaymentMethod.credit:
        return l10n.paymentCard;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return AnimatedBuilder(
      animation: _flashColorAnimation,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _flashColorAnimation.value,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, size: 100, color: AppColors.success),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      l10n.checkoutSuccess,
                      style: AppTextStyles.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    
                    // Receipt Card
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildReceiptRow(
                            '${l10n.transactionReceipt} #',
                            widget.state.receiptNumber,
                          ),
                          _buildReceiptRow(
                            l10n.transactionDate,
                            widget.state.completedAt.formatDateTimeDual,
                          ),
                          _buildReceiptRow(
                            l10n.cashier,
                            widget.state.staffName,
                          ),
                          _buildReceiptRow(
                            l10n.paymentMethod,
                            _getLocalizedPaymentMethod(context, widget.state.paymentMethod),
                          ),
                          const Divider(height: AppSpacing.xl),
                          _buildReceiptRow(
                            l10n.transactionTotal.toUpperCase(),
                            widget.state.totalAmount.formatKHR,
                            isBold: true,
                          ),
                          _buildReceiptRow(
                            '',
                            '~${widget.state.totalAmountUSD.formatUSD}',
                            isSubtitle: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Actions
                    AppButton(
                      label: l10n.printReceipt,
                      type: AppButtonType.secondary,
                      icon: Icons.print,
                      onTap: () {
                        // Trigger print
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // New Sale Button with countdown indicator
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        AppButton(
                          label: '${l10n.newSale} ($_countdown)',
                          onTap: _newSale,
                        ),
                        Positioned(
                          right: 16,
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              value: _countdown / 30,
                              strokeWidth: 2,
                              color: AppColors.onPrimary.withOpacity(0.5),
                            ),
                          ),
                        )
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.md),
                    AppButton(
                      label: l10n.viewReceipt,
                      type: AppButtonType.ghost,
                      onTap: () {
                        // Navigate to transaction detail
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _buildReceiptRow(String label, String value, {bool isBold = false, bool isSubtitle = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (label.isNotEmpty)
            Text(
              label,
              style: isBold ? AppTextStyles.titleMedium : AppTextStyles.bodyMedium,
            ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: Text(
              value,
              style: isBold 
                ? AppTextStyles.titleMedium 
                : (isSubtitle ? AppTextStyles.bodySmall : AppTextStyles.bodyMedium),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
