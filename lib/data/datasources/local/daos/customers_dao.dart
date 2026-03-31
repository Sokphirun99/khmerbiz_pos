import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';

part 'customers_dao.g.dart';

/// Data Access Object for Customers table.
@DriftAccessor(tables: [Customers])
class CustomersDao extends DatabaseAccessor<AppDatabase>
    with _$CustomersDaoMixin {
  /// Creates a new [CustomersDao] with the given [db].
  CustomersDao(super.db);

  /// Retrieves a customer by their [phone] number.
  Future<CustomerModel?> getCustomerByPhone(String phone) {
    return (select(customers)..where((tbl) => tbl.phone.equals(phone)))
        .getSingleOrNull();
  }

  /// Searches customers by [query] in name or phone.
  Future<List<CustomerModel>> searchCustomers(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(customers)
          ..where(
              (tbl) => tbl.phone.like(lowerQuery) | tbl.name.like(lowerQuery),))
        .get();
  }

  /// Updates the loyalty points for a [customerId] by adding [pointsToAdd].
  Future<void> updateLoyaltyPoints(
      String customerId, double pointsToAdd,) async {
    await customUpdate(
      'UPDATE customers SET loyaltyPoints = loyaltyPoints + ? WHERE id = ?',
      variables: [
        Variable.withReal(pointsToAdd),
        Variable.withString(customerId),
      ],
      updates: {customers},
    );
  }
}
