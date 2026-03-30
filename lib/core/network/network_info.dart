import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for checking network connectivity.
abstract class NetworkInfo {
  /// Check if the device has any internet connection.
  Future<bool> get isConnected;

  /// Check if the device is connected via WiFi.
  Future<bool> get isWifiConnected;

  /// Check if the device is connected via mobile data.
  Future<bool> get isMobileDataConnected;

  /// Get the current connection type.
  Future<ConnectionType> get connectionType;

  /// Stream of connectivity changes.
  Stream<ConnectionType> get onConnectivityChanged;
}

/// Connection type enum.
enum ConnectionType {
  none,
  wifi,
  mobile,
  ethernet,
  bluetooth,
  vpn,
  unknown,
}

/// Implementation of [NetworkInfo] using `connectivity_plus`.
final class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  @override
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.any((r) => r != ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> get isWifiConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.wifi);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> get isMobileDataConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      return results.contains(ConnectivityResult.mobile);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<ConnectionType> get connectionType async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _mapResults(results);
    } catch (e) {
      return ConnectionType.unknown;
    }
  }

  ConnectionType _mapResults(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) return ConnectionType.wifi;
    if (results.contains(ConnectivityResult.mobile))
      return ConnectionType.mobile;
    if (results.contains(ConnectivityResult.ethernet))
      return ConnectionType.ethernet;
    if (results.contains(ConnectivityResult.bluetooth))
      return ConnectionType.bluetooth;
    if (results.contains(ConnectivityResult.vpn)) return ConnectionType.vpn;
    if (results.contains(ConnectivityResult.none)) return ConnectionType.none;
    return ConnectionType.unknown;
  }

  @override
  Stream<ConnectionType> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged
        .map<ConnectionType>((List<ConnectivityResult> results) {
      return _mapResults(results);
    });
  }
}

/// Network monitor that can be used to track connectivity state.
final class NetworkMonitor {
  NetworkMonitor(this._networkInfo);
  final NetworkInfo _networkInfo;

  ConnectionType _currentConnectionType = ConnectionType.unknown;
  bool _isInitialized = false;

  ConnectionType get currentConnectionType => _currentConnectionType;

  bool get isConnected =>
      _currentConnectionType != ConnectionType.none &&
      _currentConnectionType != ConnectionType.unknown;

  bool get isWifiConnected => _currentConnectionType == ConnectionType.wifi;

  bool get isMobileDataConnected =>
      _currentConnectionType == ConnectionType.mobile;

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    _currentConnectionType = await _networkInfo.connectionType;
    _isInitialized = true;

    _networkInfo.onConnectivityChanged.listen((newType) {
      _currentConnectionType = newType;
    });
  }

  Future<void> requireConnection() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (!isConnected) {
      throw Exception('No internet connection');
    }
  }

  String getStatusMessage() {
    return switch (_currentConnectionType) {
      ConnectionType.none => 'No internet connection',
      ConnectionType.wifi => 'Connected via WiFi',
      ConnectionType.mobile => 'Connected via mobile data',
      ConnectionType.ethernet => 'Connected via Ethernet',
      ConnectionType.bluetooth => 'Connected via Bluetooth',
      ConnectionType.vpn => 'Connected via VPN',
      ConnectionType.unknown => 'Connection status unknown',
    };
  }

  String getStatusMessageKhmer() {
    return switch (_currentConnectionType) {
      ConnectionType.none => 'គ្មានការតភ្ជាប់អ៊ីនធឺណិត',
      ConnectionType.wifi => 'តភ្ជាប់តាម WiFi',
      ConnectionType.mobile => 'តភ្ជាប់តាមទិន្នន័យចល័ត',
      ConnectionType.ethernet => 'តភ្ជាប់តាម Ethernet',
      ConnectionType.bluetooth => 'តភ្ជាប់តាម Bluetooth',
      ConnectionType.vpn => 'តភ្ជាប់តាម VPN',
      ConnectionType.unknown => 'ស្ថានភាពតភ្ជាប់មិនច្បាស់លាស់',
    };
  }
}
