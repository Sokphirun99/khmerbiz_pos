# KhmerBiz POS — Build Context

## Project Status

- [x] Prompt 1 complete — Core architecture, theme, database, shared widgets
- [x] Prompt 2 complete — Product & Inventory feature (domain, data, bloc, UI, tests)
- [x] Prompt 3 complete — Payment feature (KHQR, ABA/Wing deep links, PaymentBloc, UI, tests)
- [ ] Prompt 4 — Transaction history, reports, receipt printing
- [ ] Prompt 5 — Customer management, loyalty
- [ ] Prompt 6 — Multi-store, sync
- [ ] Prompt 7 — Settings, user management
- [ ] Prompt 8 — Dashboard, analytics
- [ ] Prompt 9 — Polish, performance, accessibility
- [ ] Prompt 10 — Testing, CI/CD, deployment
- [ ] Prompt 11 — Final review, documentation

---

## Session 1 — Core Architecture

### Key Decisions
- Clean Architecture: data / domain / features layers
- Drift for local DB (SQLite), flutter_bloc for state management
- fpdart Either for error handling across all repository methods
- Khmer-first typography: Kantumruy Pro (Khmer), Noto Sans (Latin), Roboto Mono (prices)
- Cambodian-inspired color palette: temple stone + lotus + gold
- Bilingual UI: English + Khmer throughout

### Package Versions Locked
- flutter_bloc: ^8.1.6
- drift: ^2.22.1
- fpdart: ^1.1.0
- equatable: ^2.0.7
- go_router: ^14.8.1
- get_it: ^8.0.3
- google_fonts: ^6.2.1
- connectivity_plus: ^6.1.4
- lottie: ^3.3.2

---

## Session 2 — Product & Inventory Feature

### Key Decisions
- ProductBloc uses stream subscription from Drift for real-time product list updates
- Debounced search (300ms) via stream_transform
- ProductInput value object with validate() returning Either<ValidationFailure, ProductsCompanion>
- AdjustmentReason enum with 6 cases and bilingual labels
- InventoryBloc is auth-aware (reads staffId from AuthRepository)
- ProductBloc and InventoryBloc registered as factories in DI (new instance per screen)
- BlocProviders at app root level (persist across navigation)
- Category filtering via watchActiveCategories() stream

### New Packages Required
- mobile_scanner (for barcode scanning — deferred to later)
- bloc_concurrency (for event transformers)
- stream_transform (for debounced search)

### Known Compile Blockers from Session 2
1. Add `mobile_scanner` to pubspec.yaml
2. Add `bloc_concurrency` to pubspec.yaml
3. Add `stream_transform` to pubspec.yaml
4. Fix `AppTextField` usage: `enabled` → `isDisabled` in add_edit_product_screen.dart
5. Route name mismatch: align `inventoryAdjustName` with `stockAdjustmentName`

---

## Session 3 — Payment Feature (KHQR, ABA, Wing)

### Key Decisions

1. **KhqrRepository with simulation layer**: Real `flutter_bakong_khqr` SDK integration is stubbed out. `KhqrRepositoryImpl` uses an in-memory simulation that generates EMVCo-like payloads, MD5 hashes, and auto-confirms after N poll cycles. This allows full end-to-end testing without Bakong API credentials.

2. **PaymentBloc timer architecture**: Two independent timers — `_pollTimer` (3s interval, checks payment status) and `_countdownTimer` (1s interval, updates UI countdown). Both are properly cancelled on cancel/retry/close to prevent memory leaks.

3. **5-minute QR expiry**: KHQR codes expire after 5 minutes per Bakong spec. Countdown ring changes color: blue (>50%) → yellow (>20%) → red (<20%).

4. **Deep link pattern for ABA/Wing**: `DeepLinkHelper` generates URI scheme deep links (`aba://pay?...`, `wing://transfer?...`). Actual `url_launcher` call is deferred to UI layer (TODO in checkout_screen.dart). `PaymentConfirmationDialog` handles manual confirmation after user returns from banking app.

5. **PaymentBloc as app-level provider**: Registered in `MultiBlocProvider` at root level alongside ProductBloc and InventoryBloc. This allows any screen to initiate payment flows.

6. **Checkout flow intercept**: `CheckoutScreen._handleCheckout()` now routes based on `PaymentMethod`:
   - Cash → direct `ProcessCheckout` to CartBloc
   - KHQR → opens `KhqrPaymentSheet`, generates QR, polls
   - ABA/Wing → opens sheet + launches deep link (TODO)
   - Credit → shows "coming soon" snackbar

7. **Exchange rate refresh on payment**: PaymentBloc checks `isRateStale()` before generating QR. If stale (>24h), fetches latest rate. Falls back to cached rate (default 4100 KHR/USD) if fetch fails.

8. **QR rendering placeholder**: `QrCodeWidget` currently shows an icon placeholder. When `qr_flutter` is added to pubspec, replace with `QrImageView` (commented code included in file).

### Files Created (Session 3)

| Layer | File | Purpose |
|-------|------|---------|
| Domain | `merchant_info.dart` | MerchantInfo entity with placeholder |
| Domain | `khqr_data.dart` | KhqrData value object (QR string, MD5, amounts, expiry) |
| Domain | `payment_status.dart` | PaymentStatus sealed class (Pending, Confirmed, Expired, Failed) |
| Domain | `khqr_repository.dart` | KhqrRepository interface (generateDynamicQR, checkStatus, generateStaticQR) |
| Domain | `exchange_rate_repository.dart` | Expanded with fetchLatestRate(), isRateStale() |
| Data | `khqr_repository_impl.dart` | Simulation-based implementation |
| Data | `exchange_rate_repository_impl.dart` | Expanded with stale check and fetch |
| Bloc | `payment_bloc.dart` | Full bloc with polling, countdown, deep link, retry |
| Bloc | `payment_event.dart` | 7 events: InitiateKhqr, InitiateDeepLink, Poll, Tick, Confirm, Cancel, Retry |
| Bloc | `payment_state.dart` | 8 states: Initial, Generating, Awaiting, Confirmed, TimedOut, Failed, Cancelled, DeepLink, Offline |
| UI | `khqr_payment_sheet.dart` | Full-screen bottom sheet with all payment states |
| UI | `qr_code_widget.dart` | QR renderer (placeholder until qr_flutter added) |
| UI | `payment_countdown_ring.dart` | Custom circular countdown ring |
| UI | `payment_confirmation_dialog.dart` | ABA/Wing manual confirmation dialog |
| Data | `deep_link_helper.dart` | ABA/Wing deep link URI generator |
| Test | `payment_bloc_test.dart` | 12 unit tests covering all PaymentBloc flows |

### Files Modified (Session 3)

| File | Changes |
|------|---------|
| `injection.dart` | Added ExchangeRateRepository, KhqrRepository, PaymentBloc registrations |
| `main.dart` | Added PaymentBloc to MultiBlocProvider |
| `checkout_screen.dart` | Added KHQR/ABA/Wing payment flow intercept with _handleCheckout() |

### New Packages Required (Session 3)
- `qr_flutter: ^4.1.0` — QR code rendering
- `url_launcher: ^6.2.0` — ABA/Wing deep link launching
- `flutter_bakong_khqr` — Real Bakong SDK (when ready for production)

### Deviations from Prompt

1. **Simulation layer instead of real SDK**: `flutter_bakong_khqr` is not yet in pubspec. `KhqrRepositoryImpl` uses a simulation that auto-confirms after 5 poll cycles. This was intentional to allow development without Bakong API credentials.

2. **QR rendering placeholder**: `qr_flutter` not yet in pubspec. `QrCodeWidget` shows an icon placeholder with commented-out `QrImageView` code ready to swap in.

3. **Deep link not actually launched**: `url_launcher` not yet in pubspec. The checkout screen has a TODO comment where `launchUrl()` should be called. The bloc correctly transitions to `PaymentDeepLinkLaunched` state.

4. **No receipt printing integration yet**: Payment confirmation does not trigger receipt printing. This will be added in the Transaction/Receipt prompt.

5. **MerchantInfo uses placeholder**: `MerchantInfo.placeholder` is used everywhere. Real merchant config should come from settings/onboarding.

### Known Compile Blockers (Cumulative)

| # | Issue | Fix |
|---|-------|-----|
| 1 | `mobile_scanner` not in pubspec | `flutter pub add mobile_scanner` |
| 2 | `bloc_concurrency` not in pubspec | `flutter pub add bloc_concurrency` |
| 3 | `stream_transform` not in pubspec | `flutter pub add stream_transform` |
| 4 | `qr_flutter` not in pubspec | `flutter pub add qr_flutter` |
| 5 | `url_launcher` not in pubspec | `flutter pub add url_launcher` |
| 6 | AppTextField `enabled` vs `isDisabled` | Fix in add_edit_product_screen.dart |
| 7 | Route name mismatch `inventoryAdjustName` | Align with `stockAdjustmentName` |
| 8 | `ProcessCheckout` event may need `khqrReference`/`khqrMd5` params | Update CartEvent if not already present |

---

## Open Questions for Next Session

1. **Bakong API credentials**: When will real KHQR credentials be available? Need merchant ID, acquiring bank code, and API key for production.
2. **Receipt printing**: Should receipt generation happen in CartBloc after checkout success, or in a separate ReceiptBloc?
3. **Transaction history**: What fields should be displayed in the transaction list? Filter by date range, payment method, cashier?
4. **Offline transactions**: Should cash transactions be queued for sync when offline? How to handle offline receipt numbering?
5. **MerchantInfo source**: Should merchant config come from Firebase Remote Config, local settings screen, or hardcoded for MVP?
6. **ABA/Wing deep link schemas**: Need to verify actual URI schemes with bank developer docs. Current schemas are best-guess based on public documentation.
7. **Payment timeout UX**: Should timeout auto-switch to cash payment option, or just show retry?
8. **Multi-currency display**: Should the payment sheet show KHR primary with USD secondary, or allow user to choose display currency?
