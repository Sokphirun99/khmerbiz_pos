import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/shared/widgets/widgets.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/app_snackbar.dart';
import 'package:khmerbiz_pos/shared/widgets/feedback/app_toast.dart';
import 'package:khmerbiz_pos/domain/entities/checkout_enums.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_event.dart';
import 'package:khmerbiz_pos/features/cart/presentation/bloc/cart_state.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  double? _cashReceived;
  final TextEditingController _cashController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 720;

    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartCheckoutSuccess) {
          context.go('/app/pos/checkout/success', extra: state);
        } else if (state is CartCheckoutFailure) {
          AppSnackbar.show(
            context,
            message: state.failure.messageKm,
            isError: true,
          );
        } else if (state is CartLoaded &&
            state.stockWarnings != null &&
            state.stockWarnings!.isNotEmpty) {
          final warningMessage = state.stockWarnings!.values.first;
          AppToast.show(
            context,
            message: warningMessage,
            isError: true, // using error style for warning as well
          );
        }
      },
      builder: (context, state) {
        if (state is CartInitial ||
            (state is CartLoaded && state.items.isEmpty)) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cart / រទេះ')),
            body: Center(
              child: EmptyState(
                variant: EmptyStateVariant.emptyCart,
                actionLabel: 'Start scanning',
                actionLabelKhmer: 'ចាប់ផ្តើមស្កេន',
                onAction: () => context.go('/app/pos'),
              ),
            ),
          );
        }

        if (state is CartLoaded) {
          if (isTablet) {
            return Scaffold(
              body: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ColoredBox(
                      color: AppColors.surfaceAlt,
                      child: const Center(
                          child: Text('ProductListScreen Placeholder')),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: _buildCartContent(context, state),
                  ),
                ],
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Cart / រទេះ (${state.items.length})'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context.read<CartBloc>().add(ClearCart()),
                  ),
                ],
              ),
              body: Stack(
                children: [
                  _buildCartContent(context, state),
                  if (state.isCheckingOut)
                    ColoredBox(
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
              ),
            );
          }
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildCartContent(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        // Customer Selector Row
        const Padding(
          padding: EdgeInsets.all(AppSpacing.base),
          child: AppTextField(
            type: AppTextFieldType.search,
            hintText: 'Search customer by phone...',
            hintTextKhmer: 'ស្វែងរកអតិថិជនតាមលេខទូរស័ព្ទ...',
            prefixIcon: Icons.person_search_outlined,
          ),
        ),

        // Cart Items
        Expanded(
          child: ListView.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = state.items[index];
              return CartItemTile(
                item: CartItemData(
                  id: item.id,
                  productId: item.productId,
                  name: item.product.nameEn,
                  nameKhmer: item.product.nameKh,
                  unitPriceKHR: item.unitPrice,
                  unitPriceUSD: item.unitPrice /
                      4000, // Approximate USD for display if needed
                  quantity: item.quantity.toInt(),
                ),
                onQuantityChanged: (qty) {
                  context.read<CartBloc>().add(
                        UpdateQuantity(
                          productId: item.productId,
                          quantity: qty.toDouble(),
                        ),
                      );
                },
                onRemoved: () {
                  context.read<CartBloc>().add(
                        RemoveFromCart(productId: item.productId),
                      );
                },
              );
            },
          ),
        ),

        // Discount Row
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: state.discountType == null
                      ? 'Add Discount'
                      : 'Discount: ${state.discountValue}${state.discountType == DiscountType.percent ? '%' : 'KHR'}',
                  type: AppButtonType.ghost,
                  onTap: () {
                    // Just applying a fixed 10% for now
                    context.read<CartBloc>().add(
                          const ApplyDiscount(
                              type: DiscountType.percent, value: 10),
                        );
                  },
                ),
              ),
              if (state.discountType != null) ...[
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      context.read<CartBloc>().add(RemoveDiscount()),
                ),
              ],
            ],
          ),
        ),

        // Order Summary
        Container(
          padding: const EdgeInsets.all(AppSpacing.base),
          color: AppColors.surface,
          child: Column(
            children: [
              _buildSummaryRow(
                'Subtotal:',
                PriceCompact(amountKHR: state.subtotal),
              ),
              if (state.discountAmount > 0)
                _buildSummaryRow(
                  'Discount:',
                  PriceCompact(
                      amountKHR: state.discountAmount, color: AppColors.error),
                ),
              _buildSummaryRow(
                'Tax (10%):',
                PriceCompact(amountKHR: state.taxAmount),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL:', style: AppTextStyles.headlineMedium),
                  PriceDisplay(
                    amountKHR: state.total,
                    amountUSD: state.totalUSD,
                    size: PriceSize.large,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Payment Methods Grid
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 2.5,
            children: [
              PaymentMethodButton(
                method: PaymentMethodType.cash,
                isSelected: _selectedPaymentMethod == PaymentMethod.cash,
                onTap: () =>
                    setState(() => _selectedPaymentMethod = PaymentMethod.cash),
              ),
              PaymentMethodButton(
                method: PaymentMethodType.khqr,
                isSelected: _selectedPaymentMethod == PaymentMethod.khqr,
                onTap: () =>
                    setState(() => _selectedPaymentMethod = PaymentMethod.khqr),
              ),
              PaymentMethodButton(
                method: PaymentMethodType.bankTransfer,
                isSelected: _selectedPaymentMethod == PaymentMethod.aba,
                onTap: () =>
                    setState(() => _selectedPaymentMethod = PaymentMethod.aba),
              ),
              PaymentMethodButton(
                method: PaymentMethodType.wing,
                isSelected: _selectedPaymentMethod == PaymentMethod.wing,
                onTap: () =>
                    setState(() => _selectedPaymentMethod = PaymentMethod.wing),
              ),
            ],
          ),
        ),

        // Cash Input
        if (_selectedPaymentMethod == PaymentMethod.cash)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _cashController,
                    type: AppTextFieldType.number,
                    hintText: 'Received Amount',
                    onChanged: (val) {
                      setState(() {
                        _cashReceived = double.tryParse(val);
                      });
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Change:'),
                    PriceCompact(
                      amountKHR: ((_cashReceived ?? 0) - state.total)
                          .clamp(0, double.infinity),
                      color: AppColors.success,
                    ),
                  ],
                ),
              ],
            ),
          ),

        // Checkout Button
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: AppButton(
            label: 'CHECKOUT',
            labelKhmer: 'ទូទាត់',
            height: 56,
            isDisabled: state.isCheckingOut ||
                (_selectedPaymentMethod == PaymentMethod.cash &&
                    (_cashReceived == null || _cashReceived! < state.total)),
            onTap: () {
              context.read<CartBloc>().add(
                    ProcessCheckout(
                      method: _selectedPaymentMethod,
                      cashReceived: _selectedPaymentMethod == PaymentMethod.cash
                          ? _cashReceived
                          : null,
                    ),
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          valueWidget,
        ],
      ),
    );
  }
}
