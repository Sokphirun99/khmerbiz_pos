import 'package:drift/drift.dart';
import 'package:khmerbiz_pos/data/datasources/local/connection/connection_stub.dart'
    if (dart.library.io) 'package:khmerbiz_pos/data/datasources/local/connection/connection_mobile.dart'
    if (dart.library.js_interop) 'package:khmerbiz_pos/data/datasources/local/connection/connection_web.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/customers_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/inventory_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/products_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/sync_queue_dao.dart';
import 'package:khmerbiz_pos/data/datasources/local/daos/transactions_dao.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

/// Drift table for Users (Staff).
class Users extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Unique username for login.
  TextColumn get username => text().unique()();

  /// Hashed PIN for authentication.
  TextColumn get pinHash => text()();

  /// Full name in Khmer script.
  TextColumn get fullNameKh => text()();

  /// Full name in English.
  TextColumn get fullNameEn => text()();

  /// System role (e.g., admin, staff).
  TextColumn get role => text()();

  /// Path to avatar image.
  TextColumn get avatarPath => text().nullable()();

  /// Whether the user account is active.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Last successful login timestamp.
  DateTimeColumn get lastLoginAt => dateTime().nullable()();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for Product Categories.
class Categories extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Category name in Khmer script.
  TextColumn get nameKh => text()();

  /// Category name in English.
  TextColumn get nameEn => text()();

  /// Parent category ID for hierarchical structures.
  TextColumn get parentId => text().nullable().references(Categories, #id)();

  /// Name of the icon representing this category.
  TextColumn get iconName => text().nullable()();

  /// Hex color code for category branding/UI.
  TextColumn get colorHex => text().nullable()();

  /// Order for sorting categories in lists.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Whether the category is active.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for Products.
class Products extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Barcode for quick lookup.
  TextColumn get barcode => text().unique().nullable()();

  /// Product name in Khmer script.
  TextColumn get nameKh => text()();

  /// Product name in English.
  TextColumn get nameEn => text()();

  /// Associated category ID.
  TextColumn get categoryId => text().nullable().references(Categories, #id)();

  /// Unit of measurement (e.g., pcs, box).
  TextColumn get unit => text().withDefault(const Constant('pcs'))();

  /// Unit cost price.
  RealColumn get costPrice => real().withDefault(const Constant(0))();

  /// Standard retail price.
  RealColumn get retailPrice => real()();

  /// Optional wholesale price.
  RealColumn get wholesalePrice => real().nullable()();

  /// Current stock level.
  RealColumn get stock => real().withDefault(const Constant(0))();

  /// Stock reserved for pending orders.
  RealColumn get reservedStock => real().withDefault(const Constant(0))();

  /// Alert threshold for low stock.
  RealColumn get lowStockThreshold => real().withDefault(const Constant(5))();

  /// Path to product image.
  TextColumn get imagePath => text().nullable()();

  /// Whether the product is available for sale.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  /// Whether the product is featured in highlights.
  BoolColumn get isFeatured => boolean().withDefault(const Constant(false))();

  /// Order for sorting products.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  /// Last modification timestamp.
  DateTimeColumn get updatedAt => dateTime()();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  /// Associated remote system identifier.
  TextColumn get remoteId => text().nullable()();

  /// Whether the record has been synced to server.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for Customers.
class Customers extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Unique mobile phone number.
  TextColumn get phone => text().unique()();

  /// Customer's name.
  TextColumn get name => text()();

  /// Contact email address.
  TextColumn get email => text().nullable()();

  /// Accumulated loyalty points.
  RealColumn get loyaltyPoints => real().withDefault(const Constant(0))();

  /// Total amount spent by the customer.
  RealColumn get totalSpent => real().withDefault(const Constant(0))();

  /// Total number of transactions.
  IntColumn get totalTransactions => integer().withDefault(const Constant(0))();

  /// Loyalty tier (e.g., regular, silver, gold).
  TextColumn get tier => text().withDefault(const Constant('regular'))();

  /// Additional notes about the customer.
  TextColumn get notes => text().nullable()();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for Transaction headers.
class Transactions extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Human-readable receipt number.
  TextColumn get receiptNumber => text().unique()();

  /// Date and time of the transaction.
  DateTimeColumn get transactionDate => dateTime()();

  /// ID of the staff who processed the sale.
  TextColumn get staffId => text().references(Users, #id)();

  /// ID of the customer (optional).
  TextColumn get customerId => text().nullable().references(Customers, #id)();

  /// Sum of item subtotals before discounts/tax.
  RealColumn get subtotal => real()();

  /// Type of discount (percentage, fixed).
  TextColumn get discountType => text().nullable()();

  /// Value of the discount given.
  RealColumn get discountValue => real().withDefault(const Constant(0))();

  /// Calculated discount amount.
  RealColumn get discountAmount => real().withDefault(const Constant(0))();

  /// Applicable tax rate.
  RealColumn get taxRate => real().withDefault(const Constant(0.10))();

  /// Calculated tax amount.
  RealColumn get taxAmount => real().withDefault(const Constant(0))();

  /// Total final amount in KHR.
  RealColumn get totalAmount => real()();

  /// Total final amount in USD.
  RealColumn get totalAmountUSD => real()();

  /// Payment method used (cash, khqr).
  TextColumn get paymentMethod => text()();

  /// Amount of cash received from customer.
  RealColumn get cashReceived => real().nullable()();

  /// Amount of change given to customer.
  RealColumn get changeGiven => real().nullable()();

  /// Reference number for KHQR payments.
  TextColumn get khqrReference => text().nullable()();

  /// MD5 hash for payment status verification.
  TextColumn get khqrMd5 => text().nullable()();

  /// Order status (completed, voided, pending).
  TextColumn get status => text().withDefault(const Constant('completed'))();

  /// Whether the transaction has been synced.
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  /// Timestamp of successful synchronization.
  DateTimeColumn get syncedAt => dateTime().nullable()();

  /// Additional notes for the transaction.
  TextColumn get notes => text().nullable()();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for Transaction line items.
class TransactionItems extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Reference to the parent transaction header.
  TextColumn get transactionId => text().references(Transactions, #id)();

  /// Reference to the product sold.
  TextColumn get productId => text().references(Products, #id)();

  /// Snapshot of the product core name in Khmer script.
  TextColumn get productNameSnapshot => text()();

  /// Snapshot of the product core name in English.
  TextColumn get productNameEnSnapshot => text()();

  /// Quantity of product sold.
  RealColumn get quantity => real()();

  /// Unit price at time of sale.
  RealColumn get unitPrice => real()();

  /// Unit cost price for margin calculation.
  RealColumn get costPrice => real()();

  /// Discount amount applied directly to this item.
  RealColumn get discountAmount => real().withDefault(const Constant(0))();

  /// Calculated subtotal for this item.
  RealColumn get subtotal => real()();

  /// JSON serialized modifiers/options.
  TextColumn get modifiers => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for tracking Inventory changes.
class InventoryLogs extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Reference to the affected product.
  TextColumn get productId => text().references(Products, #id)();

  /// Amount changed (positive for stock-in, negative for stock-out).
  RealColumn get changeAmount => real()();

  /// Stock level before change.
  RealColumn get stockBefore => real()();

  /// Stock level after change.
  RealColumn get stockAfter => real()();

  /// Reason for the change (sale, return, adjustment, restock).
  TextColumn get reason => text()();

  /// Reference ID (e.g., transaction ID, shipment ID).
  TextColumn get referenceId => text().nullable()();

  /// Staff member who performed the action.
  TextColumn get staffId => text().references(Users, #id)();

  /// Optional notes for the log entry.
  TextColumn get notes => text().nullable()();

  /// Timestamp of the inventory event.
  DateTimeColumn get timestamp => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for the Synchronization Queue.
class SyncQueue extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Type of operation (create, update, delete).
  TextColumn get operationType => text()();

  /// Entity being synced (product, transaction, etc).
  TextColumn get entityType => text()();

  /// Local identifier of the entity.
  TextColumn get entityId => text()();

  /// JSON payload representation of the entity.
  TextColumn get payload => text()();

  /// Number of sync attempts.
  IntColumn get attemptCount => integer().withDefault(const Constant(0))();

  /// Timestamp of the last sync attempt.
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  /// Status of the sync task (pending, processing, failed, completed).
  TextColumn get status => text().withDefault(const Constant('pending'))();

  /// Last error message encountered during sync.
  TextColumn get errorMessage => text().nullable()();

  /// Operation priority.
  IntColumn get priority => integer().withDefault(const Constant(5))();

  /// Record creation timestamp.
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Drift table for Exchange Rates.
class ExchangeRates extends Table {
  /// Unique identifier (UUID).
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Base currency (defaults to KHR).
  TextColumn get baseCurrency => text().withDefault(const Constant('KHR'))();

  /// Target currency (defaults to USD).
  TextColumn get targetCurrency => text().withDefault(const Constant('USD'))();

  /// Conversion rate.
  RealColumn get rate => real()();

  /// Source of the rate data (e.g., nbc, manual).
  TextColumn get source => text()();

  /// Timestamp when the rate was fetched/set.
  DateTimeColumn get fetchedAt => dateTime()();

  /// Whether the rate is currently active.
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();

  @override
  Set<Column> get primaryKey => {id};
}

/// The main local database for the KhmerBiz POS application.
///
/// Provides type-safe access to all local tables and encapsulates DAOs.
@DriftDatabase(
  tables: [
    Users,
    Categories,
    Products,
    Customers,
    Transactions,
    TransactionItems,
    InventoryLogs,
    SyncQueue,
    ExchangeRates,
  ],
  daos: [
    ProductsDao,
    TransactionsDao,
    CustomersDao,
    InventoryDao,
    SyncQueueDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Creates a primary [AppDatabase] instance.
  AppDatabase() : super(openConnection());

  /// Creates a testing [AppDatabase] instance with a custom [executor].
  AppDatabase.forTesting(super.executor);

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
