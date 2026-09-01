import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cart_providers.dart';

class CheckoutSummaryTags extends ConsumerWidget {
  const CheckoutSummaryTags({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Map<String, int> groupedSummary = {};

    for (var item in cartItems) {
      groupedSummary[item.product.name] =
          (groupedSummary[item.product.name] ?? 0) + item.quantity;
    }

    if (groupedSummary.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: groupedSummary.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isDark ? const Color(0xFF3C3C3C) : Colors.blueGrey.shade100),
          ),
          child: Text(
            AppLocalizations.of(context).quantityLabel(
              entry.value.toLocalNum(ref),
              entry.key,
            ),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade700,
            ),
          ),
        );
      }).toList(),
    );
  }
}
