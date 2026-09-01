import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/features/catalog/presentation/screens/catalog_screen.dart';
import 'package:buffet_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:buffet_app/features/order/presentation/screens/order_details_screen.dart';
import 'package:buffet_app/features/order/presentation/screens/order_history_screen.dart';
import 'package:buffet_app/features/pos/presentation/screens/pos_screen.dart';
import 'package:buffet_app/features/settings/presentation/screens/settings_screen.dart';
import 'package:buffet_app/features/settings/presentation/screens/log_viewer_screen.dart';
import 'package:buffet_app/features/catalog/presentation/screens/import_preview_screen.dart';
import 'package:buffet_app/features/onboarding/presentation/screens/splash_screen.dart';
import 'package:buffet_app/features/auth/presentation/screens/language_gateway_screen.dart';
import 'package:buffet_app/features/auth/presentation/screens/login_screen.dart';
import 'package:buffet_app/features/auth/presentation/screens/register_screen.dart';
import 'package:buffet_app/features/suppliers/presentation/screens/suppliers_accounts_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/widgets/main_navigation_layout.dart';

/// 1. The ToasterWrapper ensures that Toaster.init(context) is called
/// within a context that HAS a Navigator/Overlay.
class ToasterWrapper extends StatelessWidget {
  final Widget child;
  const ToasterWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Initializing here handles all screens inside the ShellRoute globally.
    Toaster.init(context);
    return child;
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final isLoaded = ref.watch(configLoadedProvider);
  // Only watch the 'onboarding_done' key specifically.
  // This prevents the router from rebuilding when other settings (like currency, language, etc.) change.
  // final onboardingDone = ref.watch(
  //   configProvider.select((c) => c['onboarding_done'] == 'true'),
  // );

  // LOGGING: Track when the router is deciding
  // AppLogger.debug(
  //   "Router: Deciding initial route. Config Loaded: $isLoaded, Onboarding Done: $onboardingDone",
  // );

  String initialLoc;
  // if (!isLoaded) {
  initialLoc = '/loading';
  // } else {
  //   // initialLoc = '/loading';
  //   initialLoc = onboardingDone
  //       ? AppRoutes.startedRoute.path
  //       : AppRoutes.onboarding.path;
  // }

  AppLogger.info("Router: Setting initial location to $initialLoc");

  return GoRouter(
    observers: [NavObserver()],
    initialLocation: initialLoc,
    routes: [
      // --- Loading/Splash Route ---
      GoRoute(
        path: '/loading',
        builder: (context, state) => const SplashScreen(),
      ),
      // --- Onboarding Route (outside ShellRoute so no nav wrapper) ---
      GoRoute(
        path: AppRoutes.onboarding.path,
        name: AppRoutes.onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
      ),
      // --- Language Selection Gateway Route ---
      GoRoute(
        path: AppRoutes.languageGateway.path,
        name: AppRoutes.languageGateway.name,
        builder: (context, state) => const LanguageGatewayScreen(),
      ),
      // --- Login Route ---
      GoRoute(
        path: AppRoutes.login.path,
        name: AppRoutes.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      // --- Register Route ---
      GoRoute(
        path: AppRoutes.register.path,
        name: AppRoutes.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),

      /// 2. The ShellRoute wraps all internal screens.
      /// This is the "Secret Sauce" to fix the Overlay null error.
      ShellRoute(
        builder: (context, state, child) {
          return ToasterWrapper(
            child: MainNavigationLayout(
              state: state,
              child: child,
            ),
          );
        },
        routes: [
          // --- Catalog Route ---
          GoRoute(
            path: AppRoutes.catalog.path,
            name: AppRoutes.catalog.name,
            builder: (context, state) => const CatalogScreen(),
          ),

          // --- Settings Route ---
          GoRoute(
            path: AppRoutes.settings.path,
            name: AppRoutes.settings.name,
            builder: (context, state) => const SettingsScreen(),
          ),

          // --- POS Route ---
          GoRoute(
            path: AppRoutes.pos.path,
            name: AppRoutes.pos.name,
            builder: (context, state) => const POSScreen(),
          ),

          // --- Suppliers Screen Route ---
          GoRoute(
            path: AppRoutes.suppliers.path,
            name: AppRoutes.suppliers.name,
            builder: (context, state) => const SuppliersScreen(),
          ),

          // --- Accounts Screen Route ---
          GoRoute(
            path: AppRoutes.accounts.path,
            name: AppRoutes.accounts.name,
            builder: (context, state) => const AccountsScreen(),
          ),

          // --- Log Viewer Route ---
          GoRoute(
            path: AppRoutes.logViewer.path,
            name: AppRoutes.logViewer.name,
            builder: (context, state) => const LogViewerScreen(),
          ),

          // --- Import Preview Route ---
          GoRoute(
            path: AppRoutes.importPreview.path,
            name: AppRoutes.importPreview.name,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              return ImportPreviewScreen(
                incomingItems: extra['incomingItems'],
                existingItems: extra['existingItems'],
                activeIndex: extra['activeIndex'],
              );
            },
          ),

          // --- Order History & Details Routes ---
          GoRoute(
            path: AppRoutes.orders.path,
            name: AppRoutes.orders.name,
            builder: (context, state) => const OrderHistoryScreen(),
            routes: [
              GoRoute(
                path: AppRoutes.orderDetails.path,
                name: AppRoutes.orderDetails.name,
                builder: (context, state) {
                  final id = int.parse(state.pathParameters['id']!);
                  final extra = state.extra as Map<String, dynamic>? ?? {};

                  AppLogger.debug("Viewing Order ID: $id");

                  final createdAtRaw = extra['created_at'];
                  final DateTime createdAt = createdAtRaw != null
                      ? (createdAtRaw is DateTime
                            ? createdAtRaw
                            : DateTime.parse(createdAtRaw.toString()))
                      : DateTime.now();

                  return OrderDetailsScreen(
                    orderId: id,
                    totalPrice:
                        (extra['total_price'] as num?)?.toDouble() ?? 0.0,
                    customerName: extra['customer_name'] ?? '',
                    notes: extra['notes'],
                    status: extra['status'] ?? 0,
                    createdAt: createdAt,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// A simple observer to log navigation events
class NavObserver extends NavigatorObserver {
  String _getRouteName(Route<dynamic> route) {
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return route.runtimeType.toString();
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info("NAV PUSH: ${_getRouteName(route)}");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppLogger.info("NAV POP: ${_getRouteName(route)}");
  }
}
