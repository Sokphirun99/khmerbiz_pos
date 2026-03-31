import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/domain/entities/transaction_with_items.dart';
import 'package:khmerbiz_pos/domain/repositories/bluetooth_printer_repository.dart';
import 'package:khmerbiz_pos/domain/repositories/transaction_repository.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_event.dart';
import 'package:khmerbiz_pos/features/printer/presentation/bloc/printer_state.dart';
import 'package:khmerbiz_pos/data/repositories/receipt_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BLoC managing Bluetooth printer operations.
class PrinterBloc extends Bloc<PrinterEvent, PrinterState> {
  /// Creates a [PrinterBloc] with required dependencies.
  PrinterBloc({
    required BluetoothPrinterRepository bluetoothPrinterRepository,
    required TransactionRepository transactionRepository,
  })  : _bluetoothPrinterRepository = bluetoothPrinterRepository,
        _transactionRepository = transactionRepository,
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

  static const _savedPrinterKey = 'saved_printer_mac';
  static const _savedPaperSizeKey = 'saved_paper_size';

  BluetoothPrinterDevice? _lastConnectedDevice;
  PaperSize _currentPaperSize = PaperSize.mm80;
  PrinterFontSize _currentFontSize = PrinterFontSize.normal;
  String? _lastTransactionId;
  int _retryCount = 0;

  // ── Silent Reconnect ─────────────────────────────────────────────────────

  Future<void> _onSilentReconnect(
    SilentReconnect event,
    Emitter<PrinterState> emit,
  ) async {
    // Silent reconnect - no UI changes, just attempt to reconnect
    final prefs = await SharedPreferences.getInstance();
    final savedMac = prefs.getString(_savedPrinterKey);

    if (savedMac == null) {
      return; // No saved printer
    }

    // Try to reconnect silently
    final result = await _bluetoothPrinterRepository.isConnected();
    result.fold(
      (_) => null,
      (isConnected) async {
        if (!isConnected) {
          // Try to reconnect
          final devices = await _bluetoothPrinterRepository
              .scanForPrinters()
              .firstWhere((r) => r.isRight(), orElse: () => const Right([]));

          devices.fold(
            (_) => null,
            (devices) async {
              final device = devices.firstWhere(
                (d) => d.address == savedMac,
                orElse: () =>
                    const BluetoothPrinterDevice(
                      id: '',
                      name: '',
                      address: '',
                    ),
              );

              if (device.id.isNotEmpty) {
                await _bluetoothPrinterRepository.connect(device);
              }
            },
          );
        }
      },
    );
  }

  // ── Scan ─────────────────────────────────────────────────────────────────

  Future<void> _onScanForPrinters(
    ScanForPrinters event,
    Emitter<PrinterState> emit,
  ) async {
    // Check permissions
    final permResult = await _bluetoothPrinterRepository.requestPermissions();
    final permissionGranted = permResult.fold((_) => false, (v) => v);

    if (!permissionGranted) {
      emit(PrinterError(failure: SystemFailure.permissionDenied('Bluetooth')));
      return;
    }

    // Check Bluetooth enabled
    final btResult = await _bluetoothPrinterRepository.isBluetoothEnabled();
    final btEnabled = btResult.fold((_) => false, (v) => v);

    if (!btEnabled) {
      emit(PrinterError(failure: SystemFailure.bluetooth('Bluetooth is disabled')));
      return;
    }

    // Start scanning - use the implementation-specific method
    if (_bluetoothPrinterRepository is BluetoothPrinterRepositoryImpl) {
      (_bluetoothPrinterRepository as BluetoothPrinterRepositoryImpl).startScan();
    }

    emit(const PrinterScanning(foundDevices: []));

    // Listen to scan results
    if (_bluetoothPrinterRepository is BluetoothPrinterRepositoryImpl) {
      await for (final result in (_bluetoothPrinterRepository as BluetoothPrinterRepositoryImpl).scanForPrinters()) {
        result.fold(
          (failure) {
            emit(PrinterError(failure: failure));
          },
          (devices) {
            if (devices.isNotEmpty) {
              emit(PrinterScanning(foundDevices: devices));
            }
          },
        );
      }
    }
  }

  // ── Connect ──────────────────────────────────────────────────────────────

  Future<void> _onConnectPrinter(
    ConnectPrinter event,
    Emitter<PrinterState> emit,
  ) async {
    emit(PrinterConnecting(device: event.device));

    final result = await _bluetoothPrinterRepository.connect(event.device);

    result.fold(
      (failure) {
        emit(PrinterError(
          failure: failure is PrinterFailure
              ? failure
              : PrinterFailure.notFound(),
        ));
      },
      (_) {
        _lastConnectedDevice = event.device;
        _savePrinterMac(event.device.address);
        emit(PrinterConnected(
          device: event.device,
          paperSize: _currentPaperSize,
          fontSize: _currentFontSize,
        ));
      },
    );
  }

  // ── Disconnect ───────────────────────────────────────────────────────────

  Future<void> _onDisconnectPrinter(
    DisconnectPrinter event,
    Emitter<PrinterState> emit,
  ) async {
    await _bluetoothPrinterRepository.disconnect();
    _lastConnectedDevice = null;
    emit(const PrinterDisconnected());
  }

  // ── Print Receipt ────────────────────────────────────────────────────────

  Future<void> _onPrintReceipt(
    PrintReceipt event,
    Emitter<PrinterState> emit,
  ) async {
    _lastTransactionId = event.transactionId;
    _retryCount = 0;

    // Check if printer is connected
    final connectedResult = await _bluetoothPrinterRepository.isConnected();
    final isConnected = connectedResult.fold((_) => false, (v) => v);

    if (!isConnected) {
      emit(const PrinterError(
        failure: const PrinterNotConnected(),
        lastTransactionId: null,
      ));
      return;
    }

    emit(PrinterPrinting(transactionId: event.transactionId));

    // Fetch transaction with items
    final transactionResult =
        await _transactionRepository.getTransactionWithItems(event.transactionId);

    final transaction = transactionResult.fold(
      (failure) => null,
      (t) => t,
    );

    if (transaction == null) {
      emit(PrinterError(
        failure: PrintFailed(
          transactionId: event.transactionId,
          reason: 'Transaction not found',
        ),
        lastTransactionId: event.transactionId,
      ));
      return;
    }

    // Build receipt
    final config = PrinterConfig(
      paperSize: _currentPaperSize,
      fontSize: _currentFontSize,
    );
    final builder = ReceiptBuilder(config: config);
    final receiptBytes = await builder.buildReceipt(transaction);

    // Print
    final printResult = await _bluetoothPrinterRepository.print(receiptBytes);

    printResult.fold(
      (failure) async {
        // Retry once after 1 second
        await Future.delayed(const Duration(seconds: 1));
        final retryResult = await _bluetoothPrinterRepository.print(receiptBytes);

        retryResult.fold(
          (retryFailure) {
            emit(PrinterError(
              failure: retryFailure is PrinterFailure
                  ? retryFailure
                  : PrintFailed(
                      transactionId: event.transactionId,
                      reason: 'Print failed',
                    ),
              lastTransactionId: event.transactionId,
            ));
          },
          (_) {
            emit(PrinterSuccess(transactionId: event.transactionId));
          },
        );
      },
      (_) {
        emit(PrinterSuccess(transactionId: event.transactionId));
      },
    );
  }

  // ── Print Test Page ──────────────────────────────────────────────────────

  Future<void> _onPrintTestPage(
    PrintTestPage event,
    Emitter<PrinterState> emit,
  ) async {
    final result = await _bluetoothPrinterRepository.printTestPage();

    result.fold(
      (failure) {
        emit(PrinterError(
          failure: failure is PrinterFailure
              ? failure
              : const PrintFailed(transactionId: 'TEST', reason: 'Test failed'),
        ));
      },
      (_) {
        emit(const PrinterSuccess(transactionId: 'TEST'));
      },
    );
  }

  // ── Retry Last Print ─────────────────────────────────────────────────────

  Future<void> _onRetryLastPrint(
    RetryLastPrint event,
    Emitter<PrinterState> emit,
  ) async {
    if (_lastTransactionId != null) {
      add(PrintReceipt(transactionId: _lastTransactionId!));
    }
  }

  // ── Set Paper Size ───────────────────────────────────────────────────────

  Future<void> _onSetPaperSize(
    SetPaperSize event,
    Emitter<PrinterState> emit,
  ) async {
    _currentPaperSize = event.size;
    _savePaperSize(event.size);

    final deviceResult = await _bluetoothPrinterRepository.getConnectedDevice();
    deviceResult.fold(
      (_) => null,
      (device) {
        if (device != null) {
          emit(PrinterConnected(
            device: device,
            paperSize: _currentPaperSize,
            fontSize: _currentFontSize,
          ));
        }
      },
    );
  }

  // ── Set Font Size ────────────────────────────────────────────────────────

  Future<void> _onSetFontSize(
    SetFontSize event,
    Emitter<PrinterState> emit,
  ) async {
    _currentFontSize = event.size;

    final deviceResult = await _bluetoothPrinterRepository.getConnectedDevice();
    deviceResult.fold(
      (_) => null,
      (device) {
        if (device != null) {
          emit(PrinterConnected(
            device: device,
            paperSize: _currentPaperSize,
            fontSize: _currentFontSize,
          ));
        }
      },
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _savePrinterMac(String mac) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_savedPrinterKey, mac);
  }

  Future<void> _loadSavedPrinter() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMac = prefs.getString(_savedPrinterKey);
    final savedPaperSize = prefs.getInt(_savedPaperSizeKey) ?? PaperSize.mm80.index;

    _currentPaperSize = PaperSize.values[savedPaperSize];

    if (savedMac != null) {
      // Attempt silent reconnect on next app resume
      add(const SilentReconnect());
    }
  }

  Future<void> _savePaperSize(PaperSize size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_savedPaperSizeKey, size.index);
  }
}
