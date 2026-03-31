import 'package:equatable/equatable.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/domain/repositories/bluetooth_printer_repository.dart';

/// Base class for all printer-related states.
sealed class PrinterState extends Equatable {
  /// Creates a [PrinterState].
  const PrinterState();

  @override
  List<Object?> get props => [];
}

/// Initial state - no printer connected.
final class PrinterDisconnected extends PrinterState {
  /// Creates a [PrinterDisconnected] state.
  const PrinterDisconnected();
}

/// Scanning for available printers.
final class PrinterScanning extends PrinterState {
  /// Creates a [PrinterScanning] state.
  const PrinterScanning({required this.foundDevices});

  /// List of discovered printer devices.
  final List<BluetoothPrinterDevice> foundDevices;

  @override
  List<Object?> get props => [foundDevices];
}

/// Connecting to a printer device.
final class PrinterConnecting extends PrinterState {
  /// Creates a [PrinterConnecting] state.
  const PrinterConnecting({required this.device});

  /// The device being connected to.
  final BluetoothPrinterDevice device;

  @override
  List<Object?> get props => [device];
}

/// Printer is connected and ready.
final class PrinterConnected extends PrinterState {
  /// Creates a [PrinterConnected] state.
  const PrinterConnected({
    required this.device,
    required this.paperSize,
    this.fontSize = PrinterFontSize.normal,
  });

  /// The connected printer device.
  final BluetoothPrinterDevice device;

  /// The configured paper size.
  final PaperSize paperSize;

  /// The configured font size.
  final PrinterFontSize fontSize;

  @override
  List<Object?> get props => [device, paperSize, fontSize];
}

/// Currently printing a receipt.
final class PrinterPrinting extends PrinterState {
  /// Creates a [PrinterPrinting] state.
  const PrinterPrinting({required this.transactionId});

  /// The transaction ID being printed.
  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

/// Print operation completed successfully.
final class PrinterSuccess extends PrinterState {
  /// Creates a [PrinterSuccess] state.
  const PrinterSuccess({required this.transactionId});

  /// The transaction ID that was printed.
  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}

/// Printer error occurred.
final class PrinterError extends PrinterState {
  /// Creates a [PrinterError] state.
  const PrinterError({
    required this.failure,
    this.lastTransactionId,
  });

  /// The failure that occurred.
  final PrinterFailure failure;

  /// The transaction ID of the last print attempt (for retry).
  final String? lastTransactionId;

  @override
  List<Object?> get props => [failure, lastTransactionId];
}
