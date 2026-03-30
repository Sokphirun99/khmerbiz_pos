import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/adjustment_reason.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_bloc.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_event.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/bloc/inventory_state.dart';
import 'package:khmerbiz_pos/shared/widgets/buttons/app_button.dart';
import 'package:khmerbiz_pos/shared/widgets/inputs/app_text_field.dart';

class StockAdjustmentSheet extends StatefulWidget {
  const StockAdjustmentSheet({required this.product, super.key});

  final Product product;

  /// Show the stock adjustment bottom sheet.
  static Future<void> show(BuildContext context, Product product) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusExtraLarge),
        ),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<InventoryBloc>(),
        child: StockAdjustmentSheet(product: product),
      ),
    );
  }

  @override
  State<StockAdjustmentSheet> createState() => _StockAdjustmentSheetState();
}

class _StockAdjustmentSheetState extends State<StockAdjustmentSheet> {
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();
  AdjustmentReason _selectedReason = AdjustmentReason.receivedStock;
  bool _isStockIn = true;

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _quantity {
    final raw = double.tryParse(_quantityController.text) ?? 0;
    return _isStockIn ? raw.abs() : -raw.abs();
  }

  double get _projectedStock => widget.product.stock + _quantity;

  void _submit() {
    final qty = double.tryParse(_quantityController.text);
    if (qty == null || qty <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid quantity'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    context.read<InventoryBloc>().add(AdjustStock(
          productId: widget.product.id,
          quantity: _quantity,
          reason: _selectedReason,
          notes:
              _notesController.text.isNotEmpty ? _notesController.text : null,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InventoryBloc, InventoryState>(
      listener: (context, state) {
        if (state is StockAdjusted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Stock adjusted: ${state.previousStock.toStringAsFixed(0)} → ${state.updatedProduct.stock.toStringAsFixed(0)}',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
        if (state is InventoryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.pageHorizontal,
          right: AppSpacing.pageHorizontal,
          top: AppSpacing.base,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.base,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.base),

              // Title
              Text(
                'Adjust Stock',
                style: AppTextStyles.headlineLarge
                    .copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.xs),

              // Product info
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined,
                        color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.product.nameKh,
                              style: AppTextStyles.labelMedium),
                          Text(widget.product.nameEn,
                              style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Current Stock',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        Text(
                          widget.product.stock.toStringAsFixed(0),
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Stock In / Stock Out toggle
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Stock In',
                      icon: Icons.add_circle_outline,
                      isSelected: _isStockIn,
                      color: AppColors.success,
                      onTap: () => setState(() {
                        _isStockIn = true;
                        _selectedReason = AdjustmentReason.receivedStock;
                      }),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: _buildToggleButton(
                      label: 'Stock Out',
                      icon: Icons.remove_circle_outline,
                      isSelected: !_isStockIn,
                      color: AppColors.error,
                      onTap: () => setState(() {
                        _isStockIn = false;
                        _selectedReason = AdjustmentReason.damaged;
                      }),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // Reason dropdown
              DropdownButtonFormField<AdjustmentReason>(
                value: _selectedReason,
                decoration: InputDecoration(
                  labelText: 'Reason',
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                ),
                items: AdjustmentReason.values
                    .where((r) => _isStockIn ? r.isStockIn : !r.isStockIn)
                    .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text('${r.labelEn} (${r.labelKh})'),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedReason = v);
                },
              ),

              const SizedBox(height: AppSpacing.md),

              // Quantity
              AppTextField(
                label: 'Quantity',
                labelKhmer: 'ចំនួន',
                controller: _quantityController,
                type: AppTextFieldType.number,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: AppSpacing.md),

              // Notes
              AppTextField(
                label: 'Notes (optional)',
                labelKhmer: 'កំណត់ចំណាំ',
                controller: _notesController,
                type: AppTextFieldType.multiline,
              ),

              const SizedBox(height: AppSpacing.md),

              // Projected stock preview
              if (_quantityController.text.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _projectedStock < 0
                        ? AppColors.errorLight
                        : _projectedStock <=
                                widget.product.lowStockThreshold
                            ? AppColors.warningLight
                            : AppColors.successLight,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusMedium),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${widget.product.stock.toStringAsFixed(0)}',
                        style: AppTextStyles.headlineLarge,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.sm),
                        child: Icon(
                          Icons.arrow_forward,
                          color: _isStockIn
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                      Text(
                        _projectedStock.toStringAsFixed(0),
                        style: AppTextStyles.headlineLarge.copyWith(
                          color: _projectedStock < 0
                              ? AppColors.error
                              : AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              if (_projectedStock < 0)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    'Warning: Stock will go negative!',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.error),
                  ),
                ),

              const SizedBox(height: AppSpacing.lg),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  label: 'Confirm Adjustment',
                  labelKhmer: 'បញ្ជាក់ការកែតម្រូវ',
                  type: AppButtonType.primary,
                  onPressed: _submit,
                ),
              ),

              const SizedBox(height: AppSpacing.base),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
          horizontal: AppSpacing.base,
        ),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : AppColors.background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: isSelected ? color : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textSecondary),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? color : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
