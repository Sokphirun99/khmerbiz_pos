import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:khmerbiz_pos/core/utils/app_logger.dart';

/// Secure storage wrapper for sensitive data.
///
/// Uses flutter_secure_storage with encryption:
/// - Android: EncryptedSharedPreferences
/// - iOS: Keychain
///
/// All PINs are hashed with SHA-256 + salt before storage.
@LazySingleton()
class SecureStorageHelper {
  /// Creates a [SecureStorageHelper].
  SecureStorageHelper()
      : _storage = const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  // Storage keys
  static const _pinHashKey = 'pin_hash';
  static const _jwtTokenKey = 'jwt_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _deviceEncryptionKey = 'device_encryption_key';
  static const _printerMacKey = 'printer_mac';
  static const _saltKey = 'pin_salt';

  /// Hash a PIN using SHA-256 with salt.
  ///
  /// [pin] must be 4-6 digits.
  /// Returns the hash string.
  Future<String> hashPin(String pin) async {
    if (pin.length < 4 || pin.length > 6) {
      throw ArgumentError('PIN must be 4-6 digits');
    }

    // Validate PIN is numeric
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw ArgumentError('PIN must contain only digits');
    }

    try {
      // Get or create salt
      var salt = await _storage.read(key: _saltKey);
      if (salt == null) {
        // Generate cryptographically secure random salt (32 bytes)
        final random = Random.secure();
        final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
        salt = base64Encode(saltBytes);
        await _storage.write(key: _saltKey, value: salt);
      }

      // Hash PIN with salt
      final bytes = utf8.encode('$salt$pin');
      final hash = sha256.convert(bytes);
      return hash.toString();
    } catch (e) {
      AppLogger.e('Error hashing PIN: $e', tag: 'SecureStorage');
      rethrow;
    }
  }

  /// Verify a PIN against a stored hash.
  ///
  /// Returns true if the PIN matches the hash.
  Future<bool> verifyPin(String pin, String hash) async {
    try {
      final expectedHash = await hashPin(pin);
      return hash == expectedHash;
    } catch (e) {
      AppLogger.e('Error verifying PIN: $e', tag: 'SecureStorage');
      return false;
    }
  }

  /// Store a hashed PIN.
  Future<void> storePinHash(String pin) async {
    final hash = await hashPin(pin);
    await _storage.write(key: _pinHashKey, value: hash);
  }

  /// Retrieve the stored PIN hash.
  Future<String?> getPinHash() async {
    return _storage.read(key: _pinHashKey);
  }

  /// Verify a PIN against the stored hash.
  Future<bool> verifyStoredPin(String pin) async {
    final hash = await getPinHash();
    if (hash == null) {
      return false;
    }
    return verifyPin(pin, hash);
  }

  /// Store JWT token.
  Future<void> storeJwtToken(String token) async {
    await _storage.write(key: _jwtTokenKey, value: token);
  }

  /// Retrieve JWT token.
  Future<String?> getJwtToken() async {
    return _storage.read(key: _jwtTokenKey);
  }

  /// Store refresh token.
  Future<void> storeRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Retrieve refresh token.
  Future<String?> getRefreshToken() async {
    return _storage.read(key: _refreshTokenKey);
  }

  /// Store both tokens.
  Future<void> storeTokens({required String jwt, required String refresh}) async {
    await Future.wait([
      _storage.write(key: _jwtTokenKey, value: jwt),
      _storage.write(key: _refreshTokenKey, value: refresh),
    ]);
  }

  /// Clear all tokens.
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _jwtTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }

  /// Store device encryption key.
  Future<void> storeDeviceEncryptionKey(String key) async {
    await _storage.write(key: _deviceEncryptionKey, value: key);
  }

  /// Retrieve device encryption key.
  Future<String?> getDeviceEncryptionKey() async {
    return _storage.read(key: _deviceEncryptionKey);
  }

  /// Store printer MAC address (migrated from SharedPreferences).
  Future<void> storePrinterMac(String mac) async {
    await _storage.write(key: _printerMacKey, value: mac);
  }

  /// Retrieve printer MAC address.
  Future<String?> getPrinterMac() async {
    return _storage.read(key: _printerMacKey);
  }

  /// Clear all secure storage.
  ///
  /// Use with caution - this will log out the user and remove all sensitive data.
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if PIN is set.
  Future<bool> hasPin() async {
    final hash = await getPinHash();
    return hash != null && hash.isNotEmpty;
  }

  /// Check if user is authenticated (has valid tokens).
  Future<bool> isAuthenticated() async {
    final token = await getJwtToken();
    return token != null && token.isNotEmpty;
  }
}
