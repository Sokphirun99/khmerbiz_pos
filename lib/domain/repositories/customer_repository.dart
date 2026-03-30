import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';

abstract class CustomerRepository {
  Future<Either<Failure, Customer?>> getCustomerByPhone(String phone);
  Future<Either<Failure, List<Customer>>> searchCustomers(String query);
  Future<Either<Failure, void>> updateLoyaltyPoints(
      String customerId, double pointsToAdd);
}
