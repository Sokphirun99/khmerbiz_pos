import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/config/constants.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';
import 'package:khmerbiz_pos/domain/entities/exchange_rate.dart';
import 'package:khmerbiz_pos/domain/repositories/exchange_rate_repository.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  ExchangeRateRepositoryImpl(this._db);
  final AppDatabase _db;

  double _cachedRate = AppConstants.defaultExchangeRate;
  DateTime? _lastFetchedAt;

  /// Staleness threshold: 24 hours.
  static const _staleThreshold = Duration(hours: 24);

  @override
  Future<Either<Failure, ExchangeRate>> getLatestRate() async {
    try {
      final rateModel = await (_db.select(_db.exchangeRates)
            ..where((tbl) => tbl.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
            ..limit(1))
          .getSingleOrNull();

      if (rateModel == null) {
        return left(
            CacheFailure.defaultError(details: 'No exchange rate found'));
      }

      // Update in-memory cache
      _cachedRate = rateModel.rate;
      _lastFetchedAt = rateModel.fetchedAt;

      return right(ExchangeRate(
        id: rateModel.id,
        baseCurrency: rateModel.baseCurrency,
        targetCurrency: rateModel.targetCurrency,
        rate: rateModel.rate,
        source: rateModel.source,
        fetchedAt: rateModel.fetchedAt,
        isActive: rateModel.isActive,
      ));
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRate(ExchangeRate rate) async {
    try {
      // Upsert into database
      await _db.into(_db.exchangeRates).insertOnConflictUpdate(
            ExchangeRatesCompanion(
              id: Value(rate.id),
              baseCurrency: Value(rate.baseCurrency),
              targetCurrency: Value(rate.targetCurrency),
              rate: Value(rate.rate),
              source: Value(rate.source),
              fetchedAt: Value(rate.fetchedAt),
              isActive: Value(rate.isActive),
            ),
          );

      // Update in-memory cache
      _cachedRate = rate.rate;
      _lastFetchedAt = rate.fetchedAt;

      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  double getCachedRate() => _cachedRate;

  @override
  Future<Either<Failure, double>> fetchLatestRate() async {
    try {
      // TODO: Replace with real NBC API call when available.
      // NBC API endpoint: GET https://api.nbc.org.kh/exchange-rates
      //
      // For now, use the hardcoded default rate as a fallback.
      // In production:
      // 1. Try NBC API first
      // 2. Fallback to cached rate with warning
      // 3. If no cache, use AppConstants.defaultExchangeRate

      // Attempt to load from DB first (may have been updated by WorkManager)
      final dbResult = await getLatestRate();
      final dbRate = dbResult.fold(
        (_) => null,
        (rate) => rate,
      );

      if (dbRate != null && !_isRateStaleAt(dbRate.fetchedAt)) {
        return right(dbRate.rate);
      }

      // Fallback: use default rate and persist it
      final now = DateTime.now();
      final fallbackRate = ExchangeRate(
        id: 'fallback-${now.millisecondsSinceEpoch}',
        rate: AppConstants.defaultExchangeRate,
        source: 'fallback',
        fetchedAt: now,
      );

      await updateRate(fallbackRate);

      return right(fallbackRate.rate);
    } catch (e) {
      return left(ServerFailure.defaultError(details: e.toString()));
    }
  }

  @override
  bool isRateStale() {
    if (_lastFetchedAt == null) return true;
    return _isRateStaleAt(_lastFetchedAt!);
  }

  bool _isRateStaleAt(DateTime fetchedAt) {
    return DateTime.now().difference(fetchedAt) > _staleThreshold;
  }
}
