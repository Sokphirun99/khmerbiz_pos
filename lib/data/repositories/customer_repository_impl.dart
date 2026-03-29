import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/local/database.dart';
import '../datasources/local/daos/customers_dao.dart';

@LazySingleton(as: CustomerRepository)
class CustomerRepositoryImpl implements CustomerRepository {
  final CustomersDao _dao;

  CustomerRepositoryImpl(this._dao);

  Customer _mapToDomain(CustomerModel model) {
    return Customer(
      id: model.id,
      phone: model.phone,
      name: model.name,
      email: model.email,
      loyaltyPoints: model.loyaltyPoints,
      totalSpent: model.totalSpent,
      totalTransactions: model.totalTransactions,
      tier: model.tier,
      notes: model.notes,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<Either<Failure, Customer?>> getCustomerByPhone(String phone) async {
    try {
      final raw = await _dao.getCustomerByPhone(phone);
      return right(raw != null ? _mapToDomain(raw) : null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Customer>>> searchCustomers(String query) async {
    try {
      final list = await _dao.searchCustomers(query);
      return right(list.map(_mapToDomain).toList());
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLoyaltyPoints(String customerId, double pointsToAdd) async {
    try {
      await _dao.updateLoyaltyPoints(customerId, pointsToAdd);
      return right(null);
    } catch (e) {
      return left(CacheFailure.defaultError(details: e.toString()));
    }
  }
}
