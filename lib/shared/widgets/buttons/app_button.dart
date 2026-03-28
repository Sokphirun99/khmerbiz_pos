import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Button variants for AppButton
enum AppButtonType {
  /// Primary button: Filled with primary color, used for main CTAs
  primary,

  /// Secondary button: Filled with accent (gold) color, used for secondary CTAs
  secondary,

  /// Ghost button: Transparent with border, used for cancel/back actions
  ghost,

  /// Danger button: Filled with error color, used for delete/void actions
  danger,

  /// Accent button: Filled with accent color, used for special actions
  accent,
}

/// Loading state for AppButton
enum AppButtonState {
  /// Default state: Shows label and/or icon
  defaultState,

  /// Loading state: Shows circular progress indicator
  loading,

  /// Disabled state: Grayed out, non-interactive
  disabled,
}

/// KhmerBiz POS App Button
///
/// A reusable button component with multiple variants and states.
///
/// Features:
/// - 5 button variants (primary, secondary, ghost, danger, accent)
/// - Loading state with progress indicator
/// - Disabled state
/// - Press animation (scale 0.97)
/// - Khmer text support (auto-adjusts height)
/// - Full width or wrap width
/// - Optional icon
///
/// Usage:
/// ```dart
/// // Primary button
/// AppButton(
///   label: 'Add to Cart',
///   onTap: () => _addToCart(),
/// )
///
/// // Loading button
/// AppButton(
///   label: 'Processing...',
///   onTap: () {},
///   isLoading: true,
/// )
///
/// // Danger button with icon
/// AppButton(
///   label: 'Delete',
///   icon: Icons.delete_outline,
///   type: AppButtonType.danger,
///   onTap: () => _delete(),
/// )
/// ```
class AppButton extends StatefulWidget {

  const AppButton({
    super.key,
    required this.label,
    this.labelKhmer,
    this.type = AppButtonType.primary,
    this.state = AppButtonState.defaultState,
    this.onTap,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.textStyle,
  });
  /// Button label (English, required)
  final String label;

  /// Button label (Khmer, optional)
  final String? labelKhmer;

  /// Button type/variant
  final AppButtonType type;

  /// Button state
  final AppButtonState state;

  /// Callback when button is tapped
  final VoidCallback? onTap;

  /// Whether button is in loading state
  final bool isLoading;

  /// Whether button is disabled
  final bool isDisabled;

  /// Optional icon (shown before label)
  final IconData? icon;

  /// Button width: full (default) or wrap
  final bool isFullWidth;

  /// Custom width (overrides isFullWidth if provided)
  final double? width;

  /// Button height (default: 56dp for primary, 48dp for others)
  final double? height;

  /// Custom border radius (default: 8dp)
  final double? borderRadius;

  /// Custom padding
  final EdgeInsetsGeometry? padding;

  /// Custom text style (overrides default)
  final TextStyle? textStyle;

  @override
  State<AppButton> createState() => _AppButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('labelKhmer', labelKhmer));
    properties.add(EnumProperty<AppButtonType>('type', type));
    properties.add(EnumProperty<AppButtonState>('state', state));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
    properties.add(DiagnosticsProperty<bool>('isLoading', isLoading));
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
    properties.add(DiagnosticsProperty<IconData?>('icon', icon));
    properties.add(DiagnosticsProperty<bool>('isFullWidth', isFullWidth));
    properties.add(DoubleProperty('width', width));
    properties.add(DoubleProperty('height', height));
    properties.add(DoubleProperty('borderRadius', borderRadius));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry?>('padding', padding));
    properties.add(DiagnosticsProperty<TextStyle?>('textStyle', textStyle));
  }
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = Tween<double>(begin: 1, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isInteractive => !widget.isLoading && !widget.isDisabled && widget.onTap != null;

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
    final effectiveState = widget.isLoading
        ? AppButtonState.loading
        : widget.isDisabled
            ? AppButtonState.disabled
            : widget.state;

    final buttonHeight = widget.height ??
        (widget.type == AppButtonType.primary ? AppSpacing.buttonHeightPrimary : AppSpacing.buttonHeightSecondary);

    final buttonWidth = widget.width ??
        (widget.isFullWidth ? double.infinity : null);

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
          width: buttonWidth,
          decoration: BoxDecoration(
            color: _getBackgroundColor(effectiveState),
            borderRadius: BorderRadius.circular(widget.borderRadius ?? AppSpacing.radiusMedium),
            border: widget.type == AppButtonType.ghost || widget.type == AppButtonType.secondary
                ? Border.all(
                    color: _getBorderColor(effectiveState),
                    width: 1.5,
                  )
                : null,
            boxShadow: _getShadow(effectiveState),
          ),
          child: Center(
            child: _buildContent(effectiveState),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(AppButtonState state) {
    if (state == AppButtonState.loading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.type == AppButtonType.ghost ? _getBorderColor(state) : _getTextColor(),
          ),
        ),
      );
    }

    // Build label with optional Khmer text
    Widget labelWidget;
    if (widget.labelKhmer != null) {
      labelWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.labelKhmer!,
            style: _getTextStyle(),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '•',
            style: TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 14,
              color: _getTextColor().withOpacity(0.5),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(
              widget.label,
              style: _getTextStyle().copyWith(fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      );
    } else {
      labelWidget = Text(
        widget.label,
        style: _getTextStyle(),
      );
    }

    final content = widget.icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 20),
              const SizedBox(width: AppSpacing.sm),
              labelWidget,
            ],
          )
        : labelWidget;

    return Padding(
      padding: widget.padding ??
          EdgeInsets.symmetric(
            horizontal: widget.icon != null ? AppSpacing.base : AppSpacing.lg,
          ),
      child: content,
    );
  }

  Color _getBackgroundColor(AppButtonState state) {
    if (state == AppButtonState.disabled) {
      return AppColors.border;
    }

    if (state == AppButtonState.loading) {
      return _getLoadingBackgroundColor();
    }

    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return Colors.transparent;
      case AppButtonType.ghost:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.error;
      case AppButtonType.accent:
        return AppColors.accent;
    }
  }

  Color _getLoadingBackgroundColor() {
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return Colors.transparent;
      case AppButtonType.ghost:
        return Colors.transparent;
      case AppButtonType.danger:
        return AppColors.error;
      case AppButtonType.accent:
        return AppColors.accent;
    }
  }

  Color _getBorderColor(AppButtonState state) {
    if (state == AppButtonState.disabled) {
      return AppColors.border;
    }

    if (state == AppButtonState.loading) {
      return _getLoadingBorderColor();
    }

    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.primary;
      case AppButtonType.ghost:
        return AppColors.border;
      case AppButtonType.danger:
        return AppColors.error;
      case AppButtonType.accent:
        return AppColors.accent;
    }
  }

  Color _getLoadingBorderColor() {
    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return AppColors.primary;
      case AppButtonType.ghost:
        return AppColors.border;
      case AppButtonType.danger:
        return AppColors.error;
      case AppButtonType.accent:
        return AppColors.accent;
    }
  }

  Color _getTextColor() {
    if (widget.state == AppButtonState.disabled) {
      return AppColors.textDisabled;
    }

    switch (widget.type) {
      case AppButtonType.primary:
        return AppColors.onPrimary;
      case AppButtonType.secondary:
        return AppColors.primary;
      case AppButtonType.ghost:
        return AppColors.textPrimary;
      case AppButtonType.danger:
        return Colors.white;
      case AppButtonType.accent:
        return AppColors.onAccent;
    }
  }

  TextStyle _getTextStyle() {
    return widget.textStyle ??
        const TextStyle(
          fontFamily: 'Kantumruy Pro',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ).copyWith(color: _getTextColor());
  }

  List<BoxShadow>? _getShadow(AppButtonState state) {
    if (state == AppButtonState.disabled || state == AppButtonState.loading) {
      return null;
    }

    if (widget.type == AppButtonType.primary && !_isPressed) {
      return [
        const BoxShadow(
          color: AppColors.shadow,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];
    }

    return null;
  }
}
