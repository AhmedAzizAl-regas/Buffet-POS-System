import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:buffet_app/features/pos/presentation/providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';

class CartReviewSheet extends ConsumerWidget {
  final Function(CartItem, int) onEdit;
  const CartReviewSheet({super.key, required this.onEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // --- 1. LOGIC TO GROUP ITEMS BY NAME ---
    final Map<String, int> groupedSummary = {};
    for (var item in items) {
      final name = item.product.name;
      groupedSummary[name] = (groupedSummary[name] ?? 0) + item.quantity;
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context).reviewOrder,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 16),

          // --- 2. NEW: SUMMARY TAGS SECTION (READ-ONLY) ---
          if (items.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: groupedSummary.entries.map((entry) {
                return Chip(
                  label: Text(
                    AppLocalizations.of(
                      context,
                    ).quantityLabel(entry.value.toLocalNum(ref), entry.key),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                  backgroundColor: context.primaryColor.withAlpha(20),
                  side: BorderSide(color: context.primaryColor.withAlpha(40)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
            const Divider(height: 32),
          ],

          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  AppLocalizations.of(context).cartIsEmpty,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),

          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              separatorBuilder: (c, i) => Divider(color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    AppLocalizations.of(context).quantityLabel(
                      item.quantity.toLocalNum(ref),
                      item.product.name,
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    item.selectedAddons.isEmpty
                        ? AppLocalizations.of(context).plain
                        : item.selectedAddons
                              .map((e) => e.name)
                              .join(
                                Localizations.localeOf(context).languageCode ==
                                        'ar'
                                    ? "، "
                                    : ", ",
                              ),
                    style: TextStyle(
                      color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400,
                      fontSize: 13,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onEdit(item, index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.do_not_disturb_on_outlined,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          ref.read(cartProvider.notifier).removeItem(index);
                          if (ref.read(cartProvider).isEmpty) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
