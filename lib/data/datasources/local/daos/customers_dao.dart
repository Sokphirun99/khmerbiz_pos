import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/database.dart';

part 'customers_dao.g.dart';

@DriftAccessor(tables: [Customers])
class CustomersDao extends DatabaseAccessor<AppDatabase> with _$CustomersDaoMixin {
  CustomersDao(super.db);

  Future<CustomerModel?> getCustomerByPhone(String phone) {
    return (select(customers)..where((tbl) => tbl.phone.equals(phone))).getSingleOrNull();
  }

  Future<List<CustomerModel>> searchCustomers(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(customers)
          ..where((tbl) => tbl.phone.like(lowerQuery) | tbl.name.like(lowerQuery)))
        .get();
  }

  Future<void> updateLoyaltyPoints(String customerId, double pointsToAdd) async {
    await customUpdate(
      'UPDATE customers SET loyaltyPoints = loyaltyPoints + ? WHERE id = ?',
      variables: [Variable.withReal(pointsToAdd), Variable.withString(customerId)],
      updates: {customers},
    );
  }
}
