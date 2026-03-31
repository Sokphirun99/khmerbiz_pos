import 'package:fpdart/fpdart.dart';
import 'package:khmerbiz_pos/core/error/failures.dart';
import 'package:khmerbiz_pos/domain/entities/customer.dart';

/// Repository interface for customer management and loyalty programs.
abstract class CustomerRepository {
  /// Finds a customer by their [phone] number.
  ///
  /// Returns a [Customer] if found, null if not, or a [Failure] on error.
  Future<Either<Failure, Customer?>> getCustomerByPhone(String phone);

  /// Performs a fuzzy search for customers by name or phone.
  Future<Either<Failure, List<Customer>>> searchCustomers(String query);

  /// Updates a customer's loyalty point balance.
  ///
  /// The [pointsToAdd] can be positive for additions or negative for redemptions.
  Future<Either<Failure, void>> updateLoyaltyPoints(
    String customerId,
    double pointsToAdd,
  );
}
