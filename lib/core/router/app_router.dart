import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  // ═══════════════════════════════════════════════════════════════════════════
  // ROUTE NAMES
  // ═══════════════════════════════════════════════════════════════════════════

  static const String splashName = 'splash';
  static const String loginName = 'login';
  static const String registerName = 'register';
  static const String forgotPasswordName = 'forgot-password';
  static const String homeName = 'home';
  static const String posName = 'pos';
  static const String productsName = 'products';
  static const String productDetailName = 'product-detail';
  static const String productAddName = 'product-add';
  static const String productEditName = 'product-edit';
  static const String inventoryName = 'inventory';
  static const String stockAdjustmentName = 'stock-adjustment';
  static const String transactionsName = 'transactions';
  static const String transactionDetailName = 'transaction-detail';
  static const String cartName = 'cart';
  static const String checkoutName = 'checkout';
  static const String paymentName = 'payment';
  static const String receiptName = 'receipt';
  static const String customersName = 'customers';
  static const String customerDetailName = 'customer-detail';
  static const String customerAddName = 'customer-add';
  static const String reportsName = 'reports';
  static const String salesReportName = 'sales-report';
  static const String inventoryReportName = 'inventory-report';
  static const String settingsName = 'settings';
  static const String settingsBusinessName = 'settings-business';
  static const String settingsPrinterName = 'settings-printer';
  static const String settingsLanguageName = 'settings-language';
  static const String aboutName = 'about';

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
          builder: (BuildContext context, GoRouterState state, Widget child) => PlaceholderMainScaffold(child: child),
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
              builder: (context, state) => const PlaceholderProductsScreen(),
              routes: [
                GoRoute(
                  path: 'add',
                  name: productAddName,
                  builder: (context, state) => const PlaceholderProductFormScreen(),
                ),
                GoRoute(
                  path: ':id',
                  name: productDetailName,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return PlaceholderProductDetailScreen(productId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'edit',
                      name: productEditName,
                      builder: (context, state) => const PlaceholderProductFormScreen(),
                    ),
                  ],
                ),
              ],
            ),

            // Inventory screens
            GoRoute(
              path: inventory,
              name: inventoryName,
              builder: (context, state) => const PlaceholderInventoryScreen(),
              routes: [
                GoRoute(
                  path: 'adjust',
                  name: stockAdjustmentName,
                  builder: (context, state) => const PlaceholderStockAdjustmentScreen(),
                ),
              ],
            ),

            // Transactions screens
            GoRoute(
              path: transactions,
              name: transactionsName,
              builder: (context, state) => const PlaceholderTransactionsScreen(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: transactionDetailName,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return PlaceholderTransactionDetailScreen(transactionId: id);
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
                  builder: (context, state) => const PlaceholderCustomerFormScreen(),
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
                  builder: (context, state) => const PlaceholderSalesReportScreen(),
                ),
                GoRoute(
                  path: 'inventory',
                  name: inventoryReportName,
                  builder: (context, state) => const PlaceholderInventoryReportScreen(),
                ),
              ],
            ),

            // Settings screens
            GoRoute(
              path: settings,
              name: settingsName,
              builder: (context, state) => const PlaceholderSettingsScreen(),
              routes: [
                GoRoute(
                  path: 'business',
                  name: settingsBusinessName,
                  builder: (context, state) => const PlaceholderBusinessSettingsScreen(),
                ),
                GoRoute(
                  path: 'printer',
                  name: settingsPrinterName,
                  builder: (context, state) => const PlaceholderPrinterSettingsScreen(),
                ),
                GoRoute(
                  path: 'language',
                  name: settingsLanguageName,
                  builder: (context, state) => const PlaceholderLanguageSettingsScreen(),
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
  ///   redirect: AppRouter.authRedirect(isLoggedIn),
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

class PlaceholderSplashScreen extends StatelessWidget {
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

class PlaceholderLoginScreen extends StatelessWidget {
  const PlaceholderLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: const Center(child: Text('Login Screen - To be implemented')),
    );
  }
}

class PlaceholderRegisterScreen extends StatelessWidget {
  const PlaceholderRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: const Center(child: Text('Register Screen - To be implemented')),
    );
  }
}

class PlaceholderForgotPasswordScreen extends StatelessWidget {
  const PlaceholderForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: const Center(child: Text('Forgot Password Screen - To be implemented')),
    );
  }
}

class PlaceholderMainScaffold extends StatelessWidget {

  const PlaceholderMainScaffold({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale), label: 'POS'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long), label: 'Transactions'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
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

class PlaceholderHomeScreen extends StatelessWidget {
  const PlaceholderHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Home Screen - To be implemented')),
    );
  }
}

class PlaceholderPOSScreen extends StatelessWidget {
  const PlaceholderPOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS')),
      body: const Center(child: Text('POS Screen - To be implemented')),
    );
  }
}

class PlaceholderProductsScreen extends StatelessWidget {
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

class PlaceholderProductDetailScreen extends StatelessWidget {

  const PlaceholderProductDetailScreen({super.key, required this.productId});
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

class PlaceholderProductFormScreen extends StatelessWidget {
  const PlaceholderProductFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product Form')),
      body: const Center(child: Text('Product Form - To be implemented')),
    );
  }
}

class PlaceholderInventoryScreen extends StatelessWidget {
  const PlaceholderInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: const Center(child: Text('Inventory Screen - To be implemented')),
    );
  }
}

class PlaceholderStockAdjustmentScreen extends StatelessWidget {
  const PlaceholderStockAdjustmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Adjustment')),
      body: const Center(child: Text('Stock Adjustment - To be implemented')),
    );
  }
}

class PlaceholderTransactionsScreen extends StatelessWidget {
  const PlaceholderTransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: const Center(child: Text('Transactions List - To be implemented')),
    );
  }
}

class PlaceholderTransactionDetailScreen extends StatelessWidget {

  const PlaceholderTransactionDetailScreen({super.key, required this.transactionId});
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

class PlaceholderCartScreen extends StatelessWidget {
  const PlaceholderCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: const Center(child: Text('Cart Screen - To be implemented')),
    );
  }
}

class PlaceholderCheckoutScreen extends StatelessWidget {
  const PlaceholderCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: const Center(child: Text('Checkout Screen - To be implemented')),
    );
  }
}

class PlaceholderPaymentScreen extends StatelessWidget {
  const PlaceholderPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: const Center(child: Text('Payment Screen - To be implemented')),
    );
  }
}

class PlaceholderReceiptScreen extends StatelessWidget {

  const PlaceholderReceiptScreen({super.key, required this.transactionId});
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

class PlaceholderCustomersScreen extends StatelessWidget {
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

class PlaceholderCustomerDetailScreen extends StatelessWidget {

  const PlaceholderCustomerDetailScreen({super.key, required this.customerId});
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

class PlaceholderCustomerFormScreen extends StatelessWidget {
  const PlaceholderCustomerFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Form')),
      body: const Center(child: Text('Customer Form - To be implemented')),
    );
  }
}

class PlaceholderReportsScreen extends StatelessWidget {
  const PlaceholderReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: const Center(child: Text('Reports Screen - To be implemented')),
    );
  }
}

class PlaceholderSalesReportScreen extends StatelessWidget {
  const PlaceholderSalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales Report')),
      body: const Center(child: Text('Sales Report - To be implemented')),
    );
  }
}

class PlaceholderInventoryReportScreen extends StatelessWidget {
  const PlaceholderInventoryReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Report')),
      body: const Center(child: Text('Inventory Report - To be implemented')),
    );
  }
}

class PlaceholderSettingsScreen extends StatelessWidget {
  const PlaceholderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen - To be implemented')),
    );
  }
}

class PlaceholderBusinessSettingsScreen extends StatelessWidget {
  const PlaceholderBusinessSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Business Info')),
      body: const Center(child: Text('Business Settings - To be implemented')),
    );
  }
}

class PlaceholderPrinterSettingsScreen extends StatelessWidget {
  const PlaceholderPrinterSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Printer Settings')),
      body: const Center(child: Text('Printer Settings - To be implemented')),
    );
  }
}

class PlaceholderLanguageSettingsScreen extends StatelessWidget {
  const PlaceholderLanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language Settings')),
      body: const Center(child: Text('Language Settings - To be implemented')),
    );
  }
}

class PlaceholderAboutScreen extends StatelessWidget {
  const PlaceholderAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About Screen - To be implemented')),
    );
  }
}
