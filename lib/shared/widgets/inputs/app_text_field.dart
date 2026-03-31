import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// Keyboard type for AppTextField
enum AppTextFieldType {
  /// Regular text input
  text,

  /// Email input
  email,

  /// Number input (prices, quantities)
  number,

  /// Phone number input
  phone,

  /// Password input (obscured)
  password,

  /// Search input
  search,

  /// Multiline text
  multiline,
}

/// KhmerBiz POS App TextField
///
/// Customized text field with Khmer keyboard support.
///
/// Features:
/// - Khmer-friendly input (no autocorrect issues)
/// - Prefix icon slot
/// - Suffix action slot
/// - Bilingual error messages
/// - Custom input formatters
///
/// Usage:
/// ```dart
/// // Regular text field
/// AppTextField(
///   label: 'Product Name',
///   labelKhmer: 'ឈ្មោះផលិតផល',
///   type: AppTextFieldType.text,
///   onChanged: (value) => _updateName(value),
/// )
///
/// // Price input
/// AppTextField(
///   label: 'Price',
///   labelKhmer: 'តម្លៃ',
///   type: AppTextFieldType.number,
///   prefix: '៛',
///   onChanged: (value) => _updatePrice(value),
/// )
///
/// // Search field
/// AppTextField(
///   type: AppTextFieldType.search,
///   hintText: 'Search products...',
///   hintTextKhmer: 'ស្វែងរកផលិតផល...',
///   onChanged: (value) => _search(value),
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// Creates an [AppTextField].
  const AppTextField({
    super.key,
    this.label,
    this.labelKhmer,
    this.type = AppTextFieldType.text,
    this.hintText,
    this.hintTextKhmer,
    this.helperText,
    this.helperTextKhmer,
    this.errorText,
    this.errorTextKhmer,
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.prefixIcon,
    this.prefixText,
    this.suffixIcon,
    this.suffixWidget,
    this.isRequired = false,
    this.isDisabled = false,
    this.showClearButton = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.focusNode,
    this.controller,
    this.autofocus = false,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.contentPadding,
  });

  /// Field label (English)
  final String? label;

  /// Field label (Khmer)
  final String? labelKhmer;

  /// Field type
  final AppTextFieldType type;

  /// Hint text (English)
  final String? hintText;

  /// Hint text (Khmer)
  final String? hintTextKhmer;

  /// Helper text (English)
  final String? helperText;

  /// Helper text (Khmer)
  final String? helperTextKhmer;

  /// Error text (English)
  final String? errorText;

  /// Error text (Khmer)
  final String? errorTextKhmer;

  /// Current value
  final String? value;

  /// Callback when value changes
  final ValueChanged<String>? onChanged;

  /// Callback when submitted (done action)
  final ValueChanged<String>? onSubmitted;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Prefix text (e.g., currency symbol)
  final String? prefixText;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix widget (e.g., clear button)
  final Widget? suffixWidget;

  /// Whether field is required
  final bool isRequired;

  /// Whether field is disabled
  final bool isDisabled;

  /// Whether to show clear button
  final bool showClearButton;

  /// Maximum lines (for multiline)
  final int maxLines;

  /// Minimum lines (for multiline)
  final int minLines;

  /// Maximum length
  final int? maxLength;

  /// Custom input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Focus node
  final FocusNode? focusNode;

  /// Text controller
  final TextEditingController? controller;

  /// Auto-focus
  final bool autofocus;

  /// Obscure text (for password)
  final bool obscureText;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<AppTextField> createState() => _AppTextFieldState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', label));
    properties.add(StringProperty('labelKhmer', labelKhmer));
    properties.add(EnumProperty<AppTextFieldType>('type', type));
    properties.add(StringProperty('hintText', hintText));
    properties.add(StringProperty('hintTextKhmer', hintTextKhmer));
    properties.add(StringProperty('helperText', helperText));
    properties.add(StringProperty('helperTextKhmer', helperTextKhmer));
    properties.add(StringProperty('errorText', errorText));
    properties.add(StringProperty('errorTextKhmer', errorTextKhmer));
    properties.add(StringProperty('value', value));
    properties.add(
      ObjectFlagProperty<ValueChanged<String>?>.has('onChanged', onChanged),
    );
    properties.add(
      ObjectFlagProperty<ValueChanged<String>?>.has(
        'onSubmitted',
        onSubmitted,
      ),
    );
    properties.add(DiagnosticsProperty<IconData?>('prefixIcon', prefixIcon));
    properties.add(StringProperty('prefixText', prefixText));
    properties.add(DiagnosticsProperty<IconData?>('suffixIcon', suffixIcon));
    properties.add(DiagnosticsProperty<bool>('isRequired', isRequired));
    properties.add(DiagnosticsProperty<bool>('isDisabled', isDisabled));
    properties
        .add(DiagnosticsProperty<bool>('showClearButton', showClearButton));
    properties.add(IntProperty('maxLines', maxLines));
    properties.add(IntProperty('minLines', minLines));
    properties.add(IntProperty('maxLength', maxLength));
    properties.add(
      IterableProperty<TextInputFormatter>(
        'inputFormatters',
        inputFormatters,
      ),
    );
    properties.add(DiagnosticsProperty<FocusNode?>('focusNode', focusNode));
    properties.add(
      DiagnosticsProperty<TextEditingController?>('controller', controller),
    );
    properties.add(DiagnosticsProperty<bool>('autofocus', autofocus));
    properties.add(DiagnosticsProperty<bool>('obscureText', obscureText));
    properties.add(
      EnumProperty<TextCapitalization>(
        'textCapitalization',
        textCapitalization,
      ),
    );
    properties.add(
      DiagnosticsProperty<EdgeInsetsGeometry?>(
        'contentPadding',
        contentPadding,
      ),
    );
  }
}

class _AppTextFieldState extends State<AppTextField> {
  late TextEditingController _controller;
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.value);
    _obscureText =
        widget.type == AppTextFieldType.password || widget.obscureText;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (widget.label != null || widget.labelKhmer != null) ...[
          _buildLabel(),
          const SizedBox(height: AppSpacing.xs),
        ],

        // Text field
        TextFormField(
          controller: _controller,
          focusNode: widget.focusNode,
          enabled: !widget.isDisabled,
          autofocus: widget.autofocus,
          obscureText: _obscureText,
          textCapitalization: widget.textCapitalization,
          maxLines:
              widget.type == AppTextFieldType.multiline ? widget.maxLines : 1,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          inputFormatters: _getInputFormatters(),
          keyboardType: _getKeyboardType(),
          textInputAction: _getTextInputAction(),
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          style: const TextStyle(
            fontFamily: 'Kantumruy Pro',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            height: 1.5,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintTextKhmer ?? widget.hintText,
            hintStyle: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 16,
              fontWeight: FontWeight.normal,
              height: 1.5,
              color: AppColors.textHint,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, size: 20, color: AppColors.textHint)
                : widget.prefixText != null
                    ? Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.sm),
                        child: Text(
                          widget.prefixText!,
                          style: const TextStyle(
                            fontFamily: 'Roboto Mono',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : null,
            suffixIcon: _buildSuffixIcon(),
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(
                  horizontal: AppSpacing.base,
                  vertical: AppSpacing.md,
                ),
            isDense: true,
          ),
        ),

        // Helper/Error text
        if (widget.errorText != null ||
            widget.errorTextKhmer != null ||
            widget.helperText != null ||
            widget.helperTextKhmer != null) ...[
          const SizedBox(height: AppSpacing.xs),
          _buildHelperText(),
        ],
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      children: [
        if (widget.labelKhmer != null) ...[
          Text(
            widget.labelKhmer!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
        ],
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: const TextStyle(
              fontFamily: 'Kantumruy Pro',
              fontSize: 13,
              fontWeight: FontWeight.normal,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
        if (widget.isRequired) ...[
          const SizedBox(width: AppSpacing.xs),
          const Text(
            '*',
            style: TextStyle(
              color: AppColors.error,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.suffixWidget != null) {
      return widget.suffixWidget;
    }

    if (widget.showClearButton && _controller.text.isNotEmpty) {
      return IconButton(
        icon: const Icon(Icons.clear, size: 20),
        tooltip: 'Clear text',
        onPressed: () {
          _controller.clear();
          widget.onChanged?.call('');
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    if (widget.type == AppTextFieldType.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          size: 20,
        ),
        tooltip: _obscureText ? 'Show password' : 'Hide password',
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    if (widget.suffixIcon != null) {
      return Icon(widget.suffixIcon, size: 20, color: AppColors.textHint);
    }

    return null;
  }

  Widget _buildHelperText() {
    final isError = widget.errorText != null || widget.errorTextKhmer != null;

    return Text(
      widget.errorTextKhmer ??
          widget.errorText ??
          widget.helperTextKhmer ??
          widget.helperText ??
          '',
      style: TextStyle(
        fontFamily: 'Kantumruy Pro',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
        color: isError ? AppColors.error : AppColors.textHint,
      ),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.type) {
      case AppTextFieldType.email:
        return TextInputType.emailAddress;
      case AppTextFieldType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case AppTextFieldType.phone:
        return TextInputType.phone;
      case AppTextFieldType.password:
        return TextInputType.visiblePassword;
      case AppTextFieldType.search:
        return TextInputType.text;
      case AppTextFieldType.multiline:
        return TextInputType.multiline;
      default:
        return TextInputType.text;
    }
  }

  TextInputAction _getTextInputAction() {
    if (widget.type == AppTextFieldType.multiline) {
      return TextInputAction.newline;
    }
    return widget.onSubmitted != null
        ? TextInputAction.done
        : TextInputAction.next;
  }

  List<TextInputFormatter>? _getInputFormatters() {
    final formatters =
        widget.inputFormatters?.toList() ?? <TextInputFormatter>[];

    if (widget.maxLength != null) {
      formatters.add(LengthLimitingTextInputFormatter(widget.maxLength));
    }

    if (widget.type == AppTextFieldType.number) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
      );
    }

    if (widget.type == AppTextFieldType.phone) {
      formatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s()]')),
      );
    }

    return formatters.isNotEmpty ? formatters : null;
  }
}
