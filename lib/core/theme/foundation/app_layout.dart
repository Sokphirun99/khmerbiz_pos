import 'package:flutter/material.dart';

/// KhmerBiz POS Layout System
///
/// LDSG column grid system and responsive breakpoints.
///
/// KhmerBiz POS is designed mobile-first (portrait), with tablet support
/// for split-view POS layouts (products | cart).
///
/// Usage:
/// ```dart
/// if (AppLayout.isTablet(context)) {
///   // Show side-by-side layout
/// } else {
///   // Show stacked layout
/// }
/// ```
final class AppLayout {
  const AppLayout._();

  // ═══════════════════════════════════════════════════════════════
  // COLUMN GRID (LDSG standard)
  // ═══════════════════════════════════════════════════════════════

  /// Phone: 4-column grid
  static const int phoneColumns = 4;

  /// Tablet: 8-column grid
  static const int tabletColumns = 8;

  /// Desktop: 12-column grid (future POS terminal)
  static const int desktopColumns = 12;

  // ═══════════════════════════════════════════════════════════════
  // BREAKPOINTS
  // ═══════════════════════════════════════════════════════════════

  /// Phone max width: 599dp
  static const double phoneMaxWidth = 599;

  /// Tablet min width: 600dp
  static const double tabletMinWidth = 600;

  /// Tablet max width: 1023dp
  static const double tabletMaxWidth = 1023;

  /// Desktop min width: 1024dp
  static const double desktopMinWidth = 1024;

  // ═══════════════════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════════════════

  /// Check if current device is tablet-sized or larger.
  ///
  /// Used to switch between stacked (phone) and side-by-side (tablet) layouts.
  static bool isTablet(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= tabletMinWidth;
  }

  /// Check if current device is desktop-sized.
  static bool isDesktop(BuildContext context) {
    return MediaQuery.sizeOf(context).width >= desktopMinWidth;
  }

  /// Get the number of grid columns for the current screen width.
  static int getColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= desktopMinWidth) return desktopColumns;
    if (width >= tabletMinWidth) return tabletColumns;
    return phoneColumns;
  }

  /// Get the number of product grid columns based on screen width.
  ///
  /// Ensures product cards are never smaller than 140dp wide.
  static int getProductGridColumns(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    // Account for padding (16dp each side = 32dp) and spacing (8dp between)
    const minCardWidth = 140.0;
    const padding = 32.0;
    const spacing = 8.0;

    final availableWidth = width - padding;
    final columns = (availableWidth / (minCardWidth + spacing)).floor();
    return columns.clamp(2, 6);
  }
}
