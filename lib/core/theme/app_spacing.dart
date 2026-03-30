import 'package:flutter/material.dart';

/// KhmerBiz POS Spacing System
///
/// Base unit: 4dp (Cambodian market standard for touch targets)
///
/// Design principles:
/// - All spacing is multiples of 4dp for visual consistency
/// - Minimum touch target: 48dp (accessibility for all users)
/// - Critical interactions (numpad, checkout): 72dp minimum
/// - Generous spacing reduces errors in fast-paced environments
final class AppSpacing {
  const AppSpacing._();

  // ═══════════════════════════════════════════════════════════════
  // BASE SPACING UNITS (4dp grid system)
  // ═══════════════════════════════════════════════════════════════

  /// Extra small: 4dp
  /// Usage: Tight spacing, icon padding
  static const double xs = 4;

  /// Small: 8dp
  /// Usage: Between related elements, icon margins
  static const double sm = 8;

  /// Medium: 12dp
  /// Usage: Card padding, list item spacing
  static const double md = 12;

  /// Base: 16dp
  /// Usage: Standard padding, content margins
  static const double base = 16;

  /// Large: 24dp
  /// Usage: Section spacing, screen padding
  static const double lg = 24;

  /// Extra large: 32dp
  /// Usage: Major section separation
  static const double xl = 32;

  /// Double extra large: 48dp
  /// Usage: Hero spacing, large gaps
  static const double xxl = 48;

  /// Triple extra large: 64dp
  /// Usage: Major section separation, screen padding
  static const double xxxl = 64;

  // ═══════════════════════════════════════════════════════════════
  // COMPONENT SIZES (Minimum touch targets)
  // ═══════════════════════════════════════════════════════════════

  /// Button height (primary): 56dp
  /// Standard for all primary CTAs (checkout, add to cart)
  static const double buttonHeightPrimary = 56;

  /// Button height (secondary): 48dp
  /// For secondary actions (cancel, back)
  static const double buttonHeightSecondary = 48;

  /// Button height (small): 40dp
  /// For compact buttons (chips, filters)
  static const double buttonHeightSmall = 40;

  /// Icon button: 48×48dp
  /// Minimum touch target for icon-only buttons
  static const double iconButtonSize = 48;

  /// Numpad key: 72×72dp
  /// CRITICAL: Large size for accurate PIN/quantity input
  /// Used in: PIN entry, quantity selector, cash input
  static const double numpadKeySize = 72;

  /// Product card (grid): minimum 140dp wide, 180dp tall
  /// Ensures product info is readable in busy environments
  static const double productCardWidth = 140;
  static const double productCardHeight = 180;

  /// Product card (list): 80dp height
  /// For list view of products
  static const double productCardListHeight = 80;

  /// Category pill: 40dp height
  /// Horizontal scrollable category filters
  static const double categoryPillHeight = 40;

  /// Category pill padding: 16dp horizontal
  static const double categoryPillPadding = 16;

  /// List item: 64dp minimum height
  /// For cart items, transaction list, product list
  static const double listItemHeight = 64;

  /// List item (compact): 56dp height
  /// For dense lists
  static const double listItemHeightCompact = 56;

  /// AppBar: 56dp
  /// Standard Material 3 app bar height
  static const double appBarHeight = 56;

  /// Bottom navigation: 60dp
  /// Slightly taller for easy thumb access
  static const double bottomNavHeight = 60;

  /// FAB (Floating Action Button): 56×56dp
  static const double fabSize = 56;

  /// Payment method button: 80dp height
  /// Large touch target for payment selection
  static const double paymentMethodHeight = 80;

  /// Input field height: 56dp
  /// Standard text field height
  static const double inputFieldHeight = 56;

  /// Input field height (dense): 48dp
  /// For compact forms
  static const double inputFieldHeightDense = 48;

  /// Cart item stepper button: 48dp
  /// Minimum 48×48 touch target for quantity +/- buttons
  static const double stepperButtonSize = 48;

  /// Avatar size (small): 32dp
  static const double avatarSizeSmall = 32;

  /// Avatar size (medium): 40dp
  static const double avatarSizeMedium = 40;

  /// Avatar size (large): 56dp
  static const double avatarSizeLarge = 56;

  /// Badge size (small): 20dp
  static const double badgeSizeSmall = 20;

  /// Badge size (medium): 24dp
  static const double badgeSizeMedium = 24;

  // ═══════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ═══════════════════════════════════════════════════════════════

  /// No radius: 0dp
  static const double radiusNone = 0;

  /// Small radius: 4dp
  /// Usage: Chips, small buttons
  static const double radiusSmall = 4;

  /// Medium radius: 8dp
  /// Usage: Cards, buttons, input fields
  static const double radiusMedium = 8;

  /// Large radius: 12dp
  /// Usage: Large cards, modals
  static const double radiusLarge = 12;

  /// Extra large radius: 16dp
  /// Usage: Bottom sheets, large modals
  static const double radiusExtraLarge = 16;

  /// Full radius: 999dp
  /// Usage: Pills, circular buttons, avatars
  static const double radiusFull = 999;

  // ═══════════════════════════════════════════════════════════════
  // SHADOW ELEVATION
  // ═══════════════════════════════════════════════════════════════

  /// No shadow
  static const double elevation0 = 0;

  /// Small shadow: Cards, buttons at rest
  static const double elevation1 = 1;

  /// Medium shadow: Raised buttons, FAB at rest
  static const double elevation2 = 2;

  /// Large shadow: FAB pressed, modals
  static const double elevation3 = 3;

  /// Extra large shadow: Dialogs, bottom sheets
  static const double elevation4 = 4;

  /// Maximum shadow: Critical overlays
  static const double elevation6 = 6;

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  /// Get spacing value by name
  static double get(String name) {
    switch (name.toLowerCase()) {
      case 'xs':
        return xs;
      case 'sm':
        return sm;
      case 'md':
        return md;
      case 'base':
        return base;
      case 'lg':
        return lg;
      case 'xl':
        return xl;
      case 'xxl':
        return xxl;
      case 'xxxl':
        return xxxl;
      default:
        return base;
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // SEMANTIC SPACING (Common layout patterns)
  // ═══════════════════════════════════════════════════════════════

  /// Horizontal padding for screen-level content: 16dp
  static const double pageHorizontal = base;

  /// Vertical padding for screen-level content: 16dp
  static const double pageVertical = base;

  /// Gap between major sections: 24dp
  static const double sectionGap = lg;

  /// Internal card padding: 16dp
  static const double cardPadding = base;

  /// List item internal padding: 12dp
  static const double listItemPadding = md;

  /// Chip internal padding: 8dp horizontal, 4dp vertical
  static const double chipPaddingH = sm;
  static const double chipPaddingV = xs;

  /// Convert dp to EdgeInsets
  static EdgeInsets edgeInsets(double value) {
    return EdgeInsets.all(value);
  }

  /// Symmetric padding (horizontal and vertical)
  static EdgeInsets symmetric({
    double horizontal = base,
    double vertical = base,
  }) {
    return EdgeInsets.symmetric(
      horizontal: horizontal,
      vertical: vertical,
    );
  }

  /// Only padding (selective)
  static EdgeInsets only({
    double top = 0,
    double right = 0,
    double bottom = 0,
    double left = 0,
  }) {
    return EdgeInsets.only(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
    );
  }
}

/// Extension methods for convenient spacing access
extension SpacingExtension on num {
  /// Convert to EdgeInsets.all
  EdgeInsets get all => EdgeInsets.all(toDouble());

  /// Convert to EdgeInsets.symmetric
  EdgeInsets get symmetric => EdgeInsets.symmetric(
        horizontal: toDouble(),
        vertical: toDouble(),
      );

  /// Convert to EdgeInsets.horizontal
  EdgeInsets get horizontal => EdgeInsets.symmetric(horizontal: toDouble());

  /// Convert to EdgeInsets.vertical
  EdgeInsets get vertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Convert to EdgeInsets.only(left: value)
  EdgeInsets get left => EdgeInsets.only(left: toDouble());

  /// Convert to EdgeInsets.only(right: value)
  EdgeInsets get right => EdgeInsets.only(right: toDouble());

  /// Convert to EdgeInsets.only(top: value)
  EdgeInsets get top => EdgeInsets.only(top: toDouble());

  /// Convert to EdgeInsets.only(bottom: value)
  EdgeInsets get bottom => EdgeInsets.only(bottom: toDouble());
}
