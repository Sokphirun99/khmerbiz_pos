import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Cart item data model
class CartItemData {
  const CartItemData({
    required this.id,
    required this.productId,
    required this.name,
    required this.unitPriceKHR,
    required this.quantity,
    this.nameKhmer,
    this.unitPriceUSD,
    this.discount,
    this.note,
  });
  final String id;
  final String productId;
  final String name;
  final String? nameKhmer;
  final double unitPriceKHR;
  final double? unitPriceUSD;
  final int quantity;
  final double? discount;
  final String? note;

  /// Get line total in KHR
  double get lineTotalKHR {
    final total = unitPriceKHR * quantity;
    return discount != null ? total - discount! : total;
  }

  /// Get line total in USD
  double? get lineTotalUSD {
    if (unitPriceUSD == null) return null;
    final total = unitPriceUSD! * quantity;
    return discount != null ? total - (discount! / 4100) : total;
  }
}

/// Quantity stepper callback
typedef OnQuantityChanged = void Function(int newQuantity);

/// KhmerBiz POS Cart Item Tile
///
/// List tile for cart items with quantity stepper.
///
/// Features:
/// - Bilingual name display (Khmer + English)
/// - Large quantity stepper (+/- 40dp buttons)
/// - Unit price and line total
/// - Swipe-to-delete with red background
/// - Hold to increase quantity (after 500ms)
///
/// Usage:
/// ```dart
/// CartItemTile(
///   item: CartItemData(
///     id: '1',
///     productId: 'p1',
///     name: 'Coffee',
///     nameKhmer: 'កាហ្វេ',
///     unitPriceKHR: 5000,
///     unitPriceUSD: 1.25,
///     quantity: 2,
///   ),
///   onQuantityChanged: (qty) => _updateQuantity(itemId, qty),
///   onRemoved: () => _removeFromCart(itemId),
/// )
/// ```
class CartItemTile extends StatefulWidget {
  const CartItemTile({
    required this.item,
    super.key,
    this.onQuantityChanged,
    this.onRemoved,
    this.onTap,
    this.showUSD = true,
    this.minQuantity = 1,
    this.maxQuantity = 0,
  });

  /// Cart item data
  final CartItemData item;

  /// Callback when quantity changes
  final OnQuantityChanged? onQuantityChanged;

  /// Callback when item is removed (swipe)
  final VoidCallback? onRemoved;

  /// Callback when item is tapped
  final VoidCallback? onTap;

  /// Show USD price
  final bool showUSD;

  /// Minimum quantity (default: 1)
  final int minQuantity;

  /// Maximum quantity (0 = unlimited)
  final int maxQuantity;

  @override
  State<CartItemTile> createState() => _CartItemTileState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<CartItemData>('item', item));
    properties.add(ObjectFlagProperty<OnQuantityChanged?>.has(
        'onQuantityChanged', onQuantityChanged,),);
    properties
        .add(ObjectFlagProperty<VoidCallback?>.has('onRemoved', onRemoved));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('showUSD', showUSD));
    properties.add(IntProperty('minQuantity', minQuantity));
    properties.add(IntProperty('maxQuantity', maxQuantity));
  }
}

class _CartItemTileState extends State<CartItemTile> {
  bool _isIncreasing = false;
  bool _isDecreasing = false;
  Timer? _holdTimer;

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _startHoldIncrease() {
    setState(() => _isIncreasing = true);
    _holdTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isIncreasing && mounted) {
        _increaseQuantity();
        // Continue increasing every 200ms
        _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (!_isIncreasing || !mounted) {
            timer.cancel();
          } else {
            _increaseQuantity();
          }
        });
      }
    });
  }

  void _startHoldDecrease() {
    setState(() => _isDecreasing = true);
    _holdTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isDecreasing && mounted) {
        _decreaseQuantity();
        // Continue decreasing every 200ms
        _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (!_isDecreasing || !mounted) {
            timer.cancel();
          } else {
            _decreaseQuantity();
          }
        });
      }
    });
  }

  void _stopHold() {
    setState(() {
      _isIncreasing = false;
      _isDecreasing = false;
    });
    _holdTimer?.cancel();
  }

  void _increaseQuantity() {
    if (widget.maxQuantity == 0 || widget.item.quantity < widget.maxQuantity) {
      widget.onQuantityChanged?.call(widget.item.quantity + 1);
    }
  }

  void _decreaseQuantity() {
    if (widget.item.quantity > widget.minQuantity) {
      widget.onQuantityChanged?.call(widget.item.quantity - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 28,
        ),
      ),
      confirmDismiss: (direction) async {
        // Show confirmation dialog
        return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Remove Item?'),
                content: Text(
                    'Remove "${widget.item.nameKhmer ?? widget.item.name}" from cart?',),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.error,
                    ),
                    child: const Text('Remove'),
                  ),
                ],
              ),
            ) ??
            false;
      },
      onDismissed: (direction) {
        widget.onRemoved?.call();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: AppSpacing.listItemHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base,
            vertical: AppSpacing.sm,
          ),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: AppColors.divider,
              ),
            ),
          ),
          child: Row(
            children: [
              // Product info (expanded)
              Expanded(
                child: _buildProductInfo(),
              ),

              // Quantity stepper
              _buildQuantityStepper(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Product name
        if (widget.item.nameKhmer != null) ...[
          Text(
            widget.item.nameKhmer!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.3,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
        ],
        Text(
          widget.item.name,
          style: const TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 13,
            fontWeight: FontWeight.normal,
            height: 1.3,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        const SizedBox(height: AppSpacing.xs),

        // Price info
        Row(
          children: [
            // Unit price
            Text(
              '៛${_formatNumber(widget.item.unitPriceKHR)} × ${widget.item.quantity}',
              style: const TextStyle(
                fontFamily: 'Roboto Mono',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                height: 1.2,
                color: AppColors.textHint,
              ),
            ),

            // Line total
            const SizedBox(width: AppSpacing.md),
            Text(
              '= ៛${_formatNumber(widget.item.lineTotalKHR)}',
              style: const TextStyle(
                fontFamily: 'Roboto Mono',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                height: 1.2,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        // USD price (optional)
        if (widget.showUSD && widget.item.lineTotalUSD != null) ...[
          const SizedBox(height: 2),
          Text(
            '≈ \$${widget.item.lineTotalUSD!.toStringAsFixed(2)}',
            style: const TextStyle(
              fontFamily: 'Roboto Mono',
              fontSize: 11,
              fontWeight: FontWeight.normal,
              height: 1.2,
              color: AppColors.textHint,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildQuantityStepper() {
    return Row(
      children: [
        // Decrease button
        _buildStepperButton(
          icon: Icons.remove,
          onPressed: widget.item.quantity > widget.minQuantity
              ? () {
                  _decreaseQuantity();
                  _startHoldDecrease();
                }
              : null,
          onLongPressStart: widget.item.quantity > widget.minQuantity
              ? (_) => _startHoldDecrease()
              : null,
          onLongPressEnd: (_) => _stopHold(),
        ),

        // Quantity display
        SizedBox(
          width: 40,
          child: Center(
            child: Text(
              '${widget.item.quantity}',
              style: const TextStyle(
                fontFamily: 'Roboto Mono',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),

        // Increase button
        _buildStepperButton(
          icon: Icons.add,
          onPressed: widget.maxQuantity == 0 ||
                  widget.item.quantity < widget.maxQuantity
              ? () {
                  _increaseQuantity();
                  _startHoldIncrease();
                }
              : null,
          onLongPressStart: widget.maxQuantity == 0 ||
                  widget.item.quantity < widget.maxQuantity
              ? (_) => _startHoldIncrease()
              : null,
          onLongPressEnd: (_) => _stopHold(),
        ),
      ],
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    VoidCallback? onPressed,
    void Function(LongPressStartDetails)? onLongPressStart,
    void Function(LongPressEndDetails)? onLongPressEnd,
  }) {
    return GestureDetector(
      onTap: onPressed,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      child: Container(
        width: AppSpacing.stepperButtonSize,
        height: AppSpacing.stepperButtonSize,
        decoration: BoxDecoration(
          color: onPressed != null ? AppColors.primary : AppColors.border,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color:
              onPressed != null ? AppColors.onPrimary : AppColors.textDisabled,
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    return value.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}
