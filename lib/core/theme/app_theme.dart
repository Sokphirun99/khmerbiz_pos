import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:khmerbiz_pos/core/theme/app_colors.dart';
import 'package:khmerbiz_pos/core/theme/app_extensions.dart';
import 'package:khmerbiz_pos/core/theme/app_spacing.dart';
import 'package:khmerbiz_pos/core/theme/app_text_styles.dart';

/// KhmerBiz POS Theme Configuration
///
/// Complete Material 3 theme implementation with:
/// - Light and dark mode support
/// - Khmer typography (Kantumruy Pro)
/// - Cambodian-inspired color palette
/// - POS-optimized component themes
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: AppTheme.light(),
///   darkTheme: AppTheme.dark(),
///   themeMode: ThemeMode.system,
/// )
/// ```
final class AppTheme {
  const AppTheme._();

  /// Get the light theme data.
  ///
  /// Optimized for daytime use in shops with natural lighting.
  /// Warm background (#F5F5F0) reduces eye strain under bright lights.
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.accent,
        onSecondary: AppColors.onAccent,
        secondaryContainer: AppColors.accentLight,
        onSecondaryContainer: AppColors.onAccent,
        tertiary: AppColors.info,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.infoLight,
        onTertiaryContainer: AppColors.info,
        error: AppColors.error,
        onError: Colors.white,
        errorContainer: AppColors.errorLight,
        onErrorContainer: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        surfaceContainerHighest: AppColors.surfaceAlt,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.border,
        outlineVariant: AppColors.borderLight,
        shadow: AppColors.shadow,
        scrim: AppColors.overlay,
        inverseSurface: AppColors.darkSurface,
        onInverseSurface: AppColors.darkTextPrimary,
        inversePrimary: AppColors.darkPrimary,
      ),

      // Typography
      textTheme: createTextTheme(),

      // Font family (default for Latin text)
      fontFamily: 'Noto Sans',

      // Component themes
      appBarTheme: _appBarTheme(),
      cardTheme: _cardTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      filledButtonTheme: _filledButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      iconButtonTheme: _iconButtonTheme(),
      floatingActionButtonTheme: _fabTheme(),
      inputDecorationTheme: _inputDecorationTheme(),
      bottomNavigationBarTheme: _bottomNavTheme(),
      navigationBarTheme: _navigationBarTheme(),
      bottomSheetTheme: _bottomSheetTheme(),
      dialogTheme: _dialogTheme(),
      chipTheme: _chipTheme(),
      dividerTheme: _dividerTheme(),
      listTileTheme: _listTileTheme(),
      badgeTheme: _badgeTheme(),

      // Extensions
      extensions: <ThemeExtension<dynamic>>[
        AppColorExtension.light(),
        AppSpacingExtension.defaultSpacing(),
      ],

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Material defaults
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  /// Get the dark theme data.
  ///
  /// Optimized for night-shift cashiers to reduce eye strain.
  /// Uses true black (#121212) background with elevated surfaces.
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color scheme
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.darkPrimaryLight,
        onPrimaryContainer: AppColors.onPrimary,
        secondary: AppColors.darkAccent,
        onSecondary: AppColors.onAccent,
        secondaryContainer: AppColors.darkAccentDark,
        onSecondaryContainer: AppColors.onAccent,
        tertiary: AppColors.info,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.darkSurfaceAlt,
        onTertiaryContainer: AppColors.darkPrimary,
        error: AppColors.darkError,
        onError: Colors.white,
        errorContainer: AppColors.darkErrorLight,
        onErrorContainer: AppColors.darkError,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceAlt,
        onSurfaceVariant: AppColors.darkTextSecondary,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkDivider,
        shadow: AppColors.shadow,
        scrim: AppColors.darkOverlay,
        inverseSurface: AppColors.surface,
        onInverseSurface: AppColors.textPrimary,
        inversePrimary: AppColors.primary,
      ),

      // Typography
      textTheme: createTextTheme().apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
        decorationColor: AppColors.darkTextPrimary,
      ),

      // Font family (default for Latin text)
      fontFamily: 'Noto Sans',

      // Component themes
      appBarTheme: _appBarThemeDark(),
      cardTheme: _cardThemeDark(),
      elevatedButtonTheme: _elevatedButtonThemeDark(),
      filledButtonTheme: _filledButtonThemeDark(),
      outlinedButtonTheme: _outlinedButtonThemeDark(),
      textButtonTheme: _textButtonThemeDark(),
      iconButtonTheme: _iconButtonThemeDark(),
      floatingActionButtonTheme: _fabThemeDark(),
      inputDecorationTheme: _inputDecorationThemeDark(),
      bottomNavigationBarTheme: _bottomNavThemeDark(),
      navigationBarTheme: _navigationBarThemeDark(),
      bottomSheetTheme: _bottomSheetThemeDark(),
      dialogTheme: _dialogThemeDark(),
      chipTheme: _chipThemeDark(),
      dividerTheme: _dividerThemeDark(),
      listTileTheme: _listTileThemeDark(),
      badgeTheme: _badgeThemeDark(),

      // Extensions
      extensions: <ThemeExtension<dynamic>>[
        AppColorExtension.dark(),
        AppSpacingExtension.defaultSpacing(),
      ],

      // Visual density
      visualDensity: VisualDensity.adaptivePlatformDensity,

      // Material defaults
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME COMPONENT THEMES
  // ═══════════════════════════════════════════════════════════════

  static AppBarTheme _appBarTheme() {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      backgroundColor: AppColors.surface,
      foregroundColor: AppColors.textPrimary,
      surfaceTintColor: AppColors.surface,
      titleTextStyle: AppTextStyles.headlineLarge,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  static CardThemeData _cardTheme() {
    return const CardThemeData(
      elevation: AppSpacing.elevation1,
      shadowColor: AppColors.shadow,
      color: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(AppSpacing.radiusMedium)),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppSpacing.elevation0,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.border,
        disabledForegroundColor: AppColors.textDisabled,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonTheme() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.onAccent,
        disabledBackgroundColor: AppColors.border,
        disabledForegroundColor: AppColors.textDisabled,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textDisabled,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightSecondary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        side: const BorderSide(color: AppColors.border),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        disabledForegroundColor: AppColors.textDisabled,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightSecondary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static IconButtonThemeData _iconButtonTheme() {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        disabledForegroundColor: AppColors.textDisabled,
        minimumSize:
            const Size(AppSpacing.iconButtonSize, AppSpacing.iconButtonSize),
      ),
    );
  }

  static FloatingActionButtonThemeData _fabTheme() {
    return const FloatingActionButtonThemeData(
      elevation: AppSpacing.elevation2,
      backgroundColor: AppColors.accent,
      foregroundColor: AppColors.onAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusLarge)),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceAlt,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textHint,
        height: 1.5,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.error,
        height: 1.5,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      prefixIconColor: AppColors.textHint,
      suffixIconColor: AppColors.textHint,
    );
  }

  static BottomNavigationBarThemeData _bottomNavTheme() {
    return const BottomNavigationBarThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static NavigationBarThemeData _navigationBarTheme() {
    return const NavigationBarThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.surface,
      indicatorColor: AppColors.primaryLight,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme() {
    return const BottomSheetThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      modalBackgroundColor: AppColors.surface,
      modalBarrierColor: AppColors.overlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusExtraLarge),),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static DialogThemeData _dialogTheme() {
    return DialogThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.surface,
      titleTextStyle: AppTextStyles.headlineMedium,
      contentTextStyle: AppTextStyles.bodyMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusLarge)),
      ),
    );
  }

  static ChipThemeData _chipTheme() {
    return ChipThemeData(
      backgroundColor: AppColors.surfaceAlt,
      disabledColor: AppColors.border,
      selectedColor: AppColors.primaryLight,
      secondarySelectedColor: AppColors.primaryLight,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.onPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.categoryPillPadding,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }

  static DividerThemeData _dividerTheme() {
    return const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    );
  }

  static ListTileThemeData _listTileTheme() {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTextStyles.bodyLarge,
      subtitleTextStyle: AppTextStyles.bodyMedium,
      dense: false,
      isThreeLine: false,
    );
  }

  static BadgeThemeData _badgeTheme() {
    return const BadgeThemeData(
      backgroundColor: AppColors.error,
      textColor: Colors.white,
      smallSize: AppSpacing.badgeSizeSmall,
      largeSize: AppSpacing.badgeSizeMedium,
      textStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME COMPONENT THEMES
  // ═══════════════════════════════════════════════════════════════

  static AppBarTheme _appBarThemeDark() {
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      centerTitle: false,
      backgroundColor: AppColors.darkSurface,
      foregroundColor: AppColors.darkTextPrimary,
      surfaceTintColor: AppColors.darkSurface,
      titleTextStyle: AppTextStyles.headlineLarge,
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),
      actionsIconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static CardThemeData _cardThemeDark() {
    return const CardThemeData(
      elevation: AppSpacing.elevation1,
      shadowColor: AppColors.shadow,
      color: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkSurface,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.all(Radius.circular(AppSpacing.radiusMedium)),
      ),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonThemeDark() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: AppSpacing.elevation0,
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.onPrimary,
        disabledBackgroundColor: AppColors.darkBorder,
        disabledForegroundColor: AppColors.darkTextSecondary,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static FilledButtonThemeData _filledButtonThemeDark() {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.darkAccent,
        foregroundColor: AppColors.onAccent,
        disabledBackgroundColor: AppColors.darkBorder,
        disabledForegroundColor: AppColors.darkTextSecondary,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightPrimary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonThemeDark() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        disabledForegroundColor: AppColors.darkTextSecondary,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightSecondary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        side: const BorderSide(color: AppColors.darkBorder),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonThemeDark() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        disabledForegroundColor: AppColors.darkTextSecondary,
        minimumSize:
            const Size(double.infinity, AppSpacing.buttonHeightSecondary),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
      ),
    );
  }

  static IconButtonThemeData _iconButtonThemeDark() {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.darkTextPrimary,
        disabledForegroundColor: AppColors.darkTextSecondary,
        minimumSize:
            const Size(AppSpacing.iconButtonSize, AppSpacing.iconButtonSize),
      ),
    );
  }

  static FloatingActionButtonThemeData _fabThemeDark() {
    return const FloatingActionButtonThemeData(
      elevation: AppSpacing.elevation2,
      backgroundColor: AppColors.darkAccent,
      foregroundColor: AppColors.onAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusLarge)),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationThemeDark() {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurfaceAlt,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      hintStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.darkTextHint,
        height: 1.5,
      ),
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.darkTextSecondary,
        height: 1.5,
      ),
      errorStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.darkError,
        height: 1.5,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkError, width: 2),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      prefixIconColor: AppColors.darkTextHint,
      suffixIconColor: AppColors.darkTextHint,
    );
  }

  static BottomNavigationBarThemeData _bottomNavThemeDark() {
    return const BottomNavigationBarThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.darkPrimary,
      unselectedItemColor: AppColors.darkTextHint,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  static NavigationBarThemeData _navigationBarThemeDark() {
    return const NavigationBarThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.darkSurface,
      indicatorColor: AppColors.darkPrimaryLight,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetThemeDark() {
    return const BottomSheetThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkSurface,
      modalBackgroundColor: AppColors.darkSurface,
      modalBarrierColor: AppColors.darkOverlay,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusExtraLarge),),
      ),
      clipBehavior: Clip.antiAlias,
    );
  }

  static DialogThemeData _dialogThemeDark() {
    return DialogThemeData(
      elevation: AppSpacing.elevation4,
      backgroundColor: AppColors.darkSurface,
      surfaceTintColor: AppColors.darkSurface,
      titleTextStyle: AppTextStyles.headlineMedium,
      contentTextStyle: AppTextStyles.bodyMedium,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(AppSpacing.radiusLarge)),
      ),
    );
  }

  static ChipThemeData _chipThemeDark() {
    return ChipThemeData(
      backgroundColor: AppColors.darkSurfaceAlt,
      disabledColor: AppColors.darkBorder,
      selectedColor: AppColors.darkPrimaryLight,
      secondarySelectedColor: AppColors.darkPrimaryLight,
      labelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.darkTextPrimary,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.onPrimary,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.categoryPillPadding,
        vertical: AppSpacing.xs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }

  static DividerThemeData _dividerThemeDark() {
    return const DividerThemeData(
      color: AppColors.darkDivider,
      thickness: 1,
      space: 1,
    );
  }

  static ListTileThemeData _listTileThemeDark() {
    return ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.sm,
      ),
      titleTextStyle: AppTextStyles.bodyLarge,
      subtitleTextStyle: AppTextStyles.bodyMedium,
      dense: false,
      isThreeLine: false,
    );
  }

  static BadgeThemeData _badgeThemeDark() {
    return const BadgeThemeData(
      backgroundColor: AppColors.darkError,
      textColor: Colors.white,
      smallSize: AppSpacing.badgeSizeSmall,
      largeSize: AppSpacing.badgeSizeMedium,
      textStyle: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
