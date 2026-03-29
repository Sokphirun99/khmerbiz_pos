import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// KhmerBiz POS Typography System
///
/// CRITICAL: Khmer-first typography with proper font pairing.
///
/// Font Strategy (all via Google Fonts):
/// - Khmer text: Kantumruy Pro (Google Fonts)
/// - Latin-only text: Noto Sans (Google Fonts, paired x-height)
/// - Numbers/Prices: Roboto Mono (Google Fonts, monospaced for alignment)
///
/// IMPORTANT: Never mix Khmer and Latin in the same TextStyle.
/// Use separate KhTextStyle and EnTextStyle helpers to avoid line height issues.
///
/// Minimum font size: 14sp (accessibility for 40+ users)
final class AppTextStyles {
  const AppTextStyles._();

  // ═══════════════════════════════════════════════════════════════
  // FONT FAMILIES (via Google Fonts)
  // ═══════════════════════════════════════════════════════════════

  /// Primary Khmer font (Google Fonts)
  static TextStyle get kantumruyPro => GoogleFonts.kantumruyPro();

  /// Latin font for English text (Google Fonts)
  static TextStyle get notoSans => GoogleFonts.notoSans();

  /// Monospace font for prices/numbers (Google Fonts)
  static TextStyle get robotoMono => GoogleFonts.robotoMono();

  // ═══════════════════════════════════════════════════════════════
  // DISPLAY STYLES (Large amounts, success screens)
  // ═══════════════════════════════════════════════════════════════

  /// Display Large: Transaction success amount, hero numbers
  static TextStyle get displayLarge => kantumruyPro.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// Display Medium: Cart total, section totals
  static TextStyle get displayMedium => kantumruyPro.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.3,
      );

  // ═══════════════════════════════════════════════════════════════
  // HEADLINE STYLES (Screen titles, section headers)
  // ═══════════════════════════════════════════════════════════════

  /// Headline Large: Screen titles
  static TextStyle get headlineLarge => kantumruyPro.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Headline Medium: Section titles, card headers
  static TextStyle get headlineMedium => kantumruyPro.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      );

  /// Headline Small: Subsection headers
  static TextStyle get headlineSmall => kantumruyPro.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
      );

  // ═══════════════════════════════════════════════════════════════
  // BODY STYLES (Content text)
  // ═══════════════════════════════════════════════════════════════

  /// Body Large: Product names, primary content
  static TextStyle get bodyLarge => kantumruyPro.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  /// Body Medium: Secondary info, subtitles
  static TextStyle get bodyMedium => kantumruyPro.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  /// Body Small: Labels, timestamps, hints
  static TextStyle get bodySmall => kantumruyPro.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
      );

  // ═══════════════════════════════════════════════════════════════
  // PRICE STYLES (Currency display - MONOSPACED)
  // ═══════════════════════════════════════════════════════════════

  /// Price Display: KHR amounts (LARGE, BOLD, MONOSPACED)
  static TextStyle get priceDisplay => robotoMono.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      );

  /// Price Sub: USD equivalent (smaller, gray)
  static TextStyle get priceSub => robotoMono.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.2,
      );

  /// Price Small: Compact price display
  static TextStyle get priceSmall => robotoMono.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  // ═══════════════════════════════════════════════════════════════
  // BUTTON & INTERACTIVE STYLES
  // ═══════════════════════════════════════════════════════════════

  /// Button Label: All button text
  static TextStyle get buttonLabel => kantumruyPro.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: 0.3,
      );

  /// Button Small: Secondary buttons
  static TextStyle get buttonSmall => kantumruyPro.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1,
      );

  /// Chip Label: Filter chips, category pills
  static TextStyle get chipLabel => kantumruyPro.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        height: 1,
      );

  /// Receipt Body: Thermal printer receipt text
  static TextStyle get receiptBody => robotoMono.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.4,
      );

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get Khmer text style (uses Kantumruy Pro via Google Fonts)
  static TextStyle khmer({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
  }) {
    return kantumruyPro.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }

  /// Get English text style (uses Noto Sans via Google Fonts)
  static TextStyle english({
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
    Color? color,
  }) {
    return notoSans.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      color: color,
    );
  }

  /// Get price text style (uses Roboto Mono via Google Fonts)
  static TextStyle price({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return robotoMono.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}

/// Pre-built text theme for ThemeData
TextTheme createTextTheme() {
  return TextTheme(
    displayLarge: AppTextStyles.displayLarge,
    displayMedium: AppTextStyles.displayMedium,
    displaySmall: AppTextStyles.headlineLarge,
    headlineLarge: AppTextStyles.headlineLarge,
    headlineMedium: AppTextStyles.headlineMedium,
    headlineSmall: AppTextStyles.headlineSmall,
    bodyLarge: AppTextStyles.bodyLarge,
    bodyMedium: AppTextStyles.bodyMedium,
    bodySmall: AppTextStyles.bodySmall,
    labelLarge: AppTextStyles.buttonLabel,
    labelMedium: AppTextStyles.chipLabel,
    labelSmall: AppTextStyles.bodySmall,
  );
}
