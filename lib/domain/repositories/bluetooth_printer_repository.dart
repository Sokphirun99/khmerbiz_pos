import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/printer.dart';

/// Repository interface for Bluetooth printer operations.
abstract class BluetoothPrinterRepository {
  /// Check if Bluetooth is enabled on the device.
  Future<Either<Failure, bool>> isBluetoothEnabled();

  /// Request Bluetooth permissions (Android 12+).
  Future<Either<Failure, bool>> requestPermissions();

  /// Scan for available Bluetooth printers.
  ///
  /// Returns a stream of discovered devices.
  Stream<Either<Failure, List<BluetoothPrinterDevice>>> scanForPrinters();

  /// Connect to a specific printer device.
  ///
  /// [device] - The printer device to connect to.
  Future<Either<Failure, void>> connect(BluetoothPrinterDevice device);

  /// Disconnect from the currently connected printer.
  Future<Either<Failure, void>> disconnect();

  /// Check if a printer is currently connected.
  Future<Either<Failure, bool>> isConnected();

  /// Get the currently connected device, if any.
  Future<Either<Failure, BluetoothPrinterDevice?>> getConnectedDevice();

  /// Send raw bytes to the printer.
  ///
  /// [bytes] - The ESC/POS command bytes to send.
  Future<Either<Failure, void>> print(List<int> bytes);

  /// Print a test page to verify the printer is working.
  Future<Either<Failure, void>> printTestPage();
}
