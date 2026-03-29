import 'package:flutter/material.dart';

/// KhmerBiz POS Shadow System
///
/// LDSG-compliant elevation shadows using BoxShadow lists.
///
/// NOT using Material elevation — instead defining explicit shadow values
/// for pixel-perfect consistency across platforms.
///
/// Usage:
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     boxShadow: AppShadow.sm,  // product cards
///   ),
/// )
/// ```
final class AppShadow {
  const AppShadow._();

  /// No shadow — flat items, list tiles, inline elements
  static const List<BoxShadow> none = <BoxShadow>[];

  /// Small shadow — product cards, list items, resting buttons
  ///
  /// blurRadius: 4, offset: (0, 2), opacity: 6%
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow — bottom sheets, FAB, dropdowns, floating panels
  ///
  /// blurRadius: 12, offset: (0, 4), opacity: 10%
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1A000000), // rgba(0,0,0,0.10)
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// Large shadow — modals, dialogs, critical popups
  ///
  /// blurRadius: 24, offset: (0, 8), opacity: 16%
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x29000000), // rgba(0,0,0,0.16)
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Top shadow — bottom bars, fixed footers (shadow goes upward)
  static const List<BoxShadow> top = [
    BoxShadow(
      color: Color(0x0F000000), // rgba(0,0,0,0.06)
      blurRadius: 8,
      offset: Offset(0, -2),
    ),
  ];
}
