import 'package:flutter/material.dart';

import '../../generated/l10n.dart';

class ErrorDialog {
  static void show(
    BuildContext context, {
    required String message,
    String? title,
    VoidCallback? onConfirm,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      routeSettings: const RouteSettings(name: 'ErrorDialog'),
      builder: (context) {
        final theme = Theme.of(context);

        return AlertDialog(
          // Shape is already handled by Global Theme, but we can ensure it here
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title ?? AppLocalizations.of(context).errorOccur,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 15, height: 1.5),
          ),
          actions: [
            SizedBox(
              width: double.infinity, // Full width button for easier tapping in POS
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red.shade100),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  if (onConfirm != null) onConfirm();
                },
                child: Text(
                  AppLocalizations.of(context).dismiss,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static void showNetworkError(BuildContext context) {
    show(
      context,
      title: "Connection Lost",
      message:
          "We can't reach the server right now. Please check your WiFi or Data connection and try again.",
    );
  }
}
