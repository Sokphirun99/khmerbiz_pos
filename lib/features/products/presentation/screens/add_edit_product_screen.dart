import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';
import 'package:khmerbiz_pos/domain/entities/category.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/domain/entities/product_input.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_bloc.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_event.dart';
import 'package:khmerbiz_pos/features/products/presentation/bloc/product_state.dart';
import 'package:khmerbiz_pos/features/products/presentation/widgets/barcode_scanner_overlay.dart';
import 'package:khmerbiz_pos/shared/widgets/buttons/app_button.dart';
import 'package:khmerbiz_pos/shared/widgets/inputs/app_text_field.dart';

class AddEditProductScreen extends StatefulWidget {
  const AddEditProductScreen({
    super.key,
    this.product,
    this.initialBarcode,
  });

  /// If non-null, we are editing this product.
  final Product? product;

  /// Pre-filled barcode from scanner.
  final String? initialBarcode;

  bool get isEditing => product != null;

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _barcodeController;
  late final TextEditingController _nameKhController;
  late final TextEditingController _nameEnController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _retailPriceController;
  late final TextEditingController _wholesalePriceController;
  late final TextEditingController _stockController;
  late final TextEditingController _lowStockController;

  String? _selectedCategoryId;
  String _selectedUnit = 'pcs';
  bool _isFeatured = false;
  bool _isActive = true;
  Map<String, String> _validationErrors = {};

  static const _units = ['pcs', 'kg', 'g', 'l', 'ml', 'box', 'pack', 'set'];

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _barcodeController =
        TextEditingController(text: widget.initialBarcode ?? p?.barcode ?? '');
    _nameKhController = TextEditingController(text: p?.nameKh ?? '');
    _nameEnController = TextEditingController(text: p?.nameEn ?? '');
    _costPriceController =
        TextEditingController(text: p?.costPrice.toString() ?? '0');
    _retailPriceController =
        TextEditingController(text: p?.retailPrice.toString() ?? '0');
    _wholesalePriceController =
        TextEditingController(text: p?.wholesalePrice?.toString() ?? '');
    _stockController =
        TextEditingController(text: p?.stock.toString() ?? '0');
    _lowStockController =
        TextEditingController(text: p?.lowStockThreshold.toString() ?? '5');
    _selectedCategoryId = p?.categoryId;
    _selectedUnit = p?.unit ?? 'pcs';
    _isFeatured = p?.isFeatured ?? false;
    _isActive = p?.isActive ?? true;
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameKhController.dispose();
    _nameEnController.dispose();
    _costPriceController.dispose();
    _retailPriceController.dispose();
    _wholesalePriceController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  ProductInput _buildInput() {
    return ProductInput(
      barcode: _barcodeController.text.isNotEmpty
          ? _barcodeController.text
          : null,
      nameKh: _nameKhController.text,
      nameEn: _nameEnController.text,
      categoryId: _selectedCategoryId,
      unit: _selectedUnit,
      costPrice: double.tryParse(_costPriceController.text) ?? 0,
      retailPrice: double.tryParse(_retailPriceController.text) ?? 0,
      wholesalePrice: _wholesalePriceController.text.isNotEmpty
          ? double.tryParse(_wholesalePriceController.text)
          : null,
      stock: double.tryParse(_stockController.text) ?? 0,
      lowStockThreshold: double.tryParse(_lowStockController.text) ?? 5,
      isFeatured: _isFeatured,
      isActive: _isActive,
    );
  }

  void _save() {
    final input = _buildInput();
    final errors = input.validate();
    errors.remove('retailPriceWarning');

    setState(() => _validationErrors = errors);

    if (errors.isNotEmpty) return;

    if (widget.isEditing) {
      context.read<ProductBloc>().add(
            UpdateProduct(id: widget.product!.id, input: input),
          );
    } else {
      context.read<ProductBloc>().add(AddProduct(input: input));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductSaved) {
          context.pop();
        }
        if (state is ProductsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.failure.toString()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          title: Text(
            widget.isEditing ? 'Edit Product' : 'Add Product',
            style: AppTextStyles.headlineLarge
                .copyWith(color: AppColors.primary),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: AppButton(
                label: 'Save',
                labelKhmer: 'រក្សាទុក',
                type: AppButtonType.accent,
                onPressed: _save,
              ),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
            children: [
              // ── Barcode Section ──
              _buildSectionHeader('Barcode', 'បាកូដ'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Barcode',
                      labelKhmer: 'បាកូដ',
                      controller: _barcodeController,
                      type: AppTextFieldType.text,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner,
                        color: AppColors.primary),
                    onPressed: () async {
                      final barcode =
                          await BarcodeScannerOverlay.show(context);
                      if (barcode != null) {
                        setState(() {
                          _barcodeController.text = barcode;
                        });
                      }
                    },
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Names Section ──
              _buildSectionHeader('Product Name', 'ឈ្មោះផលិតផល'),
              const SizedBox(height: AppSpacing.sm),
              AppTextField(
                label: 'Khmer Name *',
                labelKhmer: 'ឈ្មោះខ្មែរ *',
                controller: _nameKhController,
                type: AppTextFieldType.text,
                errorText: _validationErrors['nameKh'],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'English Name *',
                labelKhmer: 'ឈ្មោះអង់គ្លេស *',
                controller: _nameEnController,
                type: AppTextFieldType.text,
                errorText: _validationErrors['nameEn'],
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Category & Unit ──
              _buildSectionHeader('Category & Unit', 'ប្រភេទ និង ឯកតា'),
              const SizedBox(height: AppSpacing.sm),
              _buildCategoryDropdown(),
              const SizedBox(height: AppSpacing.md),
              _buildUnitDropdown(),

              const SizedBox(height: AppSpacing.lg),

              // ── Pricing Section ──
              _buildSectionHeader('Pricing', 'តម្លៃ'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Cost Price',
                      labelKhmer: 'តម្លៃដើម',
                      controller: _costPriceController,
                      type: AppTextFieldType.number,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Retail Price *',
                      labelKhmer: 'តម្លៃលក់ *',
                      controller: _retailPriceController,
                      type: AppTextFieldType.number,
                      errorText: _validationErrors['retailPrice'],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                label: 'Wholesale Price',
                labelKhmer: 'តម្លៃដុំ',
                controller: _wholesalePriceController,
                type: AppTextFieldType.number,
              ),
              _buildProfitIndicator(),

              const SizedBox(height: AppSpacing.lg),

              // ── Stock Section ──
              _buildSectionHeader('Stock', 'ស្តុក'),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: AppTextField(
                      label: 'Current Stock',
                      labelKhmer: 'ស្តុកបច្ចុប្បន្ន',
                      controller: _stockController,
                      type: AppTextFieldType.number,
                      errorText: _validationErrors['stock'],
                      enabled: !widget.isEditing,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: AppTextField(
                      label: 'Low Stock Alert',
                      labelKhmer: 'ការជូនដំណឹងស្តុកទាប',
                      controller: _lowStockController,
                      type: AppTextFieldType.number,
                      errorText: _validationErrors['lowStockThreshold'],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.lg),

              // ── Toggles ──
              _buildSectionHeader('Settings', 'ការកំណត់'),
              const SizedBox(height: AppSpacing.sm),
              SwitchListTile(
                title: Text('Featured Product',
                    style: AppTextStyles.bodyMedium),
                subtitle: Text('ផលិតផលពិសេស',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                value: _isFeatured,
                activeColor: AppColors.accent,
                onChanged: (v) => setState(() => _isFeatured = v),
              ),
              SwitchListTile(
                title: Text('Active', style: AppTextStyles.bodyMedium),
                subtitle: Text('សកម្ម',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary)),
                value: _isActive,
                activeColor: AppColors.success,
                onChanged: (v) => setState(() => _isActive = v),
              ),

              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String titleEn, String titleKh) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleEn,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          titleKh,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final bloc = context.read<ProductBloc>();
    final state = bloc.state;
    final categories = state is ProductsLoaded ? state.categories : <Category>[];

    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: InputDecoration(
        labelText: 'Category',
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
      items: [
        const DropdownMenuItem(
          value: null,
          child: Text('No Category'),
        ),
        ...categories.map(
          (c) => DropdownMenuItem(
            value: c.id,
            child: Text('${c.nameKh} (${c.nameEn})'),
          ),
        ),
      ],
      onChanged: (v) => setState(() => _selectedCategoryId = v),
    );
  }

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      decoration: InputDecoration(
        labelText: 'Unit',
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
      ),
      items: _units
          .map((u) => DropdownMenuItem(value: u, child: Text(u)))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _selectedUnit = v);
      },
    );
  }

  Widget _buildProfitIndicator() {
    final cost = double.tryParse(_costPriceController.text) ?? 0;
    final retail = double.tryParse(_retailPriceController.text) ?? 0;

    if (retail <= 0) return const SizedBox.shrink();

    final profit = retail - cost;
    final margin = (profit / retail) * 100;
    final isWarning = retail <= cost;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isWarning ? AppColors.warningLight : AppColors.successLight,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
        ),
        child: Row(
          children: [
            Icon(
              isWarning ? Icons.warning_amber : Icons.trending_up,
              size: 18,
              color: isWarning ? AppColors.warning : AppColors.success,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Profit: ${profit.toStringAsFixed(0)}R (${margin.toStringAsFixed(1)}%)',
              style: AppTextStyles.labelSmall.copyWith(
                color: isWarning ? AppColors.warning : AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
