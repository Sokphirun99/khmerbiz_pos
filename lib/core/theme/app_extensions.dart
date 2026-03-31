import 'package:flutter/material.dart';

import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';

/// KhmerBiz POS Theme Extensions
///
/// Custom ThemeExtension classes for values not covered by standard ThemeData.
/// These extensions allow accessing custom theme values via ThemeExtension.of(context).
///
/// Usage:
/// ```dart
/// final colors = Theme.of(context).extension<AppColorExtension>()!;
/// final spacing = Theme.of(context).extension<AppSpacingExtension>()!;
/// ```
final class AppColorExtension extends ThemeExtension<AppColorExtension> {
  /// Creates an [AppColorExtension].
  const AppColorExtension({
    required this.primary,
    required this.primaryLight,
    required this.primaryDark,
    required this.accent,
    required this.accentDark,
    required this.accentLight,
    required this.success,
    required this.successLight,
    required this.warning,
    required this.warningLight,
    required this.error,
    required this.errorLight,
    required this.info,
    required this.infoLight,
    required this.surfaceAlt,
    required this.textHint,
    required this.textDisabled,
    required this.border,
    required this.borderLight,
    required this.borderFocus,
    required this.overlay,
    required this.shadow,
    required this.khqrBlue,
    required this.abaRed,
    required this.wingOrange,
    required this.cashGreen,
  });

  /// Light theme color extension
  factory AppColorExtension.light() {
    return const AppColorExtension(
      primary: AppColors.primary,
      primaryLight: AppColors.primaryLight,
      primaryDark: AppColors.primaryDark,
      accent: AppColors.accent,
      accentDark: AppColors.accentDark,
      accentLight: AppColors.accentLight,
      success: AppColors.success,
      successLight: AppColors.successLight,
      warning: AppColors.warning,
      warningLight: AppColors.warningLight,
      error: AppColors.error,
      errorLight: AppColors.errorLight,
      info: AppColors.info,
      infoLight: AppColors.infoLight,
      surfaceAlt: AppColors.surfaceAlt,
      textHint: AppColors.textHint,
      textDisabled: AppColors.textDisabled,
      border: AppColors.border,
      borderLight: AppColors.borderLight,
      borderFocus: AppColors.borderFocus,
      overlay: AppColors.overlay,
      shadow: AppColors.shadow,
      khqrBlue: AppColors.khqrBlue,
      abaRed: AppColors.abaRed,
      wingOrange: AppColors.wingOrange,
      cashGreen: AppColors.cashGreen,
    );
  }

  /// Dark theme color extension
  factory AppColorExtension.dark() {
    return const AppColorExtension(
      primary: AppColors.darkPrimary,
      primaryLight: AppColors.darkPrimaryLight,
      primaryDark: AppColors.primaryDark, // Keep same for consistency
      accent: AppColors.darkAccent,
      accentDark: AppColors.darkAccentDark,
      accentLight: AppColors.darkAccent, // Keep same for consistency
      success: AppColors.darkSuccess,
      successLight: AppColors.darkSuccessLight,
      warning: AppColors.darkWarning,
      warningLight: AppColors.darkWarningLight,
      error: AppColors.darkError,
      errorLight: AppColors.darkErrorLight,
      info: AppColors.darkInfo,
      infoLight: AppColors.darkInfoLight,
      surfaceAlt: AppColors.darkSurfaceAlt,
      textHint: AppColors.darkTextHint,
      textDisabled: AppColors.darkTextSecondary,
      border: AppColors.darkBorder,
      borderLight: AppColors.darkDivider,
      borderFocus: AppColors.darkPrimary,
      overlay: AppColors.darkOverlay,
      shadow: AppColors.shadow, // Keep same for consistency
      khqrBlue: AppColors.khqrBlue,
      abaRed: AppColors.abaRed,
      wingOrange: AppColors.wingOrange,
      cashGreen: AppColors.cashGreen,
    );
  }

  /// Brand colors
  /// Primary brand color
  final Color primary;
  /// Lighter version of primary color
  final Color primaryLight;
  /// Darker version of primary color
  final Color primaryDark;
  /// Accent brand color (gold)
  final Color accent;
  /// Darker version of accent color
  final Color accentDark;
  /// Lighter version of accent color
  final Color accentLight;

  /// Semantic colors
  /// Success state color (green)
  final Color success;
  /// Light success background
  final Color successLight;
  /// Warning state color (orange/yellow)
  final Color warning;
  /// Light warning background
  final Color warningLight;
  /// Error state color (red)
  final Color error;
  /// Light error background
  final Color errorLight;
  /// Info state color (blue)
  final Color info;
  /// Light info background
  final Color infoLight;

  /// Surface colors
  /// Alternative surface color for inputs/cards
  final Color surfaceAlt;

  /// Text colors
  /// Hint/Placeholder text color
  final Color textHint;
  /// Disabled text color
  final Color textDisabled;

  /// Border colors
  /// Standard border color
  final Color border;
  /// Subtle border color
  final Color borderLight;
  /// Focused element border color
  final Color borderFocus;

  /// Overlay colors
  /// Scrim/Barrier overlay color
  final Color overlay;
  /// Shadow/Elevation color
  final Color shadow;

  /// Payment brand colors
  /// KHQR brand blue
  final Color khqrBlue;
  /// ABA bank brand red
  final Color abaRed;
  /// Wing brand orange
  final Color wingOrange;
  /// Cash payment green
  final Color cashGreen;

  @override
  AppColorExtension copyWith({
    Color? primary,
    Color? primaryLight,
    Color? primaryDark,
    Color? accent,
    Color? accentDark,
    Color? accentLight,
    Color? success,
    Color? successLight,
    Color? warning,
    Color? warningLight,
    Color? error,
    Color? errorLight,
    Color? info,
    Color? infoLight,
    Color? surfaceAlt,
    Color? textHint,
    Color? textDisabled,
    Color? border,
    Color? borderLight,
    Color? borderFocus,
    Color? overlay,
    Color? shadow,
    Color? khqrBlue,
    Color? abaRed,
    Color? wingOrange,
    Color? cashGreen,
  }) {
    return AppColorExtension(
      primary: primary ?? this.primary,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      accent: accent ?? this.accent,
      accentDark: accentDark ?? this.accentDark,
      accentLight: accentLight ?? this.accentLight,
      success: success ?? this.success,
      successLight: successLight ?? this.successLight,
      warning: warning ?? this.warning,
      warningLight: warningLight ?? this.warningLight,
      error: error ?? this.error,
      errorLight: errorLight ?? this.errorLight,
      info: info ?? this.info,
      infoLight: infoLight ?? this.infoLight,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      textHint: textHint ?? this.textHint,
      textDisabled: textDisabled ?? this.textDisabled,
      border: border ?? this.border,
      borderLight: borderLight ?? this.borderLight,
      borderFocus: borderFocus ?? this.borderFocus,
      overlay: overlay ?? this.overlay,
      shadow: shadow ?? this.shadow,
      khqrBlue: khqrBlue ?? this.khqrBlue,
      abaRed: abaRed ?? this.abaRed,
      wingOrange: wingOrange ?? this.wingOrange,
      cashGreen: cashGreen ?? this.cashGreen,
    );
  }

  @override
  AppColorExtension lerp(ThemeExtension<AppColorExtension> other, double t) {
    if (other is! AppColorExtension) {
      return this;
    }
    return AppColorExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentDark: Color.lerp(accentDark, other.accentDark, t)!,
      accentLight: Color.lerp(accentLight, other.accentLight, t)!,
      success: Color.lerp(success, other.success, t)!,
      successLight: Color.lerp(successLight, other.successLight, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningLight: Color.lerp(warningLight, other.warningLight, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorLight: Color.lerp(errorLight, other.errorLight, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoLight: Color.lerp(infoLight, other.infoLight, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      khqrBlue: Color.lerp(khqrBlue, other.khqrBlue, t)!,
      abaRed: Color.lerp(abaRed, other.abaRed, t)!,
      wingOrange: Color.lerp(wingOrange, other.wingOrange, t)!,
      cashGreen: Color.lerp(cashGreen, other.cashGreen, t)!,
    );
  }
}

/// Spacing extension for custom spacing values
final class AppSpacingExtension extends ThemeExtension<AppSpacingExtension> {
  /// Creates an [AppSpacingExtension].
  const AppSpacingExtension({
    required this.xs,
    required this.sm,
    required this.md,
    required this.base,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.buttonHeightPrimary,
    required this.buttonHeightSecondary,
    required this.buttonHeightSmall,
    required this.iconButtonSize,
    required this.numpadKeySize,
    required this.productCardWidth,
    required this.productCardHeight,
    required this.categoryPillHeight,
    required this.listItemHeight,
    required this.appBarHeight,
    required this.bottomNavHeight,
    required this.paymentMethodHeight,
    required this.inputFieldHeight,
    required this.stepperButtonSize,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.radiusExtraLarge,
    required this.radiusFull,
    required this.elevation1,
    required this.elevation2,
    required this.elevation3,
    required this.elevation4,
  });

  /// Default spacing extension (same for light and dark)
  factory AppSpacingExtension.defaultSpacing() {
    return const AppSpacingExtension(
      xs: AppSpacing.xs,
      sm: AppSpacing.sm,
      md: AppSpacing.md,
      base: AppSpacing.base,
      lg: AppSpacing.lg,
      xl: AppSpacing.xl,
      xxl: AppSpacing.xxl,
      buttonHeightPrimary: AppSpacing.buttonHeightPrimary,
      buttonHeightSecondary: AppSpacing.buttonHeightSecondary,
      buttonHeightSmall: AppSpacing.buttonHeightSmall,
      iconButtonSize: AppSpacing.iconButtonSize,
      numpadKeySize: AppSpacing.numpadKeySize,
      productCardWidth: AppSpacing.productCardWidth,
      productCardHeight: AppSpacing.productCardHeight,
      categoryPillHeight: AppSpacing.categoryPillHeight,
      listItemHeight: AppSpacing.listItemHeight,
      appBarHeight: AppSpacing.appBarHeight,
      bottomNavHeight: AppSpacing.bottomNavHeight,
      paymentMethodHeight: AppSpacing.paymentMethodHeight,
      inputFieldHeight: AppSpacing.inputFieldHeight,
      stepperButtonSize: AppSpacing.stepperButtonSize,
      radiusSmall: AppSpacing.radiusSmall,
      radiusMedium: AppSpacing.radiusMedium,
      radiusLarge: AppSpacing.radiusLarge,
      radiusExtraLarge: AppSpacing.radiusExtraLarge,
      radiusFull: AppSpacing.radiusFull,
      elevation1: AppSpacing.elevation1,
      elevation2: AppSpacing.elevation2,
      elevation3: AppSpacing.elevation3,
      elevation4: AppSpacing.elevation4,
    );
  }

  /// Base spacing units
  /// 4dp grid unit
  final double xs;
  /// 8dp unit
  final double sm;
  /// 12dp unit
  final double md;
  /// 16dp unit
  final double base;
  /// 24dp unit
  final double lg;
  /// 32dp unit
  final double xl;
  /// 48dp unit
  final double xxl;

  /// Component sizes
  /// Height for primary buttons (56dp)
  final double buttonHeightPrimary;
  /// Height for secondary buttons (48dp)
  final double buttonHeightSecondary;
  /// Height for small buttons (40dp)
  final double buttonHeightSmall;
  /// Square size for icon buttons (48dp)
  final double iconButtonSize;
  /// Square size for numpad keys (72dp)
  final double numpadKeySize;
  /// Standard product card width
  final double productCardWidth;
  /// Standard product card height
  final double productCardHeight;
  /// Height for category filter pills
  final double categoryPillHeight;
  /// Height for standard list items
  final double listItemHeight;
  /// Standard AppBar height
  final double appBarHeight;
  /// Bottom navigation bar height
  final double bottomNavHeight;
  /// Height for payment method selectors
  final double paymentMethodHeight;
  /// Standard input field height
  final double inputFieldHeight;
  /// Square size for quantity stepper buttons
  final double stepperButtonSize;

  /// Border radius
  /// Small border radius (4dp)
  final double radiusSmall;
  /// Medium border radius (8dp)
  final double radiusMedium;
  /// Large border radius (12dp)
  final double radiusLarge;
  /// Extra large border radius (16dp)
  final double radiusExtraLarge;
  /// Circular border radius (999dp)
  final double radiusFull;

  /// Elevation
  /// Elevation level 1 (Resting cards)
  final double elevation1;
  /// Elevation level 2 (Raised elements)
  final double elevation2;
  /// Elevation level 3 (Pressed elements)
  final double elevation3;
  /// Elevation level 4 (Dialogs/Sheets)
  final double elevation4;

  @override
  AppSpacingExtension copyWith({
    double? xs,
    double? sm,
    double? md,
    double? base,
    double? lg,
    double? xl,
    double? xxl,
    double? buttonHeightPrimary,
    double? buttonHeightSecondary,
    double? buttonHeightSmall,
    double? iconButtonSize,
    double? numpadKeySize,
    double? productCardWidth,
    double? productCardHeight,
    double? categoryPillHeight,
    double? listItemHeight,
    double? appBarHeight,
    double? bottomNavHeight,
    double? paymentMethodHeight,
    double? inputFieldHeight,
    double? stepperButtonSize,
    double? radiusSmall,
    double? radiusMedium,
    double? radiusLarge,
    double? radiusExtraLarge,
    double? radiusFull,
    double? elevation1,
    double? elevation2,
    double? elevation3,
    double? elevation4,
  }) {
    return AppSpacingExtension(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      base: base ?? this.base,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      buttonHeightPrimary: buttonHeightPrimary ?? this.buttonHeightPrimary,
      buttonHeightSecondary:
          buttonHeightSecondary ?? this.buttonHeightSecondary,
      buttonHeightSmall: buttonHeightSmall ?? this.buttonHeightSmall,
      iconButtonSize: iconButtonSize ?? this.iconButtonSize,
      numpadKeySize: numpadKeySize ?? this.numpadKeySize,
      productCardWidth: productCardWidth ?? this.productCardWidth,
      productCardHeight: productCardHeight ?? this.productCardHeight,
      categoryPillHeight: categoryPillHeight ?? this.categoryPillHeight,
      listItemHeight: listItemHeight ?? this.listItemHeight,
      appBarHeight: appBarHeight ?? this.appBarHeight,
      bottomNavHeight: bottomNavHeight ?? this.bottomNavHeight,
      paymentMethodHeight: paymentMethodHeight ?? this.paymentMethodHeight,
      inputFieldHeight: inputFieldHeight ?? this.inputFieldHeight,
      stepperButtonSize: stepperButtonSize ?? this.stepperButtonSize,
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      radiusExtraLarge: radiusExtraLarge ?? this.radiusExtraLarge,
      radiusFull: radiusFull ?? this.radiusFull,
      elevation1: elevation1 ?? this.elevation1,
      elevation2: elevation2 ?? this.elevation2,
      elevation3: elevation3 ?? this.elevation3,
      elevation4: elevation4 ?? this.elevation4,
    );
  }

  @override
  AppSpacingExtension lerp(
    ThemeExtension<AppSpacingExtension> other,
    double t,
  ) {
    if (other is! AppSpacingExtension) {
      return this;
    }
    return AppSpacingExtension(
      xs: _lerpDouble(xs, other.xs, t),
      sm: _lerpDouble(sm, other.sm, t),
      md: _lerpDouble(md, other.md, t),
      base: _lerpDouble(base, other.base, t),
      lg: _lerpDouble(lg, other.lg, t),
      xl: _lerpDouble(xl, other.xl, t),
      xxl: _lerpDouble(xxl, other.xxl, t),
      buttonHeightPrimary:
          _lerpDouble(buttonHeightPrimary, other.buttonHeightPrimary, t),
      buttonHeightSecondary:
          _lerpDouble(buttonHeightSecondary, other.buttonHeightSecondary, t),
      buttonHeightSmall:
          _lerpDouble(buttonHeightSmall, other.buttonHeightSmall, t),
      iconButtonSize: _lerpDouble(iconButtonSize, other.iconButtonSize, t),
      numpadKeySize: _lerpDouble(numpadKeySize, other.numpadKeySize, t),
      productCardWidth:
          _lerpDouble(productCardWidth, other.productCardWidth, t),
      productCardHeight:
          _lerpDouble(productCardHeight, other.productCardHeight, t),
      categoryPillHeight:
          _lerpDouble(categoryPillHeight, other.categoryPillHeight, t),
      listItemHeight: _lerpDouble(listItemHeight, other.listItemHeight, t),
      appBarHeight: _lerpDouble(appBarHeight, other.appBarHeight, t),
      bottomNavHeight: _lerpDouble(bottomNavHeight, other.bottomNavHeight, t),
      paymentMethodHeight:
          _lerpDouble(paymentMethodHeight, other.paymentMethodHeight, t),
      inputFieldHeight:
          _lerpDouble(inputFieldHeight, other.inputFieldHeight, t),
      stepperButtonSize:
          _lerpDouble(stepperButtonSize, other.stepperButtonSize, t),
      radiusSmall: _lerpDouble(radiusSmall, other.radiusSmall, t),
      radiusMedium: _lerpDouble(radiusMedium, other.radiusMedium, t),
      radiusLarge: _lerpDouble(radiusLarge, other.radiusLarge, t),
      radiusExtraLarge:
          _lerpDouble(radiusExtraLarge, other.radiusExtraLarge, t),
      radiusFull: _lerpDouble(radiusFull, other.radiusFull, t),
      elevation1: _lerpDouble(elevation1, other.elevation1, t),
      elevation2: _lerpDouble(elevation2, other.elevation2, t),
      elevation3: _lerpDouble(elevation3, other.elevation3, t),
      elevation4: _lerpDouble(elevation4, other.elevation4, t),
    );
  }

  double _lerpDouble(double a, double b, double t) {
    return a + (b - a) * t;
  }
}

/// Extension methods on BuildContext for easy theme access
extension BuildContextThemeExtension on BuildContext {
  /// Get AppColorExtension from theme
  AppColorExtension get appColors {
    return Theme.of(this).extension<AppColorExtension>() ??
        AppColorExtension.light();
  }

  /// Get AppSpacingExtension from theme
  AppSpacingExtension get appSpacing {
    return Theme.of(this).extension<AppSpacingExtension>() ??
        AppSpacingExtension.defaultSpacing();
  }

  /// Check if dark mode is active
  bool get isDarkMode {
    return Theme.of(this).brightness == Brightness.dark;
  }
}
