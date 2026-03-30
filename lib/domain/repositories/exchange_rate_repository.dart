import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/exchange_rate.dart';

abstract class ExchangeRateRepository {
  /// Get the latest exchange rate from local DB.
  Future<Either<Failure, ExchangeRate>> getLatestRate();

  /// Persist an exchange rate to local DB.
  Future<Either<Failure, void>> updateRate(ExchangeRate rate);

  /// Return the in-memory cached rate (synchronous, fast).
  double getCachedRate();

  /// Fetch the latest rate from NBC API or fallback source.
  /// Updates both the local DB and in-memory cache on success.
  Future<Either<Failure, double>> fetchLatestRate();

  /// Whether the cached rate is older than 24 hours.
  bool isRateStale();
}
