/// Reasons for inventory stock adjustments.
enum AdjustmentReason {
  receivedStock('received_stock', 'Received Stock', 'ទទួលស្តុក'),
  damaged('damaged', 'Damaged', 'ខូច'),
  expired('expired', 'Expired', 'ផុតកំណត់'),
  countCorrection('count_correction', 'Count Correction', 'កែតម្រូវចំនួន'),
  returnedByCustomer(
      'returned_by_customer', 'Returned by Customer', 'អតិថិជនប្រគល់មកវិញ'),
  other('other', 'Other', 'ផ្សេងៗ');

  const AdjustmentReason(this.value, this.labelEn, this.labelKh);

  final String value;
  final String labelEn;
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
