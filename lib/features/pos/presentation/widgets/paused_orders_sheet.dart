import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:buffet_app/features/pos/presentation/providers/cart_providers.dart';
import 'package:buffet_app/features/pos/presentation/providers/pending_orders_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/paused_order.dart';

class PausedOrdersSheet extends ConsumerWidget {
  const PausedOrdersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingMap = ref.watch(pendingOrdersProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle for the bottom sheet
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            AppLocalizations.of(context).pausedOrders,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),

          if (pendingMap.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                AppLocalizations.of(context).noPausedOrders,
                style: TextStyle(color: Colors.grey),
              ),
            ),

          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: pendingMap.length,
              separatorBuilder: (c, i) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                String label = pendingMap.keys.elementAt(index);
                final pausedOrder = pendingMap[label]!;
                List<CartItem> items = pausedOrder.items;
                double orderTotal = items.fold(
                  0,
                  (sum, item) => sum + item.totalRowPrice,
                );

                return Card(
                  clipBehavior: Clip.antiAlias,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: CircleAvatar(
                        backgroundColor: context.primaryColor.withAlpha(30),
                        child: Text(
                          items.length.toLocalNum(ref),
                          style: TextStyle(
                            color: context.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        label.isEmpty
                            ? AppLocalizations.of(context).orderIndex(index + 1)
                            : label,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Row(
                        children: [
                          // Total Price in Green
                          Text(
                            AppLocalizations.of(
                              context,
                            ).itemCount(items.length),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 13,
                            ),
                          ),
                          // A small separator dot or dash
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "•",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),

                          orderTotal.toPriceWidget(
                            ref,
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          // Item Counter
                        ],
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ), // Visual hint it expands
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          color: Colors.grey.shade50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // --- PRODUCT LIST ---
                              ...items.map(
                                (item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            ).quantityLabel(
                                              item.quantity.toLocalNum(ref),
                                              item.product.name,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),

                                          item.totalRowPrice.toPriceWidget(
                                            ref,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // --- ADD-ONS SECTION ---
                                      if (item.selectedAddons.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 2,
                                            left: 4,
                                          ),
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            ).addonPrefix(
                                              item.selectedAddons
                                                  .map((e) => e.name)
                                                  .join(
                                                    Localizations.localeOf(
                                                              context,
                                                            ).languageCode ==
                                                            'ar'
                                                        ? "، "
                                                        : ", ",
                                                  ),
                                            ),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: context.primaryColor,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),

                              // --- ACTION BUTTONS ---
                              const Divider(height: 24),
                              Row(
                                children: [
                                  // THE DELETE BUTTON (Returned to full size)
                                  Expanded(
                                    flex: 1,
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.red,
                                        side: const BorderSide(
                                          color: Colors.red,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        // You could add a ConfirmDialog here if you want to be safe
                                        ref
                                            .read(
                                              pendingOrdersProvider.notifier,
                                            )
                                            .deletePending(label);
                                        Toaster.show(
                                          AppLocalizations.of(
                                            context,
                                          ).orderDeleted,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                      ),
                                      label: Text(
                                        AppLocalizations.of(context).delete,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // THE RESUME BUTTON
                                  Expanded(
                                    flex: 2,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        _handleOrderResume(
                                          ref,
                                          context,
                                          label,
                                          pausedOrder,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow_rounded,
                                      ),
                                      label: Text(
                                        AppLocalizations.of(
                                          context,
                                        ).resumeOrder,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleOrderResume(
    WidgetRef ref,
    BuildContext context,
    String label,
    PausedOrder pausedOrder,
  ) {
    final cartNotifier = ref.read(cartProvider.notifier);
    final pendingNotifier = ref.read(pendingOrdersProvider.notifier);
    final currentActiveItems = ref.read(cartProvider);

    // 1. Check if user modified the current cart (compared to its original state)
    // Since we don't track the original state of the ACTIVE cart easily,
    // a simple check: is it empty?
    if (currentActiveItems.isNotEmpty) {
      // If you want to be extra safe, you can show a "Swap" confirm dialog here
      pendingNotifier.pauseOrder(
        AppLocalizations.of(context).swappedMins,
        List.from(currentActiveItems),
      );
    }

    // 2. Load and Delete
    cartNotifier.loadExistingOrder(pausedOrder.items);
    pendingNotifier.deletePending(label);

    Navigator.pop(context);
    Toaster.show(AppLocalizations.of(context).orderLoaded);
  }
}
