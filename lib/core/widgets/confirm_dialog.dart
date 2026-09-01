import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmLabel;
  final VoidCallback onConfirm;
  final IconData icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel,
    required this.onConfirm,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. DANGER ICON
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.red, size: 40),
            ),
            const SizedBox(height: 20),

            // 2. TITLE
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            // 3. MESSAGE
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),

            // 4. ACTION BUTTONS
            Row(
              children: [
                // CANCEL BUTTON
                Expanded(
                  child: TextButton(
                    style:
                        TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          // New way to define ripple color
                          foregroundColor: isDark ? Colors.grey.shade300 : Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
                          ),
                        ).copyWith(
                          // Custom ripple for the white button
                          overlayColor: WidgetStateProperty.all(
                            isDark ? Colors.white.withAlpha(20) : Colors.black.withAlpha(20),
                          ),
                        ),
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // DELETE BUTTON
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                      minimumSize: WidgetStatePropertyAll(const Size(100, 45)),
                      padding: WidgetStatePropertyAll(
                        const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    onPressed: onConfirm,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        confirmLabel ?? AppLocalizations.of(context).confirm,
                        maxLines: 2,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          // Setting a minimum font size helps it not get TOO tiny
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmLabel,
    IconData? icon,

    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      routeSettings: const RouteSettings(name: 'ConfirmDialog'),
      builder: (context) => ConfirmDialog(
        icon: icon ?? Icons.do_not_disturb_on,
        title: title,
        message: message,
        confirmLabel: confirmLabel ?? AppLocalizations.of(context).confirm,

        onConfirm: onConfirm,
      ),
    );
  }
}
