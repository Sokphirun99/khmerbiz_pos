## 2026-03-30 - Accessible Custom Gestures Buttons
**Learning:** Using `GestureDetector` directly on a `Container` strips out essential accessibility functionality like screen reader announcement and long-press tooltips that native `IconButton` offers.
**Action:** When building custom icon buttons with `GestureDetector`, wrap them in `Semantics(button: true, label: tooltip...)` and `Tooltip(message: tooltip...)` to restore basic accessibility and affordance.
