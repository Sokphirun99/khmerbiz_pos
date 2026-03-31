import 'package:equatable/equatable.dart';

/// Paper size for thermal printers.
enum PaperSize {
  /// 58mm paper (approximately 32 characters per line)
  mm58,

  /// 80mm paper (approximately 48 characters per line)
  mm80;

  /// Get the number of characters per line for this paper size.
  int get charsPerLine => switch (this) {
        PaperSize.mm58 => 32,
        PaperSize.mm80 => 48,
      };

  /// Get the paper width in millimeters.
  int get widthMm => switch (this) {
        PaperSize.mm58 => 58,
        PaperSize.mm80 => 80,
      };
}

/// Font size for receipt printing.
enum PrinterFontSize {
  /// Normal font size
  normal,

  /// Large font size for accessibility
  large;

  /// Get the font multiplier for ESC/POS commands.
  int get multiplier => switch (this) {
        PrinterFontSize.normal => 1,
        PrinterFontSize.large => 2,
      };
}

/// Bluetooth printer device information.
final class BluetoothPrinterDevice extends Equatable {
  /// Creates a [BluetoothPrinterDevice].
  const BluetoothPrinterDevice({
    required this.id,
    required this.name,
    required this.address,
    this.isConnected = false,
    this.signalStrength,
  });

  /// Unique device identifier.
  final String id;

  /// Human-readable device name.
  final String name;

  /// Bluetooth MAC address.
  final String address;

  /// Whether the device is currently connected.
  final bool isConnected;

  /// Signal strength indicator (RSSI), if available.
  final int? signalStrength;

  /// Check if signal strength is good.
  bool get hasGoodSignal => signalStrength != null && signalStrength! > -70;

  /// Check if signal strength is weak.
  bool get hasWeakSignal => signalStrength != null && signalStrength! < -80;

  @override
  List<Object?> get props => [id, name, address, isConnected, signalStrength];

  /// Creates a copy of this device with the given fields replaced.
  BluetoothPrinterDevice copyWith({
    String? id,
    String? name,
    String? address,
    bool? isConnected,
    int? signalStrength,
  }) {
    return BluetoothPrinterDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      isConnected: isConnected ?? this.isConnected,
      signalStrength: signalStrength ?? this.signalStrength,
    );
  }
}
