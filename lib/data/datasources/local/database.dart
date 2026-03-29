import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/customers_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/inventory_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/products_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/sync_queue_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/transactions_dao.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

@DataClassName('UserModel')
@TableIndex(name: 'user_username_idx', columns: {#username})
@TableIndex(name: 'user_role_idx', columns: {#role})
@TableIndex(name: 'user_is_active_idx', columns: {#isActive})
class Users extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get username => text().unique()();
  TextColumn get pinHash => text()();
  TextColumn get fullNameKh => text()();
  TextColumn get fullNameEn => text()();
  TextColumn get role => text()();
  TextColumn get avatarPath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CategoryModel')
@TableIndex(name: 'category_parent_idx', columns: {#parentId})
@TableIndex(name: 'category_active_sort_idx', columns: {#isActive, #sortOrder})
class Categories extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get nameKh => text()();
  TextColumn get nameEn => text()();
  TextColumn get parentId => text().nullable().references(Categories, #id)();
  TextColumn get iconName => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ProductModel')
@TableIndex(name: 'product_barcode_idx', columns: {#barcode})
@TableIndex(name: 'product_category_idx', columns: {#categoryId})
@TableIndex(name: 'product_active_featured_idx', columns: {#isActive, #isFeatured})
@TableIndex(name: 'product_active_sort_idx', columns: {#isActive, #sortOrder})
class Products extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get barcode => text().unique().nullable()();
  TextColumn get nameKh => text()();
  TextColumn get nameEn => text()();
  TextColumn get categoryId => text().nullable().references(Categories, #id)();
  TextColumn get unit => text().withDefault(const Constant('pcs'))();
  RealColumn get costPrice => real().withDefault(const Constant(0))();
  RealColumn get retailPrice => real()();
  RealColumn get wholesalePrice => real().nullable()();
  RealColumn get stock => real().withDefault(const Constant(0))();
  RealColumn get reservedStock => real().withDefault(const Constant(0))();
  RealColumn get lowStockThreshold => real().withDefault(const Constant(5))();
  TextColumn get imagePath => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isFeatured => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get remoteId => text().nullable()();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('CustomerModel')
@TableIndex(name: 'customer_phone_idx', columns: {#phone})
@TableIndex(name: 'customer_tier_idx', columns: {#tier})
class Customers extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get phone => text().unique()();
  TextColumn get name => text()();
  TextColumn get email => text().nullable()();
  RealColumn get loyaltyPoints => real().withDefault(const Constant(0))();
  RealColumn get totalSpent => real().withDefault(const Constant(0))();
  IntColumn get totalTransactions => integer().withDefault(const Constant(0))();
  TextColumn get tier => text().withDefault(const Constant('regular'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionModel')
@TableIndex(name: 'transaction_date_idx', columns: {#transactionDate})
@TableIndex(name: 'transaction_staff_idx', columns: {#staffId})
@TableIndex(name: 'transaction_customer_idx', columns: {#customerId})
@TableIndex(name: 'transaction_status_idx', columns: {#status})
@TableIndex(name: 'transaction_sync_idx', columns: {#isSynced})
class Transactions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get receiptNumber => text().unique()();
  DateTimeColumn get transactionDate => dateTime()();
  TextColumn get staffId => text().references(Users, #id)();
  TextColumn get customerId => text().nullable().references(Customers, #id)();
  RealColumn get subtotal => real()();
  TextColumn get discountType => text().nullable()();
  RealColumn get discountValue => real().withDefault(const Constant(0))();
  RealColumn get discountAmount => real().withDefault(const Constant(0))();
  RealColumn get taxRate => real().withDefault(const Constant(0.10))();
  RealColumn get taxAmount => real().withDefault(const Constant(0))();
  RealColumn get totalAmount => real()();
  RealColumn get totalAmountUSD => real()();
  TextColumn get paymentMethod => text()();
  RealColumn get cashReceived => real().nullable()();
  RealColumn get changeGiven => real().nullable()();
  TextColumn get khqrReference => text().nullable()();
  TextColumn get khqrMd5 => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('completed'))();
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('TransactionItemModel')
@TableIndex(name: 'transaction_item_tx_idx', columns: {#transactionId})
@TableIndex(name: 'transaction_item_product_idx', columns: {#productId})
class TransactionItems extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get productNameSnapshot => text()();
  TextColumn get productNameEnSnapshot => text()();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  RealColumn get costPrice => real()();
  RealColumn get discountAmount => real().withDefault(const Constant(0))();
  RealColumn get subtotal => real()();
  TextColumn get modifiers => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('InventoryLogModel')
@TableIndex(name: 'inventory_log_product_time_idx', columns: {#productId, #timestamp})
@TableIndex(name: 'inventory_log_reason_idx', columns: {#reason})
@TableIndex(name: 'inventory_log_staff_idx', columns: {#staffId})
class InventoryLogs extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get productId => text().references(Products, #id)();
  RealColumn get changeAmount => real()();
  RealColumn get stockBefore => real()();
  RealColumn get stockAfter => real()();
  TextColumn get reason => text()();
  TextColumn get referenceId => text().nullable()();
  TextColumn get staffId => text().references(Users, #id)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SyncQueueModel')
@TableIndex(name: 'sync_queue_status_priority_idx', columns: {#status, #priority, #createdAt})
@TableIndex(name: 'sync_queue_entity_idx', columns: {#entityType, #entityId})
class SyncQueue extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get operationType => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()();
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get errorMessage => text().nullable()();
  IntColumn get priority => integer().withDefault(const Constant(5))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExchangeRateModel')
class ExchangeRates extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get baseCurrency => text().withDefault(const Constant('KHR'))();
  TextColumn get targetCurrency => text().withDefault(const Constant('USD'))();
  RealColumn get rate => real()();
  TextColumn get source => text()();
  DateTimeColumn get fetchedAt => dateTime()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Users,
  Categories,
  Products,
  Customers,
  Transactions,
  TransactionItems,
  InventoryLogs,
  SyncQueue,
  ExchangeRates,
], daos: [
  ProductsDao,
  TransactionsDao,
  CustomersDao,
  InventoryDao,
  SyncQueueDao,
],)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to == 2) {
          // Example migration implementation:
          // await m.addColumn(products, products.sortOrder);
        }
      },
      beforeOpen: (details) async {
        await customStatement('PRAGMA foreign_keys = ON');
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'khmerbiz_pos.db'));
    
    // Get encryption key from secure storage
    const storage = FlutterSecureStorage();
    var dbKey = await storage.read(key: 'db_encryption_key');
    if (dbKey == null) {
      dbKey = const Uuid().v4();
      await storage.write(key: 'db_encryption_key', value: dbKey);
    }
    
    return NativeDatabase(
      file,
      setup: (db) {
        db.execute("PRAGMA key = '$dbKey'");
      },
    );
  });
}
