import 'package:flutter/material.dart';

/// KhmerBiz POS Border Radius System
///
/// LDSG-compliant radius tokens for all UI components.
///
/// Usage:
/// ```dart
/// BorderRadius.circular(AppRadius.sm)  // cards, buttons
/// BorderRadius.circular(AppRadius.pill) // category pills, badges
/// ```
final class AppRadius {
  const AppRadius._();

  /// No radius: 0dp — flat edges
  static const double none = 0;

  /// Extra small: 4dp — tags, small chips
  static const double xs = 4;

  /// Small: 8dp — cards, buttons, input fields
  static const double sm = 8;

  /// Medium: 12dp — modals, bottom sheets
  static const double md = 12;

  /// Large: 16dp — large cards, feature panels
  static const double lg = 16;

  /// Extra large: 24dp — QR display card, hero sections
  static const double xl = 24;

  /// Pill: 999dp — category pills, filter chips, status badges
  static const double pill = 999;

  /// Circle: 999dp — avatars, FAB, circular buttons
  static const double circle = 999;

  // ═══════════════════════════════════════════════════════════════
  // PRE-BUILT BorderRadius (convenience)
  // ═══════════════════════════════════════════════════════════════

  /// No radius
  static const BorderRadius borderNone = BorderRadius.zero;

  /// Extra small radius
  static final BorderRadius borderXs = BorderRadius.circular(xs);

  /// Small radius — cards, buttons
  static final BorderRadius borderSm = BorderRadius.circular(sm);

  /// Medium radius — modals, sheets
  static final BorderRadius borderMd = BorderRadius.circular(md);

  /// Large radius — large cards
  static final BorderRadius borderLg = BorderRadius.circular(lg);

  /// Extra large radius — QR card
  static final BorderRadius borderXl = BorderRadius.circular(xl);

  /// Pill radius — pills, badges
  static final BorderRadius borderPill = BorderRadius.circular(pill);

  /// Circle radius — avatars, FAB
  static final BorderRadius borderCircle = BorderRadius.circular(circle);

  /// Top-only medium radius — bottom sheets
  static const BorderRadius topMd = BorderRadius.vertical(
    top: Radius.circular(md),
  );

  /// Top-only large radius — large bottom sheets
  static const BorderRadius topLg = BorderRadius.vertical(
    top: Radius.circular(lg),
  );
}
