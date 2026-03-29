import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/exchange_rate.dart';

abstract class ExchangeRateRepository {
  Future<Either<Failure, ExchangeRate>> getLatestRate();
  Future<Either<Failure, void>> updateRate(ExchangeRate rate);
  double getCachedRate();
}
