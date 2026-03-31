import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';
import 'package:khmerbiz_pos/domain/repositories/bluetooth_printer_repository.dart';

/// Implementation of [BluetoothPrinterRepository] using flutter_blue_plus.
class BluetoothPrinterRepositoryImpl implements BluetoothPrinterRepository {
  /// Creates a [BluetoothPrinterRepositoryImpl].
  BluetoothPrinterRepositoryImpl();

  BluetoothDevice? _connectedDevice;
  final Set<String> _discoveredDeviceIds = {};
  final StreamController<List<BluetoothPrinterDevice>> _scanController =
      StreamController<List<BluetoothPrinterDevice>>.broadcast();

  @override
  Future<Either<Failure, bool>> isBluetoothEnabled() async {
    try {
      // Check adapter state directly
      final state = await FlutterBluePlus.adapterState.first;
      return right(state == BluetoothAdapterState.on);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to check Bluetooth status: $e',
        messageKm: 'បរាជ័យក្នុងការពិនិត្យស្ថានភាព Bluetooth៖ $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> requestPermissions() async {
    try {
      // Request permissions - this is async in newer versions
      await FlutterBluePlus.requestPermissions;
      return const Right(true);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to request Bluetooth permissions: $e',
        messageKm: 'បរាជ័យក្នុងការស្នើសុំការអនុញ្ញាត Bluetooth៖ $e',
      ));
    }
  }

  @override
  Stream<Either<Failure, List<BluetoothPrinterDevice>>> scanForPrinters() {
    return _scanController.stream;
  }

  /// Start scanning for printers - called from BLoC
  void startScan() async {
    try {
      _discoveredDeviceIds.clear();
      _scanController.add(const Right([]));

      // Check Bluetooth is enabled
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        _scanController.add(
          left(SystemFailure.bluetooth('Bluetooth is disabled')),
        );
        return;
      }

      // Start scanning
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 10),
        removeIfGone: const Duration(seconds: 5),
      );

      // Listen for scan results
      FlutterBluePlus.scanResults.listen((scanResults) {
        final devices = <BluetoothPrinterDevice>[];
        for (final result in scanResults) {
          final device = result.device;
          final id = device.remoteId.str;

          if (!_discoveredDeviceIds.contains(id)) {
            _discoveredDeviceIds.add(id);
            devices.add(BluetoothPrinterDevice(
              id: id,
              name: device.platformName.isNotEmpty
                  ? device.platformName
                  : 'Unknown Printer',
              address: id,
              signalStrength: result.rssi,
            ));
          }
        }
        if (devices.isNotEmpty) {
          _scanController.add(right(devices));
        }
      });

      // Stop scan after timeout
      await Future.delayed(const Duration(seconds: 12));
      await FlutterBluePlus.stopScan();
      _scanController.add(right([]));
    } catch (e) {
      await FlutterBluePlus.stopScan();
      _scanController.add(left(SystemFailure(
        messageEn: 'Failed to scan for printers: $e',
        messageKm: 'បរាជ័យក្នុងការស្កេនរកម៉ាស៊ីនបោះពុម្ព៖ $e',
      )));
    }
  }

  @override
  Future<Either<Failure, void>> connect(BluetoothPrinterDevice device) async {
    try {
      // Get all system devices
      final systemDevices = await FlutterBluePlus.systemDevices;
      
      // Find the device
      BluetoothDevice? btDevice;
      for (final d in systemDevices) {
        if (d.remoteId.str == device.address) {
          btDevice = d;
          break;
        }
      }

      if (btDevice == null) {
        // Device not found in system - try to connect directly by ID
        btDevice = BluetoothDevice.fromId(device.address);
      }

      // Connect to the device
      await btDevice.connect();

      // Wait for connection (poll state)
      for (var i = 0; i < 20; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        final state = btDevice!.connectionState.value;
        if (state == BluetoothConnectionState.connected) {
          _connectedDevice = btDevice;
          return const Right(null);
        }
        if (state == BluetoothConnectionState.disconnected) {
          break;
        }
      }

      return left(PrinterFailure.notFound());
    } catch (e) {
      return left(PrinterFailure.notFound());
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      if (_connectedDevice != null) {
        await _connectedDevice!.disconnect();
        _connectedDevice = null;
      }
      return const Right(null);
    } catch (e) {
      return left(SystemFailure(
        messageEn: 'Failed to disconnect: $e',
        messageKm: 'បរាជ័យក្នុងការផ្តាច់៖ $e',
      ));
    }
  }

  @override
  Future<Either<Failure, bool>> isConnected() async {
    try {
      if (_connectedDevice == null) {
        return const Right(false);
      }
      final state = _connectedDevice!.connectionState.value;
      return right(state == BluetoothConnectionState.connected);
    } catch (e) {
      return const Right(false);
    }
  }

  @override
  Future<Either<Failure, BluetoothPrinterDevice?>> getConnectedDevice() async {
    try {
      if (_connectedDevice == null) {
        return const Right(null);
      }

      final device = _connectedDevice!;
      return right(BluetoothPrinterDevice(
        id: device.remoteId.str,
        name: device.platformName,
        address: device.remoteId.str,
        isConnected: true,
      ));
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> print(List<int> bytes) async {
    try {
      if (_connectedDevice == null) {
        return left(PrinterFailure.notConnected());
      }

      final device = _connectedDevice!;

      // Discover services
      final services = await device.discoverServices();

      // Find a writable characteristic
      BluetoothCharacteristic? characteristic;
      
      for (final service in services) {
        for (final char in service.characteristics) {
          if (char.properties.write) {
            characteristic = char;
            break;
          }
        }
        if (characteristic != null) break;
      }

      if (characteristic == null) {
        return left(PrinterFailure.printFailed());
      }

      // Send data in chunks
      const chunkSize = 200;
      for (var i = 0; i < bytes.length; i += chunkSize) {
        final end = (i + chunkSize < bytes.length) ? i + chunkSize : bytes.length;
        final chunk = bytes.sublist(i, end);

        await characteristic.write(Uint8List.fromList(chunk));
        await Future.delayed(const Duration(milliseconds: 15));
      }

      return const Right(null);
    } catch (e) {
      return left(PrinterFailure.printFailed());
    }
  }

  @override
  Future<Either<Failure, void>> printTestPage() async {
    try {
      if (_connectedDevice == null) {
        return left(PrinterFailure.notConnected());
      }

      // Build test page bytes
      final bytes = <int>[
        ...EscPosCommands.init,
        ...EscPosCommands.alignCenter,
        ...EscPosCommands.boldOn,
        ...EscPosCommands.doubleSize,
        ...'TEST PRINT'.codeUnits,
        ...EscPosCommands.printAndCarriageReturn,
        ...EscPosCommands.normalSize,
        ...EscPosCommands.boldOff,
        ...EscPosCommands.alignLeft,
        ...'Date: ${DateTime.now().toString().substring(0, 16)}'.codeUnits,
        ...EscPosCommands.printAndCarriageReturn,
        ...EscPosCommands.printAndCarriageReturn,
        ...EscPosCommands.printAndCarriageReturn,
        ...EscPosCommands.printAndCarriageReturn,
        ...EscPosCommands.cutPaperPartial,
      ];

      return await print(bytes);
    } catch (e) {
      return left(PrinterFailure.printFailed());
    }
  }

  /// Dispose resources
  void dispose() {
    _scanController.close();
  }
}

/// ESC/POS command constants.
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
  static const List<int> cutPaperPartial = [0x1D, 0x56, 0x01];
}
