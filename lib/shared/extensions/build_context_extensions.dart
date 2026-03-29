/// Extensions on BuildContext for convenient access to theme and localization.
library;

import 'package:flutter/material.dart';

/// Extension on BuildContext for theme access.
extension BuildContextThemeExtension on BuildContext {
  /// Get the theme data.
  ThemeData get theme => Theme.of(this);

  /// Get the color scheme.
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the icon theme.
  IconThemeData get iconTheme => Theme.of(this).iconTheme;

  /// Get the primary color.
  Color get primaryColor => Theme.of(this).colorScheme.primary;

  /// Get the secondary color.
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;

  /// Get the error color.
  Color get errorColor => Theme.of(this).colorScheme.error;

  /// Get the surface color.
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  /// Get the background color.
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
}

/// Extension on BuildContext for media query access.
extension BuildContextMediaQueryExtension on BuildContext {
  /// Get the media query data.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get the screen size.
  Size get screenSize => MediaQuery.of(this).size;

  /// Get the screen width.
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get the screen height.
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Get the padding (e.g., notch, status bar).
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get the view insets (e.g., keyboard).
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Get the view padding.
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  /// Check if keyboard is visible.
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  /// Get status bar height.
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Get bottom bar height (keyboard, etc.).
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  /// Check if in portrait mode.
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Check if in landscape mode.
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Get device pixel ratio.
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Check if this is a small screen (phone).
  bool get isSmallScreen => screenWidth < 600;

  /// Check if this is a medium screen (tablet).
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Check if this is a large screen (desktop).
  bool get isLargeScreen => screenWidth >= 1200;
}

/// Extension on BuildContext for navigation.
extension BuildContextNavigationExtension on BuildContext {
  /// Show a snackbar.
  void showSnackBar(String message,
      {Duration? duration, SnackBarAction? action,}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 2),
        action: action,
      ),
    );
  }

  /// Show an error snackbar.
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.error,
        duration: duration ?? const Duration(seconds: 3),
      ),
    );
  }

  /// Show a success snackbar.
  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(this).colorScheme.primary,
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// Show a dialog.
  Future<T?> showAppDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: this,
      builder: builder,
      barrierDismissible: barrierDismissible,
    );
  }

  /// Show a loading dialog.
  void showLoadingDialog({String? message}) {
    showDialog<void>(
      context: this,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message),
            ],
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide the current dialog.
  void popDialog() {
    Navigator.of(this).pop();
  }
}
