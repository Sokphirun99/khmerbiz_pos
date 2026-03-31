import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/core/storage/secure_storage_helper.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/domain/repositories/bluetooth_printer_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_event.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BLoC managing Bluetooth printer operations.
/// 
/// Note: Bluetooth printer feature is deferred to v1.1.0
/// Current implementation provides stub methods for future integration.
class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  /// Creates a [PrinterBloc] with required dependencies.
  PrinterBloc({
    required BluetoothPrinterRepository bluetoothPrinterRepository,
    required TransactionRepository transactionRepository,
    required SecureStorageHelper secureStorage,
  })  : _bluetoothPrinterRepository = bluetoothPrinterRepository,
        _transactionRepository = transactionRepository,
        _secureStorage = secureStorage,
        super(const PrinterDisconnected()) {
    on<ScanForPrinters>(_onScanForPrinters);
    on<ConnectPrinter>(_onConnectPrinter);
    on<DisconnectPrinter>(_onDisconnectPrinter);
    on<PrintReceipt>(_onPrintReceipt);
    on<PrintTestPage>(_onPrintTestPage);
    on<RetryLastPrint>(_onRetryLastPrint);
    on<SetPaperSize>(_onSetPaperSize);
    on<SetFontSize>(_onSetFontSize);
    on<SilentReconnect>(_onSilentReconnect);

    _loadSavedPrinter();
  }

  final BluetoothPrinterRepository _bluetoothPrinterRepository;
  final TransactionRepository _transactionRepository;
  final SecureStorageHelper _secureStorage;

  PaperSize _currentPaperSize = PaperSize.mm80;
  PrinterFontSize _currentFontSize = PrinterFontSize.normal;

  // ── Silent Reconnect ─────────────────────────────────────────────────────

  Future<void> _onSilentReconnect(
    SilentReconnect event,
    Emitter<PrinterState> emit,
  ) async {
    // TODO: Implement in v1.1.0 when Bluetooth printer is ready
    // For now, just stay in disconnected state
    return;
  }

  // ── Scan ─────────────────────────────────────────────────────────────────

  Future<void> _onScanForPrinters(
    ScanForPrinters event,
    Emitter<PrinterState> emit,
  ) async {
    // TODO: Implement in v1.1.0
    // For now, return empty scan results
    emit(const PrinterScanning(foundDevices: []));
    
    // Simulate scan completion
    await Future.delayed(const Duration(seconds: 2));
    emit(const PrinterScanning(foundDevices: []));
  }

  // ── Connect ──────────────────────────────────────────────────────────────

  Future<void> _onConnectPrinter(
    ConnectPrinter event,
    Emitter<PrinterState> emit,
  ) async {
    // TODO: Implement in v1.1.0
    emit(const PrinterError(
      failure: PrinterFailure(
        messageEn: 'Printer feature coming in v1.1.0',
        messageKm: 'មុខងារម៉ាស៊ីនបោះពុម្ពនឹងមាននៅក្នុង v1.1.0',
      ),
    ),);
  }

  // ── Disconnect ───────────────────────────────────────────────────────────

  Future<void> _onDisconnectPrinter(
    DisconnectPrinter event,
    Emitter<PrinterState> emit,
  ) async {
    await _bluetoothPrinterRepository.disconnect();
    emit(const PrinterDisconnected());
  }

  // ── Print Receipt ────────────────────────────────────────────────────────

  Future<void> _onPrintReceipt(
    PrintReceipt event,
    Emitter<PrinterState> emit,
  ) async {
    // TODO: Implement in v1.1.0
    // For now, return error that printer is not available
    emit(const PrinterError(
      failure: PrinterFailure(
        messageEn: 'Printer not connected. Please connect a printer first.',
        messageKm: 'ម៉ាស៊ីនបោះពុម្ពមិនបានតភ្ជាប់ទេ។ សូមតភ្ជាប់ម៉ាស៊ីនបោះពុម្ពជាមុនសិន។',
      ),
    ),);
  }

  // ── Print Test Page ──────────────────────────────────────────────────────

  Future<void> _onPrintTestPage(
    PrintTestPage event,
    Emitter<PrinterState> emit,
  ) async {
    // TODO: Implement in v1.1.0
    emit(const PrinterError(
      failure: PrinterFailure(
        messageEn: 'Printer not available',
        messageKm: 'ម៉ាស៊ីនបោះពុម្ពមិនអាចប្រើបាន',
      ),
    ),);
  }

  // ── Retry Last Print ─────────────────────────────────────────────────────

  Future<void> _onRetryLastPrint(
    RetryLastPrint event,
    Emitter<PrinterState> emit,
  ) async {
    // TODO: Implement in v1.1.0
    emit(const PrinterError(
      failure: PrinterFailure(
        messageEn: 'No printer connected',
        messageKm: 'គ្មានម៉ាស៊ីនបោះពុម្ពតភ្ជាប់',
      ),
    ),);
  }

  // ── Set Paper Size ───────────────────────────────────────────────────────

  Future<void> _onSetPaperSize(
    SetPaperSize event,
    Emitter<PrinterState> emit,
  ) async {
    _currentPaperSize = event.size;
    await _savePaperSize(event.size);

    emit(const PrinterDisconnected());
  }

  // ── Set Font Size ────────────────────────────────────────────────────────

  Future<void> _onSetFontSize(
    SetFontSize event,
    Emitter<PrinterState> emit,
  ) async {
    _currentFontSize = event.size;

    emit(const PrinterDisconnected());
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _savePrinterMac(String mac) async {
    await _secureStorage.storePrinterMac(mac);
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPaperSize = prefs.getInt('saved_paper_size') ?? PaperSize.mm80.index;

    _currentPaperSize = PaperSize.values[savedPaperSize];

    // Don't auto-reconnect for now - feature deferred to v1.1.0
  }

  Future<void> _savePaperSize(PaperSize size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('saved_paper_size', size.index);
  }
}
