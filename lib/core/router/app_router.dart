import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khmerbiz_pos/domain/entities/product.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/screens/inventory_screen.dart';
import 'package:khmerbiz_pos/features/inventory/presentation/widgets/stock_adjustment_sheet.dart';
import 'package:khmerbiz_pos/features/products/presentation/screens/add_edit_product_screen.dart';
import 'package:khmerbiz_pos/features/products/presentation/screens/product_detail_screen.dart';
import 'package:khmerbiz_pos/features/products/presentation/screens/product_list_screen.dart';
import 'package:khmerbiz_pos/features/settings/presentation/screens/settings_screen.dart';
import 'package:khmerbiz_pos/storybook/storybook_screen.dart';


/// App router configuration using go_router.
///
/// This file defines all routes for the application using a declarative
/// routing approach. Routes are organized by feature module.
///
/// Route naming convention:
/// - Screen routes: '/feature' or '/feature/sub-feature'
/// - Named routes: 'feature-name' or 'feature-sub-name'
///
/// Example navigation:
/// ```dart
/// // Using path
/// context.go('/products');
///
/// // Using name
/// context.goNamed('product-detail', params: {'id': '123'});
/// ```
final class AppRouter {
  const AppRouter._();

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE PATHS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Splash screen route
  static const String splash = '/splash';

  /// Login screen route
  static const String login = '/login';

  /// Register screen route
  static const String register = '/register';

  /// Forgot password screen route
  static const String forgotPassword = '/forgot-password';

  /// Home screen route (main dashboard)
  static const String home = '/home';

  /// POS screen route
  static const String pos = '/pos';

  /// Products list route
  static const String products = '/products';

  /// Product detail route
  static const String productDetail = '/products/:id';

  /// Add product route
  static const String productAdd = '/products/add';

  /// Edit product route
  static const String productEdit = '/products/:id/edit';

  /// Inventory screen route
  static const String inventory = '/inventory';

  /// Stock adjustment route
  static const String stockAdjustment = '/inventory/adjust';

  /// Transactions list route
  static const String transactions = '/transactions';

  /// Transaction detail route
  static const String transactionDetail = '/transactions/:id';

  /// Cart screen route (floating/overlay)
  static const String cart = '/cart';

  /// Checkout screen route
  static const String checkout = '/checkout';

  /// Payment screen route
  static const String payment = '/payment';

  /// Receipt screen route
  static const String receipt = '/receipt/:transactionId';

  /// Customers list route
  static const String customers = '/customers';

  /// Customer detail route
  static const String customerDetail = '/customers/:id';

  /// Add customer route
  static const String customerAdd = '/customers/add';

  /// Reports screen route
  static const String reports = '/reports';

  /// Sales report route
  static const String salesReport = '/reports/sales';

  /// Inventory report route
  static const String inventoryReport = '/reports/inventory';

  /// Settings screen route
  static const String settings = '/settings';

  /// Business info settings route
  static const String settingsBusiness = '/settings/business';

  /// Printer settings route
  static const String settingsPrinter = '/settings/printer';

  /// Language settings route
  static const String settingsLanguage = '/settings/language';

  /// About app route
  static const String about = '/about';

  /// Storybook dev screen route
  static const String storybook = '/dev/storybook';

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE NAMES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Name for splash screen route
  static const String splashName = 'splash';

  /// Name for login screen route
  static const String loginName = 'login';

  /// Name for register screen route
  static const String registerName = 'register';

  /// Name for forgot password screen route
  static const String forgotPasswordName = 'forgot-password';

  /// Name for home screen route
  static const String homeName = 'home';

  /// Name for POS screen route
  static const String posName = 'pos';

  /// Name for products list route
  static const String productsName = 'products';

  /// Name for product detail route
  static const String productDetailName = 'product-detail';

  /// Name for add product route
  static const String productAddName = 'product-add';

  /// Name for edit product route
  static const String productEditName = 'product-edit';

  /// Name for inventory screen route
  static const String inventoryName = 'inventory';

  /// Name for stock adjustment route
  static const String stockAdjustmentName = 'stock-adjustment';

  /// Alias for stock adjustment name for compatibility
  static const String inventoryAdjustName = stockAdjustmentName;

  /// Name for transactions list route
  static const String transactionsName = 'transactions';

  /// Name for transaction detail route
  static const String transactionDetailName = 'transaction-detail';

  /// Name for cart screen route
  static const String cartName = 'cart';

  /// Name for checkout screen route
  static const String checkoutName = 'checkout';

  /// Name for payment screen route
  static const String paymentName = 'payment';

  /// Name for receipt screen route
  static const String receiptName = 'receipt';

  /// Name for customers list route
  static const String customersName = 'customers';

  /// Name for customer detail route
  static const String customerDetailName = 'customer-detail';

  /// Name for add customer route
  static const String customerAddName = 'customer-add';

  /// Name for reports screen route
  static const String reportsName = 'reports';

  /// Name for sales report route
  static const String salesReportName = 'sales-report';

  /// Name for inventory report route
  static const String inventoryReportName = 'inventory-report';

  /// Name for settings screen route
  static const String settingsName = 'settings';

  /// Name for business settings route
  static const String settingsBusinessName = 'settings-business';

  /// Name for printer settings route
  static const String settingsPrinterName = 'settings-printer';

  /// Name for language settings route
  static const String settingsLanguageName = 'settings-language';

  /// Name for about screen route
  static const String aboutName = 'about';

  /// Name for storybook screen route
  static const String storybookName = 'storybook';

  /// Create the GoRouter configuration.
  ///
  /// [authRequired] - List of routes that require authentication
  /// [initialLocation] - Initial route location
  /// [navigatorKey] - Optional navigator key for global navigation
  /// [onNavigate] - Optional callback when navigation occurs
  /// [redirect] - Optional redirect logic for auth checking
  static GoRouter createRouter({
    String initialLocation = splash,
    GlobalKey<NavigatorState>? navigatorKey,
    Future<String?> Function(BuildContext, GoRouterState)? redirect,
  }) {
    return GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: initialLocation,
      debugLogDiagnostics: true,
      routes: [
        // ═══════════════════════════════════════════════════════════════════════
        // PUBLIC ROUTES (No auth required)
        // ═══════════════════════════════════════════════════════════════════════

        // Splash screen
        GoRoute(
          path: splash,
          name: splashName,
          builder: (context, state) => const PlaceholderSplashScreen(),
        ),

        // Login screen
        GoRoute(
          path: login,
          name: loginName,
          builder: (context, state) => const PlaceholderLoginScreen(),
        ),

        // Register screen
        GoRoute(
          path: register,
          name: registerName,
          builder: (context, state) => const PlaceholderRegisterScreen(),
        ),

        // Forgot password screen
        GoRoute(
          path: forgotPassword,
          name: forgotPasswordName,
          builder: (context, state) => const PlaceholderForgotPasswordScreen(),
        ),

        // ═══════════════════════════════════════════════════════════════════════
        // AUTHENTICATED ROUTES (Shell route with navigation)
        // ═══════════════════════════════════════════════════════════════════════

        // Main shell route with bottom navigation
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) =>
              PlaceholderMainScaffold(child: child),
          routes: [
            // Home screen
            GoRoute(
              path: home,
              name: homeName,
              builder: (context, state) => const PlaceholderHomeScreen(),
            ),

            // POS screen
            GoRoute(
              path: pos,
              name: posName,
              builder: (context, state) => const PlaceholderPOSScreen(),
            ),

            // Products screens
            GoRoute(
              path: products,
              name: productsName,
              builder: (context, state) => const ProductListScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: productAddName,
                  builder: (context, state) {
                    final extra = state.extra;
                    final barcode = extra is Map<String, dynamic>
                        ? extra['barcode'] as String?
                        : null;
                    return AddEditProductScreen(initialBarcode: barcode);
                  },
                ),
                GoRoute(
                  path: ':id',
                  name: productDetailName,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return ProductDetailScreen(productId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: productEditName,
                      builder: (context, state) {
                        final product = state.extra as Product?;
                        return AddEditProductScreen(product: product);
                      },
                    ),
                  ],
                ),
              ],
            ),

            // Inventory screens
            GoRoute(
              path: inventory,
              name: inventoryName,
              builder: (context, state) => const InventoryScreen(),
              routes: [
                GoRoute(
                  path: 'adjust',
                  name: stockAdjustmentName,
                  builder: (context, state) {
                    final product = state.extra as Product?;
                    if (product == null) {
                      return const InventoryScreen();
                    }
                    return Scaffold(
                      body: Builder(
                        builder: (ctx) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            StockAdjustmentSheet.show(ctx, product);
                          });
                          return const SizedBox.shrink();
                        },
                      ),
                    );
                  },
                ),
              ],
            ),

            // Transactions screens
            GoRoute(
              path: transactions,
              name: transactionsName,
              builder: (context, state) =>
                  const PlaceholderTransactionsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: transactionDetailName,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return PlaceholderTransactionDetailScreen(
                      transactionId: id,
                    );
                  },
                ),
              ],
            ),

            // Customers screens
            GoRoute(
              path: customers,
              name: customersName,
              builder: (context, state) => const PlaceholderCustomersScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: customerAddName,
                  builder: (context, state) =>
                      const PlaceholderCustomerFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  name: customerDetailName,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return PlaceholderCustomerDetailScreen(customerId: id);
                  },
                ),
              ],
            ),

            // Reports screens
            GoRoute(
              path: reports,
              name: reportsName,
              builder: (context, state) => const PlaceholderReportsScreen(),
              routes: [
                GoRoute(
                  path: 'sales',
                  name: salesReportName,
                  builder: (context, state) =>
                      const PlaceholderSalesReportScreen(),
                ),
                GoRoute(
                  path: 'inventory',
                  name: inventoryReportName,
                  builder: (context, state) =>
                      const PlaceholderInventoryReportScreen(),
                ),
              ],
            ),

            // Settings screens
            GoRoute(
              path: settings,
              name: settingsName,
              builder: (context, state) => const SettingsScreen(),

              routes: [
                GoRoute(
                  path: 'business',
                  name: settingsBusinessName,
                  builder: (context, state) =>
                      const PlaceholderBusinessSettingsScreen(),
                ),
                GoRoute(
                  path: 'printer',
                  name: settingsPrinterName,
                  builder: (context, state) =>
                      const PlaceholderPrinterSettingsScreen(),
                ),
                GoRoute(
                  path: 'language',
                  name: settingsLanguageName,
                  builder: (context, state) =>
                      const PlaceholderLanguageSettingsScreen(),
                ),
              ],
            ),
          ],
        ),

        // ═══════════════════════════════════════════════════════════════════════
        // FLOATING/OVERLAY ROUTES
        // ═══════════════════════════════════════════════════════════════════════

        // Cart screen (can be shown as modal bottom sheet)
        GoRoute(
          path: cart,
          name: cartName,
          builder: (context, state) => const PlaceholderCartScreen(),
        ),

        // Checkout screen
        GoRoute(
          path: checkout,
          name: checkoutName,
          builder: (context, state) => const PlaceholderCheckoutScreen(),
        ),

        // Payment screen
        GoRoute(
          path: payment,
          name: paymentName,
          builder: (context, state) => const PlaceholderPaymentScreen(),
        ),

        // Receipt screen
        GoRoute(
          path: receipt,
          name: receiptName,
          builder: (context, state) {
            final transactionId = state.pathParameters['transactionId'] ?? '';
            return PlaceholderReceiptScreen(transactionId: transactionId);
          },
        ),

        // ═══════════════════════════════════════════════════════════════════════
        // OTHER ROUTES
        // ═══════════════════════════════════════════════════════════════════════

        // About screen
        GoRoute(
          path: about,
          name: aboutName,
          builder: (context, state) => const PlaceholderAboutScreen(),
        ),

        // Storybook screen (Dev only)
        GoRoute(
          path: storybook,
          name: storybookName,
          builder: (context, state) {
            if (!kDebugMode) {
              return const PlaceholderHomeScreen();
            }
            return const StorybookScreen();
          },
        ),
      ],
    );
  }

  /// Get the redirect configuration for auth checking.
  ///
  /// This should be used with [createRouter] to enable automatic
  /// auth-based redirects.
  ///
  /// Example:
  /// ```dart
  /// final router = AppRouter.createRouter(
  ///   redirect: AppRouter.authRedirect(() => isLoggedIn),
  /// );
  /// ```
  static Future<String?> Function(BuildContext, GoRouterState) authRedirect(
    bool Function() isLoggedIn,
  ) {
    return (context, state) async {
      final isAuthenticated = isLoggedIn();
      final currentLocation = state.fullPath;

      // Public routes that don't require auth
      final publicRoutes = [
        splash,
        login,
        register,
        forgotPassword,
      ];

      // If trying to access public route while logged in, redirect to home
      if (isAuthenticated && publicRoutes.contains(currentLocation)) {
        return home;
      }

      // If trying to access protected route while not logged in, redirect to login
      if (!isAuthenticated && !publicRoutes.contains(currentLocation)) {
        return login;
      }

      return null;
    };
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PLACEHOLDER SCREENS
// These will be replaced with actual screens in subsequent prompts
// ═══════════════════════════════════════════════════════════════════════════════

/// Temporary placeholder for the Splash screen.
class PlaceholderSplashScreen extends StatelessWidget {
  /// Creates a [PlaceholderSplashScreen].
  const PlaceholderSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('KhmerBiz POS', style: TextStyle(fontSize: 24)),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Temporary placeholder for the Login screen.
class PlaceholderLoginScreen extends StatelessWidget {
  /// Creates a [PlaceholderLoginScreen].
  const PlaceholderLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Register screen.
class PlaceholderRegisterScreen extends StatelessWidget {
  /// Creates a [PlaceholderRegisterScreen].
  const PlaceholderRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Register Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Forgot Password screen.
class PlaceholderForgotPasswordScreen extends StatelessWidget {
  /// Creates a [PlaceholderForgotPasswordScreen].
  const PlaceholderForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: const Center(
        child: Text('Forgot Password Screen - To be implemented'),
      ),
    );
  }
}

/// Main layout scaffold for authenticated users.
class PlaceholderMainScaffold extends StatelessWidget {
  /// Creates a [PlaceholderMainScaffold] with a [child] widget.
  const PlaceholderMainScaffold({required this.child, super.key});
  /// The main content area of the scaffold
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'POS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRouter.home);
            case 1:
              context.go(AppRouter.pos);
            case 2:
              context.go(AppRouter.products);
            case 3:
              context.go(AppRouter.transactions);
            case 4:
              context.go(AppRouter.settings);
          }
        },
      ),
    );
  }
}

/// Temporary placeholder for the Home screen.
class PlaceholderHomeScreen extends StatelessWidget {
  /// Creates a [PlaceholderHomeScreen].
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the POS screen.
class PlaceholderPOSScreen extends StatelessWidget {
  /// Creates a [PlaceholderPOSScreen].
  const PlaceholderPOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS')),
      body: const Center(child: Text('POS Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Products list screen.
class PlaceholderProductsScreen extends StatelessWidget {
  /// Creates a [PlaceholderProductsScreen].
  const PlaceholderProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: const Center(child: Text('Products List - To be implemented')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRouter.productAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Temporary placeholder for the Product Detail screen.
class PlaceholderProductDetailScreen extends StatelessWidget {
  /// Creates a [PlaceholderProductDetailScreen] for [productId].
  const PlaceholderProductDetailScreen({required this.productId, super.key});
  /// The unique identifier of the product to display
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Detail')),
      body: Center(child: Text('Product Detail for ID: $productId')),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('productId', productId));
  }
}

/// Temporary placeholder for the Product Form screen.
class PlaceholderProductFormScreen extends StatelessWidget {
  /// Creates a [PlaceholderProductFormScreen].
  const PlaceholderProductFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Form')),
      body: const Center(child: Text('Product Form - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Inventory screen.
class PlaceholderInventoryScreen extends StatelessWidget {
  /// Creates a [PlaceholderInventoryScreen].
  const PlaceholderInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: const Center(child: Text('Inventory Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Stock Adjustment screen.
class PlaceholderStockAdjustmentScreen extends StatelessWidget {
  /// Creates a [PlaceholderStockAdjustmentScreen].
  const PlaceholderStockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustment')),
      body: const Center(child: Text('Stock Adjustment - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Transactions list screen.
class PlaceholderTransactionsScreen extends StatelessWidget {
  /// Creates a [PlaceholderTransactionsScreen].
  const PlaceholderTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: const Center(child: Text('Transactions List - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Transaction Detail screen.
class PlaceholderTransactionDetailScreen extends StatelessWidget {
  /// Creates a [PlaceholderTransactionDetailScreen] for [transactionId].
  const PlaceholderTransactionDetailScreen({
    required this.transactionId,
    super.key,
  });
  /// The unique identifier of the transaction to display
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Detail')),
      body: Center(child: Text('Transaction Detail for ID: $transactionId')),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('transactionId', transactionId));
  }
}

/// Temporary placeholder for the Cart screen.
class PlaceholderCartScreen extends StatelessWidget {
  /// Creates a [PlaceholderCartScreen].
  const PlaceholderCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Center(child: Text('Cart Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Checkout screen.
class PlaceholderCheckoutScreen extends StatelessWidget {
  /// Creates a [PlaceholderCheckoutScreen].
  const PlaceholderCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Checkout Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Payment screen.
class PlaceholderPaymentScreen extends StatelessWidget {
  /// Creates a [PlaceholderPaymentScreen].
  const PlaceholderPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: const Center(child: Text('Payment Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Receipt screen.
class PlaceholderReceiptScreen extends StatelessWidget {
  /// Creates a [PlaceholderReceiptScreen] for [transactionId].
  const PlaceholderReceiptScreen({required this.transactionId, super.key});
  /// The unique identifier of the transaction for the receipt
  final String transactionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt')),
      body: Center(child: Text('Receipt for Transaction: $transactionId')),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('transactionId', transactionId));
  }
}

/// Temporary placeholder for the Customers list screen.
class PlaceholderCustomersScreen extends StatelessWidget {
  /// Creates a [PlaceholderCustomersScreen].
  const PlaceholderCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customers')),
      body: const Center(child: Text('Customers List - To be implemented')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRouter.customerAdd),
        child: const Icon(Icons.add),
      ),
    );
  }
}

/// Temporary placeholder for the Customer Detail screen.
class PlaceholderCustomerDetailScreen extends StatelessWidget {
  /// Creates a [PlaceholderCustomerDetailScreen] for [customerId].
  const PlaceholderCustomerDetailScreen({required this.customerId, super.key});
  /// The unique identifier of the customer to display
  final String customerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Detail')),
      body: Center(child: Text('Customer Detail for ID: $customerId')),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('customerId', customerId));
  }
}

/// Temporary placeholder for the Customer Form screen.
class PlaceholderCustomerFormScreen extends StatelessWidget {
  /// Creates a [PlaceholderCustomerFormScreen].
  const PlaceholderCustomerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Form')),
      body: const Center(child: Text('Customer Form - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Reports screen.
class PlaceholderReportsScreen extends StatelessWidget {
  /// Creates a [PlaceholderReportsScreen].
  const PlaceholderReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Reports Screen - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Sales Report screen.
class PlaceholderSalesReportScreen extends StatelessWidget {
  /// Creates a [PlaceholderSalesReportScreen].
  const PlaceholderSalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report')),
      body: const Center(child: Text('Sales Report - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Inventory Report screen.
class PlaceholderInventoryReportScreen extends StatelessWidget {
  /// Creates a [PlaceholderInventoryReportScreen].
  const PlaceholderInventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Report')),
      body: const Center(child: Text('Inventory Report - To be implemented')),
    );
  }
}




/// Temporary placeholder for the Business Settings screen.
class PlaceholderBusinessSettingsScreen extends StatelessWidget {
  /// Creates a [PlaceholderBusinessSettingsScreen].
  const PlaceholderBusinessSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Info')),
      body: const Center(child: Text('Business Settings - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Printer Settings screen.
class PlaceholderPrinterSettingsScreen extends StatelessWidget {
  /// Creates a [PlaceholderPrinterSettingsScreen].
  const PlaceholderPrinterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Settings')),
      body: const Center(child: Text('Printer Settings - To be implemented')),
    );
  }
}

/// Temporary placeholder for the Language Settings screen.
class PlaceholderLanguageSettingsScreen extends StatelessWidget {
  /// Creates a [PlaceholderLanguageSettingsScreen].
  const PlaceholderLanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: const Center(child: Text('Language Settings - To be implemented')),
    );
  }
}

/// Temporary placeholder for the About screen.
class PlaceholderAboutScreen extends StatelessWidget {
  /// Creates a [PlaceholderAboutScreen].
  const PlaceholderAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About Screen - To be implemented')),
    );
  }
}
