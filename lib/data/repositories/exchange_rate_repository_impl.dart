import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:drift/drift.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/exchange_rate.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../datasources/local/database.dart';

@LazySingleton(as: ExchangeRateRepository)
class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  final AppDatabase _db;

  ExchangeRateRepositoryImpl(this._db);

  @override
  Future<Either<Failure, ExchangeRate>> getLatestRate() async {
    try {
      final rateModel = await (_db.select(_db.exchangeRates)
            ..where((tbl) => tbl.isActive.equals(true))
            ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
            ..limit(1))
          .getSingleOrNull();

      if (rateModel == null) {
        return left(CacheFailure.defaultError(details: 'No exchange rate found'));
      }

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
      // Basic implementation
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }
}
