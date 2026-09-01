import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:flutter/material.dart';

class CatalogEmptyState extends StatelessWidget {
  final String title;
  final String actionText;
  final IconData icon;
  final VoidCallback onActionTap;

  const CatalogEmptyState({
    super.key,
    required this.title,
    required this.actionText,
    required this.icon,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey.shade200),
            const SizedBox(height: 24),
            Text.rich(
              TextSpan(
                text: "$title, ",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment
                        .middle, // Better alignment for text
                    child: InkWell(
                      onTap: onActionTap,
                      // 1. Adds the rounded corners to the splash
                      borderRadius: BorderRadius.circular(8),
                      // 2. Optional: Custom splash color to match your theme
                      // splashColor: Theme.of(context).colorScheme.primary,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        child: Text(
                          actionText,
                          style: TextStyle(
                            color: context.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
