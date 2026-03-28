/// Application-wide constants.
/// These values are used throughout the app and should not change at runtime.
final class AppConstants {
  const AppConstants._();

  // ═══════════════════════════════════════════════════════════════════════════
  // APP INFO
  // ═══════════════════════════════════════════════════════════════════════════
  static const String appName = 'KhmerBiz POS';
  static const String appVersion = '1.0.0';
  static const int appVersionCode = 1;

  // ═══════════════════════════════════════════════════════════════════════════
  // CURRENCY SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Cambodian Riel currency code
  static const String currencyCodeKHR = 'KHR';

  /// US Dollar currency code
  static const String currencyCodeUSD = 'USD';

  /// Khmer Riel symbol
  static const String currencySymbolKHR = '៛';

  /// US Dollar symbol
  static const String currencySymbolUSD = r'$';

  /// Default exchange rate (1 USD = X KHR) - will be updated from API
  static const double defaultExchangeRate = 4100;

  /// Minimum exchange rate threshold for validation
  static const double minExchangeRate = 3500;

  /// Maximum exchange rate threshold for validation
  static const double maxExchangeRate = 4500;

  // ═══════════════════════════════════════════════════════════════════════════
  // TAX SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Default tax rate in Cambodia (10%)
  static const double defaultTaxRate = 0.10;

  /// Tax rate display percentage
  static const double taxRatePercentage = 10;

  // ═══════════════════════════════════════════════════════════════════════════
  // KHQR SETTINGS (National KHQR Payment System)
  // ═══════════════════════════════════════════════════════════════════════════
  /// KHQR Merchant Category Code (MCC) for retail
  static const String khqrMerchantCategoryCode = '5411';

  /// KHQR country code
  static const String khqrCountryCode = 'KH';

  /// KHQR currency code for transactions
  static const String khqrCurrencyCode = 'KHR';

  /// KHQR API timeout in milliseconds
  static const int khqrApiTimeoutMs = 30000;

  // ═══════════════════════════════════════════════════════════════════════════
  // INVENTORY SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Low stock threshold - alert when quantity falls below this
  static const int lowStockThreshold = 10;

  /// Critical stock threshold - urgent reorder needed
  static const int criticalStockThreshold = 5;

  /// Maximum quantity allowed for a single product
  static const int maxProductQuantity = 999999;

  // ═══════════════════════════════════════════════════════════════════════════
  // SYNC SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Background sync interval in minutes
  static const int syncIntervalMinutes = 15;

  /// Maximum retry attempts for failed sync
  static const int maxSyncRetryAttempts = 3;

  /// Sync timeout in seconds
  static const int syncTimeoutSeconds = 60;

  /// Maximum batch size for sync operations
  static const int maxSyncBatchSize = 100;

  // ═══════════════════════════════════════════════════════════════════════════
  // NETWORK SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// API connection timeout in milliseconds
  static const int apiConnectionTimeoutMs = 15000;

  /// API receive timeout in milliseconds
  static const int apiReceiveTimeoutMs = 30000;

  /// Maximum retry attempts for failed API calls
  static const int maxApiRetryAttempts = 3;

  /// Delay between retries in milliseconds
  static const int apiRetryDelayMs = 1000;

  // ═══════════════════════════════════════════════════════════════════════════
  // SECURITY SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Session timeout in hours
  static const int sessionTimeoutHours = 24;

  /// Auto-logout after inactivity in minutes
  static const int autoLogoutMinutes = 30;

  /// Maximum failed login attempts before lockout
  static const int maxLoginAttempts = 5;

  /// Lockout duration in minutes
  static const int lockoutDurationMinutes = 15;

  // ═══════════════════════════════════════════════════════════════════════════
  // PRINTER SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Default printer paper width in mm
  static const int defaultPrinterWidthMm = 58;

  /// Bluetooth scan timeout in seconds
  static const int bluetoothScanTimeoutSeconds = 30;

  // ═══════════════════════════════════════════════════════════════════════════
  // PAGINATION SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Default page size for lists
  static const int defaultPageSize = 20;

  /// Maximum page size
  static const int maxPageSize = 100;

  /// Prefetch threshold - load more when this many items remain
  static const int prefetchThreshold = 5;

  // ═══════════════════════════════════════════════════════════════════════════
  // CACHE SETTINGS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Cache duration for product data in hours
  static const int productCacheDurationHours = 24;

  /// Cache duration for user data in hours
  static const int userCacheDurationHours = 12;

  /// Maximum cache size in MB
  static const int maxCacheSizeMb = 50;

  // ═══════════════════════════════════════════════════════════════════════════
  // DATE/TIME FORMATS
  // ═══════════════════════════════════════════════════════════════════════════
  /// Display format: 28 Mar 2026
  static const String dateFormatDisplay = 'dd MMM yyyy';

  /// Display format with time: 28 Mar 2026 14:30
  static const String dateTimeFormatDisplay = 'dd MMM yyyy HH:mm';

  /// Internal storage format: 2026-03-28T14:30:00
  static const String dateTimeFormatISO = "yyyy-MM-dd'T'HH:mm:ss";

  /// Khmer date format
  static const String dateFormatKhmer = 'dd MMMM yyyy';

  // ═══════════════════════════════════════════════════════════════════════════
  // PERMISSIONS
  // ═══════════════════════════════════════════════════════════════════════════
  static const String permissionBluetooth = 'bluetooth';
  static const String permissionLocation = 'location';
  static const String permissionCamera = 'camera';
  static const String permissionStorage = 'storage';

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTES
  // ═══════════════════════════════════════════════════════════════════════════
  static const String routeSplash = '/';
  static const String routeLogin = '/login';
  static const String routeHome = '/home';
  static const String routePOS = '/pos';
  static const String routeProducts = '/products';
  static const String routeInventory = '/inventory';
  static const String routeTransactions = '/transactions';
  static const String routeReports = '/reports';
  static const String routeSettings = '/settings';
  static const String routeCustomers = '/customers';

  // ═══════════════════════════════════════════════════════════════════════════
  // STORAGE KEYS
  // ═══════════════════════════════════════════════════════════════════════════
  static const String keyAuthToken = 'auth_token';
  static const String keyTokenExpiry = 'token_expiry';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyLanguage = 'language';
  static const String keyTheme = 'theme';
  static const String keyLastSync = 'last_sync';
  static const String keyExchangeRate = 'exchange_rate';
  static const String keyExchangeRateTimestamp = 'exchange_rate_timestamp';

  // ═══════════════════════════════════════════════════════════════════════════
  // MISC
  // ═══════════════════════════════════════════════════════════════════════════
  /// Default locale for English
  static const String localeEnglish = 'en_US';

  /// Default locale for Khmer
  static const String localeKhmer = 'km_KH';

  /// Supported locales
  static const List<String> supportedLocales = [localeEnglish, localeKhmer];

  /// Animation duration in milliseconds
  static const int animationDurationMs = 300;

  /// Debounce duration for search in milliseconds
  static const int searchDebounceMs = 500;
}
