import 'package:flutter/material.dart';

/// KhmerBiz POS Color System
///
/// Inspired by Cambodian culture: temple stone + lotus + gold
/// Optimized for POS workflows in noisy markets with varying lighting conditions.
///
/// Design principles:
/// - High contrast for readability under shop lighting
/// - Warm background (#F5F5F0) easier on eyes than pure white
/// - Gold accent (#E8A020) for primary CTAs (culturally significant)
/// - Deep indigo primary (#1A3C5E) conveys trust and stability
final class AppColors {
  const AppColors._();

  // ═══════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS
  // ═══════════════════════════════════════════════════════════════

  /// Primary: Deep indigo-navy (trust, stability - like Angkor stone)
  static const Color primary = Color(0xFF1A3C5E);

  /// Primary Light: For hover/selected states
  static const Color primaryLight = Color(0xFF2A5F95);

  /// Primary Dark: For pressed states
  static const Color primaryDark = Color(0xFF0F2540);

  /// Accent: Cambodian gold (CTAs, highlights - like temple decorations)
  static const Color accent = Color(0xFFE8A020);

  /// Accent Dark: Pressed state for accent
  static const Color accentDark = Color(0xFFC4841A);

  /// Accent Light: Hover state for accent
  static const Color accentLight = Color(0xFFFFF3D6);

  /// Success: Stock OK, payment confirmed, sync done
  static const Color success = Color(0xFF2E7D32);

  /// Success Light: Background for success states
  static const Color successLight = Color(0xFFE8F5E9);

  /// Warning: Low stock, offline mode, pending
  static const Color warning = Color(0xFFF57F17);

  /// Warning Light: Background for warning states
  static const Color warningLight = Color(0xFFFFF8E1);

  /// Error: Payment failed, stock out, critical errors
  static const Color error = Color(0xFFC62828);

  /// Error Light: Background for error states
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Info: General information, hints
  static const Color info = Color(0xFF1565C0);

  /// Info Light: Background for info states
  static const Color infoLight = Color(0xFFE3F2FD);

  /// Background: Warm off-white (easier on eyes under shop lighting)
  static const Color background = Color(0xFFF5F5F0);

  /// Surface: Cards, dialogs, sheets
  static const Color surface = Color(0xFFFFFFFF);

  /// Surface Alt: Card backgrounds, input fills, alternating rows
  static const Color surfaceAlt = Color(0xFFEFF3F7);

  /// On Primary: Text/icons on primary background
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// On Accent: Text/icons on accent background
  static const Color onAccent = Color(0xFF1A1A1A);

  /// Text Primary: Main content text
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Text Secondary: Supporting text, subtitles
  static const Color textSecondary = Color(0xFF5C5C5C);

  /// Text Hint: Placeholder text, disabled states
  static const Color textHint = Color(0xFF9E9E9E);

  /// Text Tertiary: Tertiary info, least emphasized text
  static const Color textTertiary = textHint;

  /// Text Disabled: Disabled text
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Divider: Section dividers
  static const Color divider = Color(0xFFE0E0E0);

  /// Border: Input borders, card borders
  static const Color border = Color(0xFFC8C8C8);

  /// Border Light: Light borders for subtle separation
  static const Color borderLight = Color(0xFFEEEEEE);

  /// Border Focus: Focused input field border
  static const Color borderFocus = Color(0xFF1A3C5E); // = primary

  /// Overlay: Modal barriers, scrim
  static const Color overlay = Color(0x66000000); // 40% black

  /// Surface Overlay: Semi-transparent overlay for elevated surfaces
  static const Color surfaceOverlay = Color(0x0A000000); // 4% black

  /// Shadow: Drop shadows
  static const Color shadow = Color(0x33000000); // 20% black

  // ═══════════════════════════════════════════════════════════════
  // PAYMENT BRAND COLORS (Cambodia-specific)
  // ═══════════════════════════════════════════════════════════════

  /// KHQR Blue: Bakong KHQR payment system brand color
  static const Color khqrBlue = Color(0xFF0066A1);

  /// ABA Red: ABA Bank brand color
  static const Color abaRed = Color(0xFFD32030);

  /// Wing Orange: Wing (Cambodia) brand color
  static const Color wingOrange = Color(0xFFF7941D);

  /// Cash Green: Cash payment method accent
  static const Color cashGreen = Color(0xFF2E7D32); // = success

  // ═══════════════════════════════════════════════════════════════
  // DARK THEME COLORS (for night-shift cashiers)
  // ═══════════════════════════════════════════════════════════════

  /// Dark Background: Main background in dark mode
  static const Color darkBackground = Color(0xFF121212);

  /// Dark Surface: Cards, dialogs in dark mode
  static const Color darkSurface = Color(0xFF1E1E1E);

  /// Dark Surface Alt: Alternative surface in dark mode
  static const Color darkSurfaceAlt = Color(0xFF2A2A2A);

  /// Dark Primary: Lighter primary for dark mode
  static const Color darkPrimary = Color(0xFF4A90D9);

  /// Dark Primary Light: Hover state in dark mode
  static const Color darkPrimaryLight = Color(0xFF64A5F0);

  /// Dark Accent: Lighter accent for dark mode
  static const Color darkAccent = Color(0xFFF5B942);

  /// Dark Accent Dark: Pressed state in dark mode
  static const Color darkAccentDark = Color(0xFFD4A030);

  /// Dark Success: Success color for dark mode
  static const Color darkSuccess = Color(0xFF4CAF50);

  /// Dark Success Light: Success background in dark mode
  static const Color darkSuccessLight = Color(0xFF1B5E20);

  /// Dark Warning: Warning color for dark mode
  static const Color darkWarning = Color(0xFFFFB74D);

  /// Dark Warning Light: Warning background in dark mode
  static const Color darkWarningLight = Color(0xFF3E2723);

  /// Dark Error: Error color for dark mode
  static const Color darkError = Color(0xFFEF5350);

  /// Dark Error Light: Error background in dark mode
  static const Color darkErrorLight = Color(0xFFB71C1C);

  /// Dark Text Primary: Main text in dark mode
  static const Color darkTextPrimary = Color(0xFFF0F0F0);

  /// Dark Text Secondary: Secondary text in dark mode
  static const Color darkTextSecondary = Color(0xFFB0B0B0);

  /// Dark Text Hint: Hint text in dark mode
  static const Color darkTextHint = Color(0xFF757575);

  /// Dark Divider: Dividers in dark mode
  static const Color darkDivider = Color(0xFF424242);

  /// Dark Border: Borders in dark mode
  static const Color darkBorder = Color(0xFF555555);

  /// Dark Overlay: Modal barriers in dark mode
  static const Color darkOverlay = Color(0x99000000); // 60% black

  /// Dark Info: Info color for dark mode
  static const Color darkInfo = Color(0xFF42A5F5);

  /// Dark Info Light: Info background in dark mode
  static const Color darkInfoLight = Color(0xFF0D47A1);

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC COLOR MAPPINGS (for easy theme switching)
  // ═══════════════════════════════════════════════════════════════

  /// Get background color based on brightness
  static Color getBackground(Brightness brightness) {
    return brightness == Brightness.dark ? darkBackground : background;
  }

  /// Get surface color based on brightness
  static Color getSurface(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurface : surface;
  }

  /// Get surface alt color based on brightness
  static Color getSurfaceAlt(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurfaceAlt : surfaceAlt;
  }

  /// Get primary color based on brightness
  static Color getPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? darkPrimary : primary;
  }

  /// Get accent color based on brightness
  static Color getAccent(Brightness brightness) {
    return brightness == Brightness.dark ? darkAccent : accent;
  }

  /// Get text primary color based on brightness
  static Color getTextPrimary(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextPrimary : textPrimary;
  }

  /// Get text secondary color based on brightness
  static Color getTextSecondary(Brightness brightness) {
    return brightness == Brightness.dark ? darkTextSecondary : textSecondary;
  }

  /// Get divider color based on brightness
  static Color getDivider(Brightness brightness) {
    return brightness == Brightness.dark ? darkDivider : divider;
  }

  /// Get border color based on brightness
  static Color getBorder(Brightness brightness) {
    return brightness == Brightness.dark ? darkBorder : border;
  }
}
