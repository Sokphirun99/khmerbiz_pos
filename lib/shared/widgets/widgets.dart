/// KhmerBiz POS Shared Widgets
///
/// This library exports all reusable widgets for the KhmerBiz POS application.
///
/// Import this file to access all shared widgets:
/// ```dart
/// import 'package:khmerbiz_pos/shared/widgets/widgets.dart';
/// ```
///
/// Widgets are organized by category:
/// - Buttons: AppButton, PaymentMethodButton
/// - Cards: ProductCard, CartItemTile
/// - Displays: PriceDisplay, StockBadge, SyncStatusBadge
/// - Inputs: AppTextField, NumPad
/// - Layouts: SectionHeader, CategoryPill
/// - Feedback: LoadingSkeleton, EmptyState, ConfirmationDialog, OfflineBanner
library;

// ═══════════════════════════════════════════════════════════════
// BUTTONS
// ═══════════════════════════════════════════════════════════════

export 'buttons/app_button.dart';
export 'buttons/payment_method_button.dart';
export 'cards/cart_item_tile.dart';
// ═══════════════════════════════════════════════════════════════
// CARDS
// ═══════════════════════════════════════════════════════════════

export 'cards/product_card.dart';
// ═══════════════════════════════════════════════════════════════
// DISPLAYS
// ═══════════════════════════════════════════════════════════════

export 'displays/price_display.dart';
export 'displays/stock_badge.dart';
export 'displays/sync_status_badge.dart';
export 'feedback/confirmation_dialog.dart';
export 'feedback/empty_state.dart';
// ═══════════════════════════════════════════════════════════════
// FEEDBACK
// ═══════════════════════════════════════════════════════════════

export 'feedback/loading_skeleton.dart';
export 'feedback/offline_banner.dart';
// ═══════════════════════════════════════════════════════════════
// INPUTS
// ═══════════════════════════════════════════════════════════════

export 'inputs/app_text_field.dart';
export 'inputs/num_pad.dart';
export 'layouts/category_pill.dart';
// ═══════════════════════════════════════════════════════════════
// LAYOUTS
// ═══════════════════════════════════════════════════════════════

export 'layouts/section_header.dart';
