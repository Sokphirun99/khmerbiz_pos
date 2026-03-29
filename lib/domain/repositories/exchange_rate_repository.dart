import 'package:fpdart/fpdart.dart';
import '../../core/error/failures.dart';
import '../entities/exchange_rate.dart';

abstract class ExchangeRateRepository {
  Future<Either<Failure, ExchangeRate>> getLatestRate();
  Future<Either<Failure, void>> updateRate(ExchangeRate rate);
}
