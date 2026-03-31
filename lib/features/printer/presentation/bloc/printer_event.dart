import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/domain/repositories/bluetooth_printer_repository.dart';

/// Base class for all printer-related events.
sealed class PrinterEvent extends Equatable {
  /// Creates a [PrinterEvent].
  const PrinterEvent();

  @override
  List<Object?> get props => [];
}

/// Scan for available Bluetooth printers.
final class ScanForPrinters extends PrinterEvent {
  /// Creates a [ScanForPrinters] event.
  const ScanForPrinters();
}

/// Connect to a specific printer device.
final class ConnectPrinter extends PrinterEvent {
  /// Creates a [ConnectPrinter] event.
  const ConnectPrinter({required this.device});

  /// The printer device to connect to.
  final BluetoothPrinterDevice device;

  @override
  List<Object?> get props => [device];
}

/// Disconnect from the currently connected printer.
final class DisconnectPrinter extends PrinterEvent {
  /// Creates a [DisconnectPrinter] event.
  const DisconnectPrinter();
}

/// Print a receipt for a transaction.
final class PrintReceipt extends PrinterEvent {
  /// Creates a [PrintReceipt] event.
  const PrintReceipt({required this.transactionId});

  /// The transaction ID to print.
  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

/// Print a test page.
final class PrintTestPage extends PrinterEvent {
  /// Creates a [PrintTestPage] event.
  const PrintTestPage();
}

/// Retry the last print operation.
final class RetryLastPrint extends PrinterEvent {
  /// Creates a [RetryLastPrint] event.
  const RetryLastPrint();
}

/// Set the paper size.
final class SetPaperSize extends PrinterEvent {
  /// Creates a [SetPaperSize] event.
  const SetPaperSize({required this.size});

  /// The paper size to use.
  final PaperSize size;

  @override
  List<Object?> get props => [size];
}

/// Set the font size.
final class SetFontSize extends PrinterEvent {
  /// Creates a [SetFontSize] event.
  const SetFontSize({required this.size});

  /// The font size to use.
  final PrinterFontSize size;

  @override
  List<Object?> get props => [size];
}

/// Silent reconnect to last saved printer (on app init).
final class SilentReconnect extends PrinterEvent {
  /// Creates a [SilentReconnect] event.
  const SilentReconnect();
}
