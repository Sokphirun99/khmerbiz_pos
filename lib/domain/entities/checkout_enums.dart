/// Supported payment methods for transactions.
enum PaymentMethod {
  /// Physical cash (KHR or USD).
  cash,

  /// Dynamic or Static KHQR payment.
  khqr,

  /// Direct ABA bank transfer.
  aba,

  /// Wing Money transfer.
  wing,

  /// Credit/Debit card payment.
  credit,
}

/// Types of discounts that can be applied to items or totals.
enum DiscountType {
  /// Percentage-based discount (e.g., 10%).
  percent,

  /// Fixed amount discount (e.g., ៛5,000).
  fixed,
}
