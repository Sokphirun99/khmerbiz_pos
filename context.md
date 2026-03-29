# KhmerBiz POS - Architectural Context & Decisions

**Session:** Project Skeleton Setup + UI/UX Design System
**Date:** 2026-03-28
**Version:** 1.1.0

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Decisions](#architecture-decisions)
3. [Technology Stack](#technology-stack)
4. [Folder Structure](#folder-structure)
5. [Key Design Decisions](#key-design-decisions)
6. [UI/UX Design System](#uiux-design-system)
7. [Assumptions Made](#assumptions-made)
8. [Open Questions](#open-questions)
9. [Next Steps](#next-steps)

---

## Project Overview

**KhmerBiz POS** is a mobile-first Point of Sale application designed for small businesses in Cambodia (cafes, retail shops, mini-marts, pharmacies).

### Target Users
- Shop owners and cashiers in Cambodia
- Users with varying levels of tech literacy
- Mixed language speakers (Khmer + English)

### Target Devices
- Mid-range Android devices (3-4 GB RAM, Snapdragon 400-600 series)
- Android API 26+ (Android 8.0+)
- Spotty LTE/4G connectivity

### Key Features (Planned)
- POS with dual currency display (KHR/USD)
- KHQR payment integration
- Inventory management
- Customer management
- Sales reports
- Offline-first with background sync
- Bluetooth printer support

---

## Architecture Decisions

### 1. Clean Architecture (Strict)

**Decision:** Implement strict Clean Architecture with three layers:
```
Presentation → Domain ← Data
```

**Rationale:**
- Clear separation of concerns
- Domain layer is pure Dart (testable without Flutter)
- Easy to swap data sources (e.g., Drift → Hive)
- BLoCs only depend on use cases, not repositories directly

**Enforcement:**
- `analysis_options.yaml` has custom rules
- No direct DB calls from BLoCs
- No business logic in widgets
- Domain layer has zero Flutter dependencies

### 2. BLoC Pattern (Not Cubit)

**Decision:** Use full BLoC pattern with sealed classes for events/states.

**Rationale:**
- Better event tracking and debugging
- Sealed classes ensure exhaustive handling
- More predictable state management
- Easier to test with `bloc_test`

**Pattern:**
```dart
// Events
sealed class AuthEvent extends Equatable { ... }
final class AuthLoginRequested extends AuthEvent { ... }

// States
sealed class AuthState extends Equatable { ... }
final class AuthAuthenticated extends AuthState { ... }

// BLoC
final class AuthBloc extends Bloc<AuthEvent, AuthState> { ... }
```

### 3. Offline-First Architecture

**Decision:** Design for offline-first with background sync.

**Rationale:**
- Unreliable internet in target markets
- POS must work during outages
- Data syncs when connection restored

**Implementation:**
- Drift for local SQLite database
- WorkManager for background sync
- Sync queue for pending operations
- Conflict resolution strategy (TODO: implement)

### 4. Dual Currency System

**Decision:** All prices displayed in both KHR and USD.

**Rationale:**
- Cambodian market uses both currencies
- KHR is primary, USD is reference
- Exchange rate fluctuates daily

**Implementation:**
- `CurrencyFormatter` utility class
- Global singleton `currencyFormatter`
- extension methods on `double` and `int`
- Exchange rate configurable via settings

### 5. JWT-Based Authentication

**Decision:** Use JWT tokens instead of Firebase Auth.

**Rationale:**
- No Google Play Services dependency
- Works on all Android devices
- Self-hosted auth server option
- Better control over session management

**Implementation:**
- Access token + Refresh token flow
- Tokens stored in `flutter_secure_storage`
- Auto-refresh before expiry
- Session timeout: 24 hours

---

## Technology Stack

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^8.1.3 | State management |
| `equatable` | ^2.0.5 | Value equality |
| `drift` | ^2.15.0 | Local database |
| `get_it` | ^7.6.4 | Service locator |
| `injectable` | ^2.3.2 | DI code generation |
| `go_router` | ^13.2.0 | Navigation |
| `dio` | ^5.4.0 | HTTP client |
| `retrofit` | ^4.0.3 | REST client generation |
| `connectivity_plus` | ^5.0.2 | Network detection |
| `workmanager` | ^0.5.2 | Background tasks |
| `flutter_secure_storage` | ^9.0.0 | Secure token storage |
| `shared_preferences` | ^2.2.2 | Local preferences |
| `uuid` | ^4.2.2 | ID generation |
| `intl` | ^0.18.1 | Localization/formatting |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `drift_dev` | ^2.15.0 | Drift code generation |
| `build_runner` | ^2.4.8 | Code generation |
| `injectable_generator` | ^2.4.1 | DI generation |
| `retrofit_generator` | ^8.0.6 | Retrofit generation |
| `flutter_lints` | ^3.0.1 | Linting |
| `mocktail` | ^1.0.2 | Mocking for tests |
| `bloc_test` | ^9.1.7 | BLoC testing |

### Fonts

- **Kantumruy Pro** - Primary font (supports Khmer + Latin)

---

## Folder Structure

```
lib/
├── core/
│   ├── di/                    # Dependency injection
│   │   ├── injection.dart
│   │   └── injection.config.dart (generated)
│   ├── config/                # App configuration
│   │   ├── app_config.dart
│   │   ├── env.dart
│   │   └── constants.dart
│   ├── error/                 # Error handling
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   ├── network/               # Network layer
│   │   ├── network_info.dart
│   │   └── api_client.dart
│   ├── utils/                 # Utilities
│   │   ├── currency_formatter.dart
│   │   ├── date_formatter.dart
│   │   └── validators.dart
│   ├── theme/                 # Theme configuration
│   │   └── app_theme.dart
│   ├── localization/          # l10n files
│   │   ├── app_en.arb
│   │   └── app_km.arb
│   └── router/                # Routing
│       └── app_router.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   │   ├── user.dart
│   │   │   ├── auth_result.dart
│   │   │   ├── auth_repository.dart
│   │   │   └── use_cases/
│   │   └── presentation/
│   │       └── bloc/
│   ├── products/
│   ├── cart/
│   ├── transactions/
│   ├── inventory/
│   ├── customers/
│   ├── reports/
│   ├── settings/
│   └── sync/
└── shared/
    ├── widgets/
    ├── extensions/
    └── mixins/
```

---

## Key Design Decisions

### 1. Sealed Classes for Failures

All failures extend a sealed `Failure` class with specific subtypes:
- `ServerFailure` - API errors
- `CacheFailure` - Database errors
- `NetworkFailure` - Connectivity errors
- `ValidationFailure` - Input validation errors
- `PrinterFailure` - Bluetooth printer errors
- `PaymentFailure` - Payment processing errors
- `SyncFailure` - Sync operation errors

Each carries both English and Khmer error messages.

### 2. Repository Pattern

Repositories are interfaces in domain layer:
```dart
abstract class AuthRepository {
  Future<AuthResult> login(LoginCredentials credentials);
  Future<void> logout();
  // ...
}
```

Implementation in data layer uses Drift + Dio.

### 3. Use Case Pattern

Each business operation is a use case:
```dart
final class LoginUseCase {
  final AuthRepository _repository;
  
  Future<AuthResult> call(LoginParams params) async {
    // Validation
    // Business logic
    // Repository call
  }
}
```

### 4. Currency Formatting

Global singleton `currencyFormatter` with exchange rate:
```dart
12500.0.formatKHR  // "៛12,500"
12500.0.formatDual // "៛12,500 ($3.05)"
```

### 5. Date Formatting

`DateFormatter` with Khmer numeral support:
```dart
DateTime.now().formatKhmer // "២៨ មីនា ២០២៦"
DateTime.now().formatDual  // "28 Mar 2026 | ២៨ មីនា ២០២៦"
```

### 6. Extension Methods

Heavy use of extensions for cleaner code:
- `BuildContext` extensions for theme/media query
- `num`/`int`/`double` extensions for formatting
- `String` extensions for validation
- `DateTime` extensions for formatting

---

## Assumptions Made

### Device/Platform
1. **Target Android API 26+** - Android 8.0 minimum
2. **No Google Play Services** - Some devices may not have GMS
3. **Portrait mode only** - POS typically used in portrait
4. **Mid-range hardware** - Optimize for Snapdragon 450 class

### Market/UX
1. **Dual currency display** - KHR primary, USD secondary
2. **Khmer Unicode support** - All text must render Khmer properly
3. **Mixed literacy levels** - Icon-heavy UI, simple flows
4. **KHQR payment** - National KHQR system integration required

### Technical
1. **JWT-based auth** - No Firebase Auth dependency
2. **Offline-first** - App must work without internet
3. **60fps target** - Smooth animations on mid-range devices
4. **Background sync** - Data syncs every 15 minutes

### Business
1. **Default tax rate: 10%** - Cambodia standard VAT
2. **Low stock threshold: 10** - Alert when stock ≤ 10
3. **Exchange rate: 4100 KHR/USD** - Default, updateable

---

## Open Questions

### To Be Clarified

1. **Feature Prioritization**
   - Should we implement all 8 feature modules now or focus on core (auth, products, cart)?
   - Which features are MVP vs. nice-to-have?

2. **Database Schema**
   - Should we create actual Drift table definitions now?
   - What's the full product catalog structure?

3. **KHQR Integration**
   - Which payment gateway API? (ABA, ACLEDA, Wing?)
   - Do we have API credentials for testing?

4. **Exchange Rate API**
   - Which API for live exchange rates? (NBC, commercial banks?)
   - How often should we update rates?

5. **Backend API**
   - Is there an existing backend or are we building it?
   - What's the API base URL for each environment?

6. **Printer Support**
   - Which printer models to support?
   - ESC/POS command set or vendor SDK?

---

## Next Steps

### Immediate (Next Session)

1. **Run `flutter pub get`** - Install dependencies
2. **Run `build_runner`** - Generate code
3. **Fix any build errors** - Verify compilation

### Short Term (Prompt 2-5)

1. **Implement Drift database schema**
   - User table
   - Product table
   - Transaction table
   - Cart table

2. **Complete Auth feature**
   - Login screen UI
   - Registration screen UI
   - Auth BLoC implementation
   - Token storage

3. **Implement Product feature**
   - Product list screen
   - Product detail screen
   - Product CRUD operations

4. **Implement Cart feature**
   - Cart UI
   - Add/remove items
   - Calculate totals

### Medium Term (Prompt 6-10)

1. **Transaction management**
2. **Inventory tracking**
3. **Customer management**
4. **Reports and analytics**
5. **Settings and preferences**

### Long Term

1. **KHQR payment integration**
2. **Bluetooth printer support**
3. **Background sync**
4. **Push notifications**
5. **Multi-outlet support**

---

## Session Notes

### Files Created

| File | Purpose |
|------|---------|
| `pubspec.yaml` | Dependencies and assets |
| `analysis_options.yaml` | Lint rules |
| `lib/core/error/failures.dart` | Failure sealed classes |
| `lib/core/error/exceptions.dart` | Exception classes |
| `lib/core/config/constants.dart` | App constants |
| `lib/core/config/app_config.dart` | Environment config |
| `lib/core/config/env.dart` | Environment enum |
| `lib/core/utils/currency_formatter.dart` | Currency formatting |
| `lib/core/utils/date_formatter.dart` | Date formatting |
| `lib/core/utils/validators.dart` | Form validators |
| `lib/core/network/network_info.dart` | Connectivity checker |
| `lib/core/network/api_client.dart` | HTTP client |
| `lib/core/di/injection.dart` | DI setup |
| `lib/core/theme/app_theme.dart` | Theme placeholder |
| `lib/core/localization/app_en.arb` | English translations |
| `lib/core/localization/app_km.arb` | Khmer translations |
| `lib/core/router/app_router.dart` | Route configuration |
| `lib/main.dart` | App entry point |
| `lib/features/auth/domain/*` | Auth domain layer |
| `lib/features/auth/presentation/bloc/*` | Auth BLoC |
| `lib/features/products/domain/*` | Product domain |
| `lib/features/cart/domain/*` | Cart domain |
| `lib/shared/extensions/*` | Dart extensions |
| `lib/shared/mixins/*` | Mixins |
| `lib/shared/widgets/*` | Shared widgets |

### Commands to Run

```bash
# Install dependencies
flutter pub get

# Generate code (after adding @injectable annotations)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run --dart-define=ENVIRONMENT=dev

# Run tests (when added)
flutter test
```

---

## UI/UX Design System

**Session:** Prompt 10 - Design System Implementation
**Date:** 2026-03-28

### Design Philosophy

KhmerBiz POS is used by cashiers in fast-paced environments:
- Noisy markets, cafes, mini-marts
- Screen may be dirty or have a cracked protector
- User may have basic literacy or non-native Khmer reader
- Interaction happens in <2 seconds per product add
- **Speed is the primary metric — not beauty**

**Design Principles:**
1. **CLARITY OVER BEAUTY:** Large text, high contrast, zero ambiguity
2. **SPEED OVER FEATURES:** Primary action always visible, one tap away
3. **KHMER-FIRST:** Khmer text is primary, English is supportive
4. **FORGIVENESS:** Easy to undo, clear error recovery
5. **TRUST:** Numbers must be obviously correct, no visual trickery

### Color System

**Brand Palette (Cambodian-inspired):**
| Color | Hex | Usage |
|-------|-----|-------|
| Primary | `#1A3C5E` | Deep indigo-navy (trust, stability) |
| Primary Light | `#2A5F95` | Hover/selected states |
| Accent | `#E8A020` | Cambodian gold (CTAs, highlights) |
| Accent Dark | `#C4841A` | Pressed state for accent |
| Success | `#2E7D32` | Stock OK, payment confirmed |
| Warning | `#F57F17` | Low stock, offline mode |
| Error | `#C62828` | Payment failed, stock out |
| Background | `#F5F5F0` | Warm off-white (easier on eyes) |
| Surface | `#FFFFFF` | Cards, dialogs |
| Surface Alt | `#EFF3F7` | Card backgrounds, input fills |

**Dark Mode:** Full dark theme support for night-shift cashiers.

### Typography System

**Fonts:**
| Script | Font | Source |
|--------|------|--------|
| Khmer | Kantumruy Pro | Bundled in assets |
| Latin | Noto Sans | Google Fonts |
| Numbers/Prices | Roboto Mono | Google Fonts |

**Text Styles:**
| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| displayLarge | 28sp | Bold | Transaction success amount |
| displayMedium | 24sp | Bold | Cart total |
| headlineLarge | 20sp | SemiBold | Screen titles |
| headlineMedium | 18sp | SemiBold | Section titles |
| bodyLarge | 16sp | Regular | Product names |
| bodyMedium | 14sp | Regular | Secondary info |
| bodySmall | 12sp | Regular | Labels, hints |
| priceDisplay | 22sp | Bold | KHR amounts (Roboto Mono) |
| priceSub | 14sp | Regular | USD equivalent |
| buttonLabel | 16sp | SemiBold | All buttons |
| chipLabel | 13sp | Medium | Category pills |

**CRITICAL:** Never mix Khmer and Latin in the same TextStyle. Use separate helpers.

### Spacing System

**Base Unit:** 4dp
- xs: 4dp, sm: 8dp, md: 12dp, base: 16dp, lg: 24dp, xl: 32dp, xxl: 48dp

**Component Sizes:**
| Component | Size |
|-----------|------|
| Button height (primary) | 56dp |
| Button height (secondary) | 48dp |
| Icon button | 48×48dp |
| Numpad key | 72×72dp minimum |
| Product card (grid) | 140×180dp minimum |
| Category pill height | 40dp |
| List item height | 64dp minimum |
| AppBar | 56dp |
| Bottom nav | 60dp |

### Component Library

**15 Reusable Widgets Implemented:**

1. **AppButton** - Primary/secondary/ghost/danger/accent variants
2. **PaymentMethodButton** - 80dp height, icon+label, selected overlay
3. **ProductCard** - Image, bilingual name, dual price, stock badge
4. **CartItemTile** - Qty stepper (40dp), swipe-to-delete, line total
5. **PriceDisplay** - KHR primary (Roboto Mono), USD secondary
6. **StockBadge** - Color-coded (green/amber/red), icon+text
7. **SyncStatusBadge** - Cloud icon, pending count badge
8. **AppTextField** - Khmer keyboard support, bilingual errors
9. **NumPad** - 4×3 grid, 72dp buttons, hold-to-repeat
10. **SectionHeader** - Bilingual title, optional action
11. **CategoryPill** - Scrollable row, selected/unselected states
12. **LoadingSkeleton** - Shimmer placeholders for all components
13. **EmptyState** - Illustration + bilingual title + action
14. **ConfirmationDialog** - Bilingual, danger/confirm buttons
15. **OfflineBanner** - Animated slide-down, pending count

### Localization

**Files:**
- `lib/core/localization/app_en.arb` - English strings
- `lib/core/localization/app_km.arb` - Khmer strings

**Key Patterns:**
- KHR format: `៛12,500` (whole number, comma separator)
- USD format: `$3.05` (2 decimal places)
- Dual format: `៛12,500 ($3.05)`
- Khmer numerals optional (toggle in settings)

### UX Flows & Micro-interactions

**High-Performance Cashier Interactions:**
- **Self-Contained Components**: Following LDSG principles, widgets manage their own internal interaction states (e.g., `ProductCard` and `CategoryPill` use internal `AnimationController`s) to decouple visual feedback from parent business logic, ensuring 60fps responsiveness.
- **Tactile Feedback**: Haptics are integrated strictly into every major tap to aid cashiers in noisy environments:
  - `HapticFeedback.lightImpact()`: minor actions like NumPad digit entries and backspaces.
  - `HapticFeedback.selectionClick()`: primary selections like Product adding and Cart stepping.
  - `HapticFeedback.mediumImpact()`: finalize/destructive actions like Confirmations and hold-to-clear.
- **Scale Animations**: Tap interactions trigger an immediate 80ms `ScaleTransition` (down to `0.96` scale), providing instant visual confirmation of intent.

**Checkout Speed Optimization:**
- Product tap: IMMEDIATE scale animation, haptic click, + cart count update (optimistic)
- No modal confirmation on add (too slow)
- Quantity stepper: hold + to increase continuously (after 500ms)
- NumPad: hold-to-clear backspace functionality (after 500ms hold)
- Cart total: real-time updates

**Error Feedback:**
- Red shake animation on wrong PIN
- Red border pulse on invalid form field
- Toast at top (not bottom — blocked by nav)

**Payment UX:**
- Success: Full-screen green flash (100ms) before success card
- Change calculation: Shown as user types, large font

**Navigation:**
- No hamburger menus — bottom nav only
- Back button always present
- Swipe-to-go-back enabled

### Files Created/Modified

| File | Purpose |
|------|---------|
| `lib/core/theme/app_colors.dart` | Color system |
| `lib/core/theme/app_text_styles.dart` | Typography |
| `lib/core/theme/app_spacing.dart` | Spacing system |
| `lib/core/theme/app_extensions.dart` | ThemeExtension classes |
| `lib/core/theme/app_theme.dart` | Complete ThemeData |
| `lib/shared/widgets/buttons/` | Button widgets |
| `lib/shared/widgets/cards/` | Card widgets |
| `lib/shared/widgets/displays/` | Display widgets |
| `lib/shared/widgets/inputs/` | Input widgets |
| `lib/shared/widgets/layouts/` | Layout widgets |
| `lib/shared/widgets/feedback/` | Feedback widgets |
| `lib/shared/widgets/widgets.dart` | Barrel export |
| `lib/core/localization/app_en.arb` | Updated English strings |
| `lib/core/localization/app_km.arb` | Updated Khmer strings |
| `lib/features/pos/presentation/screens/pos_screen.dart` | Example wireframe |

### Dependencies Added

```yaml
dependencies:
  shimmer: ^3.0.0        # Loading skeletons
  google_fonts: ^6.1.0   # Noto Sans, Roboto Mono
```

---

## Contact & References

- **Project:** KhmerBiz POS
- **Architecture:** Clean Architecture + BLoC
- **State Management:** flutter_bloc
- **Local Database:** Drift (SQLite)
- **Navigation:** go_router
- **Design System:** Material 3 with Khmer customization

---

## Architecture & Data Layer Update (2026-03-29)

### Key Architectural Decisions Made
- **Local Database Engine**: Built with `drift` (v2.15+ mapped locally to 2.21+), enforcing single source of truth locally offline.
- **Database Encryption**: Enforced `sqlcipher_flutter_libs` to replace `sqlite3_flutter_libs` with an AES-256 encrypted local `.db` file using `flutter_secure_storage`.
- **Atomic Operations Design**: Hardened `processSale` and `adjustStock` inside Drift transactions.
- **Strict Domain mapping**: Used pure Dart (`Equatable`) without Flutter bindings or generated `freezed` tags. Drift models are converted manually at boundary points (RepositoryImpls).
- **Functional Error Handling**: Introduced `fpdart` to enforce operations resolving to `Either<Failure, Model>` inside Repository definitions.
- **Cart & Checkout Architecture**: Integrated `CartBloc` to track real-time subtotal, taxes, constraints on discounts, and robust stock verifications that perform fresh database checks right before emitting `CartCheckoutSuccess`. The entire UI flow transitions via a `BlocConsumer`. 

### Package Versions Locked
- `sqlcipher_flutter_libs`: ^0.7.0+eol
- `fpdart`: ^1.1.0
- `uuid`: ^4.2.2

### Deviations from the prompt
- Merged some DAOs inside the central Drift `database.dart` setup configuration via `@DriftDatabase(daos: [...])`. 
- Since `sync_queue` payloads are `TEXT`, serialization inside Drift or early stage was deferred entirely to Repository handling instead. 
- Integrated Checkout Logic into a standalone `CheckoutScreen` handling phone-specific flow directly instead of merging entirely into a singular `pos_screen.dart` to maintain distinct responsibility, whereas Tablet layout maps right alongside POS layout conceptually. 

### Open questions for next session
1. **Repository/DI wiring**: Since many DAOs have been created, does the frontend or Injectable pipeline assume a specific lifecycle (like `Singleton` vs `LazySingleton` on Database access points)?
2. **Product Syncing Mechanism**: Before implementing WorkManager sync loops, should we create an endpoint to consume synced chunks?
3. **Transaction Sequencing Edge Case**: How should receipt sequence handle counting if today's transaction count gets permanently deleted from the mobile SQLite instance? 
4. **Printer Abstraction**: How will auto-print be triggered directly from the success UI state transparently without UI blocking?

---

## Cart and Checkout Architecture Update (2026-03-30)

### Key Architectural Decisions Made
- **CartBloc as Source of Truth**: Evaluated calculations like subtotals and dynamic discounts internally within the `CartBloc`. The Bloc explicitly manages total USD generation with a mock/exchange rate repository call logic before storing.
- **Stock Constraint Integrity Validation**: Validated real-time stock limitations twice: optimally inside the `AddToCart` event as warnings and rigidly during `ProcessCheckout` using a fresh `ProductRepository` fetch. 

### Package Versions Locked
- `lottie`: ^3.3.2 

### Deviations from the prompt
- Used `double` natively on internal item logic instead of strict mapping because Dart inherently relies upon them for UI bindings. Handled exactitude by mapping rounding (`total = total.roundToDouble()`) prior to state emission.
- Did not integrate a `lottie` checkmark asset properly into `checkout_success_screen.dart` via `Lottie.asset` due to the lack of an existing correct `.json`. Utilized `AnimatedBuilder` with `ColorTween` to provide the requested visual flash instead.
- Screen brightness adjustment for Checkout Success deferred until adding a brightness plugin could be validated. Currently using system levels. 

### Open questions for next session
1. **Lottie vs Flutter native Animations**: Would you like to keep the native Flutter `AnimationController` for checkout success, or should we locate/generate a `.json` lottie file to insert the bouncy checkmark?
2. **Printer Abstraction Details**: The success screen auto-navigates after 30s as requested. Which specific flutter printing library (like `esc_pos_bluetooth` or `printing`) should be used for the non-blocking print operation?
3. **Multi-Payment Edge Cases**: How should partial deposits or split payments work if the user pays via multiple PaymentMethods at once (e.g. half cash, half KHQR)?
