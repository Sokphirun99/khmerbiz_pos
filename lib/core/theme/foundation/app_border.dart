/// KhmerBiz POS Border Width System
///
/// LDSG-compliant border width tokens for inputs, cards, and selection states.
///
/// Usage:
/// ```dart
/// Border.all(width: AppBorderWidth.thin)   // card strokes
/// Border.all(width: AppBorderWidth.focus)   // focused input border
/// ```
final class AppBorderWidth {
  const AppBorderWidth._();

  /// Thin: 1.0dp — default card borders, dividers, list separators
  static const double thin = 1;

  /// Medium: 1.5dp — secondary button borders, subtle emphasis
  static const double medium = 1.5;

  /// Thick: 2.0dp — strong emphasis, active state borders
  static const double thick = 2;

  /// Focus: 2.0dp — focused input field border
  static const double focus = 2;

  /// Selected: 2.0dp — selected card/button indicator
  static const double selected = 2;
}
