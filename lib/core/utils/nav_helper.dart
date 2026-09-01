import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../generated/l10n.dart';

class NavHelper {
  static void showNavMenu(BuildContext context) {
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'NavMenuDialog'),
      builder: (context) {
        final theme = Theme.of(context);

        return Dialog(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withAlpha(30),
                      child: Icon(
                        Icons.apps_rounded,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      AppLocalizations.of(context).quickNavigation,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Navigation Grid
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildNavTile(
                      context,
                      icon: Icons.point_of_sale_rounded,
                      label: AppLocalizations.of(context).posTerminal,
                      route: AppRoutes.pos.path,
                      color: Colors.blue,
                    ),
                    _buildNavTile(
                      context,
                      icon: Icons.inventory_2_rounded,
                      label: AppLocalizations.of(context).catalog,
                      route: AppRoutes.catalog.path,
                      color: Colors.orange,
                    ),
                    _buildNavTile(
                      context,
                      icon: Icons.history_rounded,
                      label: AppLocalizations.of(context).orderHistory,
                      route: AppRoutes.orders.path,
                      color: Colors.green,
                    ),
                    _buildNavTile(
                      context,
                      icon: Icons.settings_rounded,
                      label: AppLocalizations.of(context).settings,
                      route: AppRoutes.settings.path,
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildNavTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required Color color,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close dialog
        context.go(route); // Navigate
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(40), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withAlpha(200),
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Your existing title builder
  static Widget buildNavTitle(BuildContext context, {required Widget title}) {
    final titleStyle = Theme.of(context).appBarTheme.titleTextStyle ??
        const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DefaultTextStyle(
        style: titleStyle,
        child: title,
      ),
    );
  }
}
