import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Payment method types supported by KhmerBiz POS
enum PaymentMethodType {
  /// Cash payment
  cash,

  /// KHQR (National KHQR payment system)
  khqr,

  /// Card payment (ABA, ACLEDA, etc.)
  card,

  /// Bank transfer
  bankTransfer,

  /// Wing payment
  wing,
}

/// Payment method button configuration
class PaymentMethodConfig {
  /// Creates a [PaymentMethodConfig].
  const PaymentMethodConfig({
    required this.type,
    required this.label,
    required this.icon,
    this.labelKhmer,
    this.iconColor,
  });

  /// The payment method type.
  final PaymentMethodType type;

  /// The English label for the payment method.
  final String label;

  /// The optional Khmer label for the payment method.
  final String? labelKhmer;

  /// The icon representing the payment method.
  final IconData icon;

  /// The color of the icon.
  final Color? iconColor;

  /// Get configuration for payment method type
  static PaymentMethodConfig fromType(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.cash:
        return const PaymentMethodConfig(
          type: PaymentMethodType.cash,
          label: 'Cash',
          labelKhmer: 'សាច់ប្រាក់',
          icon: Icons.money,
          iconColor: AppColors.success,
        );
      case PaymentMethodType.khqr:
        return const PaymentMethodConfig(
          type: PaymentMethodType.khqr,
          label: 'KHQR',
          labelKhmer: 'KHQR',
          icon: Icons.qr_code_2,
          iconColor: AppColors.primary,
        );
      case PaymentMethodType.card:
        return const PaymentMethodConfig(
          type: PaymentMethodType.card,
          label: 'Card',
          labelKhmer: 'កាត',
          icon: Icons.credit_card,
          iconColor: AppColors.info,
        );
      case PaymentMethodType.bankTransfer:
        return const PaymentMethodConfig(
          type: PaymentMethodType.bankTransfer,
          label: 'Bank Transfer',
          labelKhmer: 'ផ្ទេរតាមធនាគារ',
          icon: Icons.account_balance,
          iconColor: AppColors.accent,
        );
      case PaymentMethodType.wing:
        return const PaymentMethodConfig(
          type: PaymentMethodType.wing,
          label: 'Wing',
          labelKhmer: 'Wing',
          icon: Icons.phone_android,
          iconColor: AppColors.error,
        );
    }
  }
}

/// KhmerBiz POS Payment Method Button
///
/// Large card-style button for payment method selection.
///
/// Features:
/// - 80dp height for easy touch target
/// - Icon + bilingual label (Khmer + English)
/// - Selected state with border and checkmark
/// - Press animation
///
/// Usage:
/// ```dart
/// PaymentMethodButton(
///   method: PaymentMethodType.khqr,
///   isSelected: _selectedMethod == PaymentMethodType.khqr,
///   onTap: () => setState(() => _selectedMethod = PaymentMethodType.khqr),
/// )
/// ```
class PaymentMethodButton extends StatefulWidget {
  /// Creates a [PaymentMethodButton].
  const PaymentMethodButton({
    required this.method,
    super.key,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
    this.height,
    this.showKhmer = true,
  });

  /// Payment method type
  final PaymentMethodType method;

  /// Whether this method is selected
  final bool isSelected;

  /// Callback when button is tapped
  final VoidCallback? onTap;

  /// Whether button is disabled
  final bool isDisabled;

  /// Custom height (default: 80dp)
  final double? height;

  /// Show Khmer label
  final bool showKhmer;

  @override
  State<PaymentMethodButton> createState() => _PaymentMethodButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<PaymentMethodType>('method', method));
    properties.add(DiagnosticsProperty<bool>('isSelected', isSelected));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
    properties.add(DoubleProperty('height', height));
    properties.add(DiagnosticsProperty<bool>('showKhmer', showKhmer));
  }
}

class _PaymentMethodButtonState extends State<PaymentMethodButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isInteractive => !widget.isDisabled && widget.onTap != null;

  void _handleTapDown(TapDownDetails details) {
    if (_isInteractive) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isInteractive) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isInteractive) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTap() {
    if (_isInteractive) {
      widget.onTap?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = PaymentMethodConfig.fromType(widget.method);
    final buttonHeight = widget.height ?? AppSpacing.paymentMethodHeight;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: buttonHeight,
          decoration: BoxDecoration(
            color: _getBackgroundColor(),
            borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
            border: Border.all(
              color: _getBorderColor(),
              width: widget.isSelected ? 2.5 : 1.5,
            ),
            boxShadow: _getShadow(),
          ),
          child: Stack(
            children: [
              // Main content
              Padding(
                padding: const EdgeInsets.all(AppSpacing.base),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getIconBackgroundColor(),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusMedium),
                      ),
                      child: Icon(
                        config.icon,
                        size: 28,
                        color: widget.isDisabled
                            ? AppColors.textDisabled
                            : (config.iconColor ?? AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    // Label
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // English label
                          Text(
                            config.label,
                            style: const TextStyle(
                              fontFamily: 'Kantumruy Pro',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.3,
                            ).copyWith(
                              color: widget.isDisabled
                                  ? AppColors.textDisabled
                                  : AppColors.textPrimary,
                            ),
                          ),
                          if (widget.showKhmer &&
                              config.labelKhmer != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              config.labelKhmer!,
                              style: const TextStyle(
                                fontFamily: 'Kantumruy Pro',
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                height: 1.3,
                              ).copyWith(
                                color: widget.isDisabled
                                    ? AppColors.textDisabled
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Checkmark overlay for selected state
              if (widget.isSelected)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 18,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    if (widget.isDisabled) {
      return AppColors.surfaceAlt;
    }
    return widget.isSelected
        ? AppColors.primaryLight.withValues(alpha: 0.1)
        : AppColors.surface;
  }

  Color _getBorderColor() {
    if (widget.isDisabled) {
      return AppColors.border;
    }
    return widget.isSelected ? AppColors.primary : AppColors.border;
  }

  Color _getIconBackgroundColor() {
    if (widget.isDisabled) {
      return AppColors.border.withValues(alpha: 0.3);
    }
    final config = PaymentMethodConfig.fromType(widget.method);
    return (config.iconColor ?? AppColors.primary).withValues(alpha: 0.1);
  }

  List<BoxShadow>? _getShadow() {
    if (widget.isDisabled || widget.isSelected) {
      return null;
    }
    if (!_isPressed) {
      return [
        BoxShadow(
          color: AppColors.shadow.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }
    return null;
  }
}
