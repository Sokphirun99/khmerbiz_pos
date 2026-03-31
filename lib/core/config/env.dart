/// Environment types for the application.
/// Used to configure different behaviors for dev, staging, and production.
enum Environment {
  /// Development environment - local testing
  dev,

  /// Staging environment - pre-production testing
  staging,

  /// Production environment - live release
  prod,
}

/// Extension methods for [Environment] to provide helper getters.
extension EnvironmentExtension on Environment {
  /// Whether this is a development environment
  bool get isDevelopment => this == Environment.dev;

  /// Whether this is a staging environment
  bool get isStaging => this == Environment.staging;

  /// Whether this is a production environment
  bool get isProduction => this == Environment.prod;

  /// Whether logging should be enabled
  bool get enableLogging => this != Environment.prod;

  /// Whether debug features should be enabled
  bool get enableDebugFeatures => this != Environment.prod;
}
