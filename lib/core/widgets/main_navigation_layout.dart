import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:buffet_app/generated/l10n.dart';

import 'package:buffet_app/features/suppliers/presentation/screens/suppliers_accounts_popup.dart';

class MainNavigationLayout extends StatefulWidget {
  final Widget child;
  final GoRouterState state;

  const MainNavigationLayout({
    super.key,
    required this.child,
    required this.state,
  });

  @override
  State<MainNavigationLayout> createState() => _MainNavigationLayoutState();
}

class _MainNavigationLayoutState extends State<MainNavigationLayout> {
  // A custom history stack to keep track of visited tab indices
  final List<int> _tabHistory = [];
  
  // Track the current index to identify transitions
  int _currentIndex = 0;
  
  // Flag to know if navigation is triggered by the system back button
  bool _isBackNavigation = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = _getIndexOfLocation(widget.state.matchedLocation);
  }

  @override
  void didUpdateWidget(covariant MainNavigationLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    final newIndex = _getIndexOfLocation(widget.state.matchedLocation);
    if (newIndex != _currentIndex) {
      if (_isBackNavigation) {
        // Change was initiated by pressing the back button, already popped from stack
        _currentIndex = newIndex;
        _isBackNavigation = false;
      } else {
        // User clicked a tab manually. Record the previous tab in history.
        if (_tabHistory.isEmpty || _tabHistory.last != _currentIndex) {
          _tabHistory.add(_currentIndex);
        }
        _currentIndex = newIndex;
      }
    }
  }

  int _getIndexOfLocation(String location) {
    if (location.startsWith('/catalog') || location.startsWith('/import-preview')) {
      return 1;
    } else if (location.startsWith('/order-history')) {
      return 2;
    } else if (location.startsWith('/settings') || location.startsWith('/logs')) {
      return 3;
    }
    return 0; // POS default
  }

  String _getRouteOfIndex(int index) {
    switch (index) {
      case 1:
        return '/catalog';
      case 2:
        return '/order-history';
      case 3:
        return '/settings';
      case 0:
      default:
        return '/pos';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = widget.state.matchedLocation;

    // We only intercept back navigation when we are on a main tab screen.
    // If we are on a deep detail page (e.g., /order-history/123), GoRouter should 
    // handle the pop naturally to return to the parent tab.
    final bool isMainTab = location == '/pos' || location == '/catalog' || location == '/order-history' || location == '/settings';

    // Intercept if on a main tab and we have history to go back to, 
    // or if we are not on the home tab (index 0) so we can go to it as a fallback before exiting.
    final bool canGoBackInHistory = isMainTab && (_tabHistory.isNotEmpty || _currentIndex != 0);
    final bool canPop = !canGoBackInHistory;

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final primaryColor = theme.colorScheme.primary;

    final bool isDark = theme.brightness == Brightness.dark;

    // Hide navigation bar on screens where it's not appropriate (e.g. onboarding, splash, loading)
    final bool shouldHideNav = location == '/loading' || location == '/onboarding';

    if (shouldHideNav) {
      return widget.child;
    }

    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final double fontSize = isArabic ? 12.0 : 11.0;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (canGoBackInHistory) {
          if (_tabHistory.isNotEmpty) {
            // Retrieve and navigate to the last visited tab
            final previousTab = _tabHistory.removeLast();
            setState(() {
              _isBackNavigation = true;
              _currentIndex = previousTab;
            });
            context.go(_getRouteOfIndex(previousTab));
          } else if (_currentIndex != 0) {
            // Fallback: Go back to the main POS screen (index 0)
            setState(() {
              _isBackNavigation = true;
              _currentIndex = 0;
            });
            context.go(_getRouteOfIndex(0));
          }
        }
      },
      child: Material(
        color: theme.scaffoldBackgroundColor,
        child: Column(
          children: [
            Expanded(
              child: widget.child,
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                    width: 1.0,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.04),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                  child: Row(
                    children: [
                      _buildNavItem(
                        context: context,
                        index: 0,
                        currentIndex: _currentIndex,
                        icon: Icons.point_of_sale_outlined,
                        activeIcon: Icons.point_of_sale_rounded,
                        label: l10n.posTerminal,
                        route: AppRoutes.pos.path,
                        primaryColor: primaryColor,
                        fontSize: fontSize,
                      ),
                      _buildNavItem(
                        context: context,
                        index: 1,
                        currentIndex: _currentIndex,
                        icon: Icons.inventory_2_outlined,
                        activeIcon: Icons.inventory_2_rounded,
                        label: l10n.catalog,
                        route: AppRoutes.catalog.path,
                        primaryColor: primaryColor,
                        fontSize: fontSize,
                      ),
                      // Middle button: Suppliers & Accounts (Quick actions FAB style)
                      _buildMiddleNavItem(
                        context: context,
                        primaryColor: primaryColor,
                      ),
                      _buildNavItem(
                        context: context,
                        index: 2,
                        currentIndex: _currentIndex,
                        icon: Icons.receipt_long_outlined,
                        activeIcon: Icons.receipt_long_rounded,
                        label: l10n.orderHistory,
                        route: AppRoutes.orders.path,
                        primaryColor: primaryColor,
                        fontSize: fontSize,
                      ),
                      _buildNavItem(
                        context: context,
                        index: 3,
                        currentIndex: _currentIndex,
                        icon: Icons.settings_outlined,
                        activeIcon: Icons.settings_rounded,
                        label: l10n.settings,
                        route: AppRoutes.settings.path,
                        primaryColor: primaryColor,
                        fontSize: fontSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required String route,
    required Color primaryColor,
    required double fontSize,
  }) {
    final isSelected = index == currentIndex;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (!isSelected) {
            context.go(route);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected ? primaryColor.withOpacity(isDark ? 0.15 : 0.08) : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 150),
                child: Icon(
                  isSelected ? activeIcon : icon,
                  color: isSelected ? primaryColor : (isDark ? Colors.grey.shade400 : Colors.grey.shade500),
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? primaryColor : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiddleNavItem({
    required BuildContext context,
    required Color primaryColor,
  }) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          showSuppliersAccountsPopup(context);
        },
        child: Center(
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
