import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Callback for digit tapped
typedef OnDigitTapped = void Function(String digit);

/// Callback for backspace
typedef OnBackspace = void Function();

/// Callback for confirm
typedef OnConfirm = void Function();

/// KhmerBiz POS NumPad
///
/// 4×3 numeric keypad for PIN entry, quantity input, cash received input.
///
/// Features:
/// - 72dp minimum button size (critical for accurate input)
/// - Haptic feedback on each press
/// - Hold to repeat (after 500ms hold, repeats every 200ms)
/// - Decimal point support (optional)
/// - Confirm button (optional)
///
/// Usage:
/// ```dart
/// // PIN entry
/// NumPad(
///   onDigitTapped: (digit) => _appendDigit(digit),
///   onBackspace: () => _removeDigit(),
///   onConfirm: () => _submitPin(),
/// )
///
/// // Quantity input (no decimal)
/// NumPad(
///   decimalAllowed: false,
///   onDigitTapped: (digit) => _updateQuantity(digit),
///   onBackspace: () => _clearQuantity(),
/// )
/// ```
class NumPad extends StatefulWidget {
  /// Creates a [NumPad].
  const NumPad({
    super.key,
    this.onDigitTapped,
    this.onBackspace,
    this.onClear,
    this.onConfirm,
    this.decimalAllowed = true,
    this.showConfirm = false,
    this.confirmLabel,
    this.buttonSize,
    this.enabled = true,
    this.showZero = true,
  });

  /// Callback when digit is tapped
  final OnDigitTapped? onDigitTapped;

  /// Callback when backspace is tapped
  final OnBackspace? onBackspace;

  /// Callback when backspace is held (clear)
  final VoidCallback? onClear;

  /// Callback when confirm is tapped
  final OnConfirm? onConfirm;

  /// Whether decimal point is allowed
  final bool decimalAllowed;

  /// Whether to show confirm button
  final bool showConfirm;

  /// Confirm button label
  final String? confirmLabel;

  /// Button size (default: 72dp)
  final double? buttonSize;

  /// Whether buttons are enabled
  final bool enabled;

  /// Show zero button (default: true)
  final bool showZero;

  @override
  State<NumPad> createState() => _NumPadState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<OnDigitTapped?>.has('onDigitTapped', onDigitTapped),
    );
    properties
        .add(ObjectFlagProperty<OnBackspace?>.has('onBackspace', onBackspace));
    properties.add(ObjectFlagProperty<OnConfirm?>.has('onConfirm', onConfirm));
    properties.add(DiagnosticsProperty<bool>('decimalAllowed', decimalAllowed));
    properties.add(DiagnosticsProperty<bool>('showConfirm', showConfirm));
    properties.add(StringProperty('confirmLabel', confirmLabel));
    properties.add(DoubleProperty('buttonSize', buttonSize));
    properties.add(DiagnosticsProperty<bool>('enabled', enabled));
    properties.add(DiagnosticsProperty<bool>('showZero', showZero));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onClear', onClear));
  }
}

class _NumPadState extends State<NumPad> {
  Timer? _holdTimer;
  bool _isHolding = false;
  String _holdingDigit = '';

  @override
  void dispose() {
    _holdTimer?.cancel();
    super.dispose();
  }

  void _handleDigitTap(String digit) {
    if (!widget.enabled) return;

    HapticFeedback.lightImpact();
    widget.onDigitTapped?.call(digit);
  }

  void _handleDigitLongPressStart(String digit) {
    if (!widget.enabled) return;

    setState(() {
      _isHolding = true;
      _holdingDigit = digit;
    });

    // Initial delay before repeat
    _holdTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isHolding && mounted) {
        _handleDigitTap(digit);
        // Continue repeating every 200ms
        _holdTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
          if (!_isHolding || !mounted) {
            timer.cancel();
          } else {
            _handleDigitTap(digit);
          }
        });
      }
    });
  }

  void _handleDigitLongPressEnd() {
    setState(() {
      _isHolding = false;
      _holdingDigit = '';
    });
    _holdTimer?.cancel();
  }

  void _handleBackspace() {
    if (!widget.enabled) return;

    HapticFeedback.lightImpact();
    widget.onBackspace?.call();
  }

  void _handleClear() {
    if (!widget.enabled) return;

    HapticFeedback.mediumImpact();
    if (widget.onClear != null) {
      widget.onClear?.call();
    } else {
      // Fallback: repeat backspace if no onClear provided
      _holdTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!_isHolding || !mounted) {
          timer.cancel();
        } else {
          _handleBackspace();
        }
      });
    }
  }

  void _handleBackspaceLongPressStart() {
    if (!widget.enabled) return;
    setState(() => _isHolding = true);
    _holdTimer = Timer(const Duration(milliseconds: 500), () {
      if (_isHolding && mounted) {
        _handleClear();
      }
    });
  }

  void _handleBackspaceLongPressEnd() {
    setState(() => _isHolding = false);
    _holdTimer?.cancel();
  }

  void _handleConfirm() {
    if (!widget.enabled) return;

    HapticFeedback.mediumImpact();
    widget.onConfirm?.call();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.buttonSize ?? AppSpacing.numpadKeySize;

    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDigitButton('1', size: buttonSize),
            _buildDigitButton('2', size: buttonSize),
            _buildDigitButton('3', size: buttonSize),
          ],
        ),
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDigitButton('4', size: buttonSize),
            _buildDigitButton('5', size: buttonSize),
            _buildDigitButton('6', size: buttonSize),
          ],
        ),
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildDigitButton('7', size: buttonSize),
            _buildDigitButton('8', size: buttonSize),
            _buildDigitButton('9', size: buttonSize),
          ],
        ),
        // Row 4: ., 0, backspace/confirm
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Decimal point (if allowed)
            if (widget.decimalAllowed)
              _buildDigitButton('.', size: buttonSize)
            else
              SizedBox(width: buttonSize),

            // Zero
            if (widget.showZero)
              _buildDigitButton('0', size: buttonSize)
            else
              SizedBox(width: buttonSize),

            // Backspace or Confirm
            if (widget.showConfirm && widget.onConfirm != null)
              _buildConfirmButton(size: buttonSize)
            else
              _buildBackspaceButton(size: buttonSize),
          ],
        ),
      ],
    );
  }

  Widget _buildDigitButton(String digit, {required double size}) {
    final isHolding = _isHolding && _holdingDigit == digit;

    return GestureDetector(
      onTap: () => _handleDigitTap(digit),
      onTapDown: (_) => HapticFeedback.lightImpact(),
      onLongPressStart: (_) => _handleDigitLongPressStart(digit),
      onLongPressEnd: (_) => _handleDigitLongPressEnd(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isHolding ? AppColors.primaryLight : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontFamily: 'Roboto Mono',
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton({required double size}) {
    return Semantics(
      button: true,
      label: 'Backspace',
      onTap: _handleBackspace,
      child: Tooltip(
        message: 'Backspace',
        child: GestureDetector(
          onTap: _handleBackspace,
          onTapDown: (_) => HapticFeedback.lightImpact(),
          onLongPressStart: (_) => _handleBackspaceLongPressStart(),
          onLongPressEnd: (_) => _handleBackspaceLongPressEnd(),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
              border: Border.all(
                color: AppColors.border,
              ),
            ),
            child: const Icon(
              Icons.backspace_outlined,
              size: 28,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton({required double size}) {
    return GestureDetector(
      onTap: _handleConfirm,
      onTapDown: (_) => HapticFeedback.mediumImpact(),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Center(
          child: Text(
            widget.confirmLabel ?? 'Confirm',
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.onPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

/// Compact NumPad for smaller spaces
class CompactNumPad extends StatelessWidget {
  /// Creates a [CompactNumPad].
  const CompactNumPad({
    super.key,
    this.onDigitTapped,
    this.onBackspace,
    this.onClear,
    this.onConfirm,
    this.decimalAllowed = true,
    this.showConfirm = false,
  });
  /// Callback when digit is tapped.
  final OnDigitTapped? onDigitTapped;

  /// Callback when backspace is tapped.
  final OnBackspace? onBackspace;

  /// Callback when backspace is held (clear).
  final VoidCallback? onClear;

  /// Callback when confirm is tapped.
  final OnConfirm? onConfirm;

  /// Whether decimal point is allowed.
  final bool decimalAllowed;

  /// Whether to show confirm button.
  final bool showConfirm;

  @override
  Widget build(BuildContext context) {
    return NumPad(
      onDigitTapped: onDigitTapped,
      onBackspace: onBackspace,
      onClear: onClear,
      onConfirm: onConfirm,
      decimalAllowed: decimalAllowed,
      showConfirm: showConfirm,
      buttonSize: 56,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      ObjectFlagProperty<OnDigitTapped?>.has('onDigitTapped', onDigitTapped),
    );
    properties
        .add(ObjectFlagProperty<OnBackspace?>.has('onBackspace', onBackspace));
    properties.add(ObjectFlagProperty<OnConfirm?>.has('onConfirm', onConfirm));
    properties.add(DiagnosticsProperty<bool>('decimalAllowed', decimalAllowed));
    properties.add(DiagnosticsProperty<bool>('showConfirm', showConfirm));
    properties.add(ObjectFlagProperty<VoidCallback?>.has('onClear', onClear));
  }
}

/// NumPad with display for showing entered value
class NumPadWithDisplay extends StatefulWidget {
  /// Creates a [NumPadWithDisplay].
  const NumPadWithDisplay({
    super.key,
    this.initialValue,
    this.label,
    this.labelKhmer,
    this.onDigitTapped,
    this.onBackspace,
    this.onConfirm,
    this.decimalAllowed = true,
    this.showConfirm = true,
    this.confirmLabel,
    this.maxLength,
  });
  /// Initial numeric value.
  final String? initialValue;

  /// English label for the display.
  final String? label;

  /// Khmer label for the display.
  final String? labelKhmer;

  /// Callback when digit is tapped.
  final OnDigitTapped? onDigitTapped;

  /// Callback when backspace is tapped.
  final OnBackspace? onBackspace;

  /// Callback when confirm is tapped.
  final OnConfirm? onConfirm;

  /// Whether decimal point is allowed.
  final bool decimalAllowed;

  /// Whether to show confirm button.
  final bool showConfirm;

  /// Custom confirm button label.
  final String? confirmLabel;

  /// Maximum number of digits allowed.
  final int? maxLength;

  @override
  State<NumPadWithDisplay> createState() => _NumPadWithDisplayState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('initialValue', initialValue));
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('labelKhmer', labelKhmer));
    properties.add(
      ObjectFlagProperty<OnDigitTapped?>.has('onDigitTapped', onDigitTapped),
    );
    properties
        .add(ObjectFlagProperty<OnBackspace?>.has('onBackspace', onBackspace));
    properties.add(ObjectFlagProperty<OnConfirm?>.has('onConfirm', onConfirm));
    properties.add(DiagnosticsProperty<bool>('decimalAllowed', decimalAllowed));
    properties.add(DiagnosticsProperty<bool>('showConfirm', showConfirm));
    properties.add(StringProperty('confirmLabel', confirmLabel));
    properties.add(IntProperty('maxLength', maxLength));
  }
}

class _NumPadWithDisplayState extends State<NumPadWithDisplay> {
  String _value = '';

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? '';
  }

  void _appendDigit(String digit) {
    // Prevent multiple decimal points
    if (digit == '.' && _value.contains('.')) {
      return;
    }

    // Check max length
    if (widget.maxLength != null && _value.length >= widget.maxLength!) {
      return;
    }

    setState(() {
      _value = '$_value$digit';
    });
    widget.onDigitTapped?.call(digit);
  }

  void _removeDigit() {
    if (_value.isNotEmpty) {
      setState(() {
        _value = _value.substring(0, _value.length - 1);
      });
      widget.onBackspace?.call();
    }
  }

  void _clearAll() {
    setState(() {
      _value = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Display
        _buildDisplay(),
        const SizedBox(height: AppSpacing.lg),
        // Numpad
        NumPad(
          onDigitTapped: _appendDigit,
          onBackspace: _removeDigit,
          onClear: _clearAll,
          onConfirm: widget.onConfirm,
          decimalAllowed: widget.decimalAllowed,
          showConfirm: widget.showConfirm,
          confirmLabel: widget.confirmLabel,
        ),
      ],
    );
  }

  Widget _buildDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLarge),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (widget.label != null || widget.labelKhmer != null) ...[
            Row(
              children: [
                if (widget.labelKhmer != null) ...[
                  Text(
                    widget.labelKhmer!,
                    style: const TextStyle(
                      fontFamily: 'Kantumruy Pro',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                if (widget.label != null)
                  Text(
                    widget.label!,
                    style: const TextStyle(
                      fontFamily: 'Kantumruy Pro',
                      fontSize: 13,
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          // Value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _value.isEmpty ? '---' : _value,
                  style: TextStyle(
                    fontFamily: 'Roboto Mono',
                    fontSize: _value.length > 12 ? 24 : 32,
                    fontWeight: FontWeight.bold,
                    color: _value.isEmpty
                        ? AppColors.textHint
                        : AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (_value.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: _clearAll,
                  color: AppColors.textHint,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
