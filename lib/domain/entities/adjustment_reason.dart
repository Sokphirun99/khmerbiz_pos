/// Reasons for inventory stock adjustments.
enum AdjustmentReason {
  /// Stock received from supplier.
  receivedStock('received_stock', 'Received Stock', 'ទទួលស្តុក'),

  /// Items are damaged and removed from stock.
  damaged('damaged', 'Damaged', 'ខូច'),

  /// Items are expired and removed from stock.
  expired('expired', 'Expired', 'ផុតកំណត់'),

  /// Manual correction after physical stock count.
  countCorrection('count_correction', 'Count Correction', 'កែតម្រូវចំនួន'),

  /// Item returned by customer and added back to stock.
  returnedByCustomer(
    'returned_by_customer',
    'Returned by Customer',
    'អតិថិជនប្រគល់មកវិញ',
  ),

  /// Other miscellaneous reasons.
  other('other', 'Other', 'ផ្សេងៗ');

  /// Creates an [AdjustmentReason].
  const AdjustmentReason(this.value, this.labelEn, this.labelKh);

  /// Machine-readable value stored in the database.
  final String value;

  /// Human-readable label in English.
  final String labelEn;

  /// Human-readable label in Khmer.
  final String labelKh;

  /// Whether this reason adds stock (positive delta).
  bool get isStockIn =>
      this == AdjustmentReason.receivedStock ||
      this == AdjustmentReason.returnedByCustomer ||
      this == AdjustmentReason.countCorrection;

  /// Parse from stored string value.
  static AdjustmentReason fromValue(String value) {
    return AdjustmentReason.values.firstWhere(
      (r) => r.value == value,
      orElse: () => AdjustmentReason.other,
    );
  }
}
