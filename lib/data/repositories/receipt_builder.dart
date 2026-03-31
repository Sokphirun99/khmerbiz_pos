import 'dart:typed_data';

import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/domain/entities/transaction_with_items.dart';

/// Business information for receipt header.
final class BusinessInfo {
  /// Creates a [BusinessInfo].
  BusinessInfo({
    required this.nameKh,
    required this.nameEn,
    required this.addressKh,
    required this.addressEn,
    required this.phone,
    this.website,
    this.logoBytes,
  });

  /// Business name in Khmer.
  final String nameKh;

  /// Business name in English.
  final String nameEn;

  /// Address in Khmer.
  final String addressKh;

  /// Address in English.
  final String addressEn;

  /// Phone number.
  final String phone;

  /// Website URL.
  final String? website;

  /// Logo image bytes (optional).
  final Uint8List? logoBytes;
}

/// Printer configuration.
final class PrinterConfig {
  /// Creates a [PrinterConfig].
  const PrinterConfig({
    this.paperSize = PaperSize.mm80,
    this.fontSize = PrinterFontSize.normal,
    this.printKhmerAsBitmap = true,
  });

  /// Paper size.
  final PaperSize paperSize;

  /// Font size.
  final PrinterFontSize fontSize;

  /// Whether to render Khmer text as bitmap (for compatibility).
  final bool printKhmerAsBitmap;

  /// Get characters per line based on paper size.
  int get charsPerLine => paperSize.charsPerLine;
}

/// ESC/POS receipt builder with Khmer text support.
///
/// This builder creates ESC/POS commands for thermal printers.
/// Khmer text is rendered as bitmap images since most thermal printers
/// don't support Khmer Unicode characters natively.
class ReceiptBuilder {
  /// Creates a [ReceiptBuilder].
  ReceiptBuilder({required this.config});

  /// Printer configuration.
  final PrinterConfig config;

  /// Build receipt bytes for a transaction.
  Future<List<int>> buildReceipt(TransactionWithItems transaction) async {
    final bytes = <int>[];

    // Initialize printer
    bytes.addAll(EscPosCommands.init);

    // Header with business info
    bytes.addAll(_buildHeader());

    // Transaction info
    bytes.addAll(_buildTransactionInfo(transaction));

    // Divider
    bytes.addAll(_buildDivider());

    // Items
    bytes.addAll(await _buildItems(transaction));

    // Divider
    bytes.addAll(_buildDivider());

    // Totals
    bytes.addAll(_buildTotals(transaction));

    // Payment info
    bytes.addAll(_buildPaymentInfo(transaction));

    // Customer points (if applicable)
    if (transaction.customer != null) {
      bytes.addAll(_buildDivider());
      bytes.addAll(_buildCustomerPoints(transaction));
    }

    // Footer
    bytes.addAll(_buildDivider());
    bytes.addAll(_buildFooter());

    // Cut paper
    bytes.addAll(EscPosCommands.cutPaperPartial);

    return bytes;
  }

  List<int> _buildHeader() {
    final bytes = <int>[];

    // Business name (centered, bold, double size)
    bytes.addAll(EscPosCommands.alignCenter);
    bytes.addAll(EscPosCommands.boldOn);
    bytes.addAll(EscPosCommands.doubleSize);

    // For now, use English name only (Khmer would require bitmap rendering)
    // In production, you'd render Khmer as bitmap
    bytes.addAll('KHMERBIZ POS'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Reset text size
    bytes.addAll(EscPosCommands.normalSize);
    bytes.addAll(EscPosCommands.boldOff);

    // Address
    bytes.addAll('Phnom Penh, Cambodia'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Phone
    bytes.addAll('Tel: +855 12 345 678'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    return bytes;
  }

  List<int> _buildTransactionInfo(TransactionWithItems transaction) {
    final bytes = <int>[];

    bytes.addAll(EscPosCommands.alignLeft);

    // Receipt number
    bytes.addAll('Receipt: ${transaction.receiptNumber}'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Date
    final dateStr = transaction.transactionDate.toString().substring(0, 16);
    bytes.addAll('Date: $dateStr'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Cashier (placeholder - would come from auth)
    bytes.addAll('Cashier: Staff'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Customer (if applicable)
    if (transaction.customer != null) {
      bytes.addAll('Member: ${transaction.customer!.name}'.codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);
    }

    return bytes;
  }

  List<int> _buildDivider() {
    final bytes = <int>[];
    final line = '─' * config.charsPerLine;
    bytes.addAll(line.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);
    return bytes;
  }

  Future<List<int>> _buildItems(TransactionWithItems transaction) async {
    final bytes = <int>[];

    for (final item in transaction.items) {
      // Product name (Khmer - would be bitmap in production)
      bytes.addAll(EscPosCommands.alignLeft);
      bytes.addAll(item.productNameSnapshot.codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);

      // Quantity × Price
      final qtyStr = item.quantity.toStringAsFixed(item.quantity % 1 == 0 ? 0 : 1);
      final priceStr = _formatCurrency(item.unitPrice);
      bytes.addAll('  $qtyStr × $priceStr'.codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);

      // Subtotal for this item (right aligned)
      final itemTotal = item.subtotal;
      bytes.addAll(EscPosCommands.alignRight);
      bytes.addAll(_formatCurrency(itemTotal).codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);

      // Modifiers (if any)
      if (item.modifiers != null && item.modifiers!.isNotEmpty) {
        // Parse and display modifiers
        bytes.addAll(EscPosCommands.alignLeft);
        bytes.addAll('    (modifiers)'.codeUnits);
        bytes.addAll(EscPosCommands.printAndCarriageReturn);
      }

      bytes.addAll(EscPosCommands.printLine);
    }

    return bytes;
  }

  List<int> _buildTotals(TransactionWithItems transaction) {
    final bytes = <int>[];

    // Subtotal
    bytes.addAll(EscPosCommands.alignLeft);
    bytes.addAll('Subtotal:'.codeUnits);
    bytes.addAll(EscPosCommands.alignRight);
    bytes.addAll(_formatCurrency(transaction.subtotal).codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Discount
    if (transaction.discountAmount > 0) {
      bytes.addAll(EscPosCommands.alignLeft);
      bytes.addAll('Discount:'.codeUnits);
      bytes.addAll(EscPosCommands.alignRight);
      bytes.addAll('-${_formatCurrency(transaction.discountAmount)}'.codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);
    }

    // Tax
    if (transaction.taxAmount > 0) {
      bytes.addAll(EscPosCommands.alignLeft);
      bytes.addAll('Tax:'.codeUnits);
      bytes.addAll(EscPosCommands.alignRight);
      bytes.addAll(_formatCurrency(transaction.taxAmount).codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);
    }

    // Double divider before total
    final doubleLine = '═' * config.charsPerLine;
    bytes.addAll(doubleLine.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Total
    bytes.addAll(EscPosCommands.boldOn);
    bytes.addAll(EscPosCommands.alignLeft);
    bytes.addAll('TOTAL:'.codeUnits);
    bytes.addAll(EscPosCommands.alignRight);
    bytes.addAll(_formatCurrency(transaction.totalAmount).codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);
    bytes.addAll(EscPosCommands.boldOff);

    // USD equivalent
    bytes.addAll(EscPosCommands.alignRight);
    bytes.addAll('~${_formatUSD(transaction.totalAmountUSD)}'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    return bytes;
  }

  List<int> _buildPaymentInfo(TransactionWithItems transaction) {
    final bytes = <int>[];

    bytes.addAll(EscPosCommands.alignLeft);
    bytes.addAll('Payment: ${transaction.paymentMethod.toUpperCase()}'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Cash payment details
    if (transaction.paymentMethod == 'cash') {
      if (transaction.cashReceived != null) {
        bytes.addAll('Received: ${_formatCurrency(transaction.cashReceived!)}'.codeUnits);
        bytes.addAll(EscPosCommands.printAndCarriageReturn);
      }
      if (transaction.changeGiven != null) {
        bytes.addAll('Change: ${_formatCurrency(transaction.changeGiven!)}'.codeUnits);
        bytes.addAll(EscPosCommands.printAndCarriageReturn);
      }
    }

    // KHQR reference
    if (transaction.paymentMethod == 'khqr' && transaction.khqrReference != null) {
      bytes.addAll('Ref: ${transaction.khqrReference}'.codeUnits);
      bytes.addAll(EscPosCommands.printAndCarriageReturn);
    }

    return bytes;
  }

  List<int> _buildCustomerPoints(TransactionWithItems transaction) {
    final bytes = <int>[];
    final customer = transaction.customer!;

    // Points earned (simplified - would calculate based on transaction)
    final pointsEarned = (transaction.totalAmount / 1000).round();
    bytes.addAll('Points earned: +$pointsEarned'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Total points
    bytes.addAll('Total points: ${customer.loyaltyPoints.round()}'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    return bytes;
  }

  List<int> _buildFooter() {
    final bytes = <int>[];

    bytes.addAll(EscPosCommands.alignCenter);

    // Thank you message
    bytes.addAll('សូមអរគុណ! / Thank you!'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Website
    bytes.addAll('www.khmerbizkh.com'.codeUnits);
    bytes.addAll(EscPosCommands.printAndCarriageReturn);

    // Blank lines for tear-off
    for (var i = 0; i < 3; i++) {
      bytes.addAll(EscPosCommands.printLine);
    }

    return bytes;
  }

  String _formatCurrency(double amount) {
    // Format as Cambodian Riel (៛)
    if (amount >= 1000) {
      return '៛${(amount / 1000).toStringAsFixed(1)}K';
    }
    return '៛${amount.toStringAsFixed(0)}';
  }

  String _formatUSD(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}

/// ESC/POS command constants for receipt building.
class EscPosCommands {
  static const List<int> init = [0x1B, 0x40];
  static const List<int> printLine = [0x0A];
  static const List<int> printAndCarriageReturn = [0x0D, 0x0A];
  static const List<int> alignLeft = [0x1B, 0x61, 0x00];
  static const List<int> alignCenter = [0x1B, 0x61, 0x01];
  static const List<int> alignRight = [0x1B, 0x61, 0x02];
  static const List<int> boldOn = [0x1B, 0x45, 0x01];
  static const List<int> boldOff = [0x1B, 0x45, 0x00];
  static const List<int> doubleSize = [0x1D, 0x21, 0x11];
  static const List<int> normalSize = [0x1D, 0x21, 0x00];
  static const List<int> underlineOn = [0x1B, 0x2D, 0x01];
  static const List<int> underlineOff = [0x1B, 0x2D, 0x00];
  static const List<int> cutPaper = [0x1D, 0x56, 0x00];
  static const List<int> cutPaperPartial = [0x1D, 0x56, 0x01];
  static const List<int> openDrawer = [0x1B, 0x70, 0x00, 0x3C, 0xFF];
}
