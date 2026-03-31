import 'package:flutter/material.dart';

/// A utility widget that helps in determining the screen type Based on the width.
class ResponsiveLayout extends StatelessWidget {
  /// Creates a [ResponsiveLayout].
  const ResponsiveLayout({
    required this.mobile,
    super.key,
    this.tablet,
    this.desktop,
  });

  /// Widget to display on mobile devices (width < 600)
  final Widget mobile;

  /// Widget to display on tablet devices (600 <= width < 1024)
  final Widget? tablet;

  /// Widget to display on desktop devices (width >= 1024)
  final Widget? desktop;

  /// Returns true if the screen width is less than 600.
  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  /// Returns true if the screen width is between 600 and 1024.
  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 600 &&
      MediaQuery.sizeOf(context).width < 1024;

  /// Returns true if the screen width is 1024 or greater.
  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1024;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1024 && desktop != null) {
      return desktop!;
    } else if (width >= 600 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}
