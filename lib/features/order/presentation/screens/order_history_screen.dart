import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/core/utils/nav_helper.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/utils/print_helper.dart';
import 'package:buffet_app/core/widgets/confirm_dialog.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/database/database_service.dart';
import '../../data/repositories/order_repository.dart';
import '../providers/order_providers.dart';

// ... existing imports ...

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderListProvider);
    final selectedIds = ref.watch(selectedOrdersProvider);
    final bool isSelectionMode = selectedIds.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: !isSelectionMode,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (isSelectionMode) {
          ref.read(selectedOrdersProvider.notifier).state = {};
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: isSelectionMode
              ? InkWell(
                  onTap: () {
                    // Get all orders currently in the list
                    final allOrders = ordersAsync.value ?? [];
                    final currentSelected = ref.read(selectedOrdersProvider);

                    if (currentSelected.length == allOrders.length) {
                      // If all are already selected, clear selection
                      ref.read(selectedOrdersProvider.notifier).state = {};
                    } else {
                      // Otherwise, select all IDs
                      ref.read(selectedOrdersProvider.notifier).state = allOrders
                          .map((o) => o['id'] as int)
                          .toSet();
                    }
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(context).selectedCount(selectedIds.length),
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.select_all_rounded,
                          size: 18,
                          color: Colors.orange,
                        ),
                      ],
                    ),
                  ),
                )
              : NavHelper.buildNavTitle(
                  context,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: Localizations.localeOf(context).languageCode == 'ar'
                        ? [
                            Text(AppLocalizations.of(context).orderHistory),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.print_outlined, color: Colors.orange),
                              tooltip: 'طباعة الكل',
                              onPressed: ordersAsync.value == null
                                  ? null
                                  : () {
                                      PrintHelper.printAllOrders(
                                        context: context,
                                        ref: ref,
                                        orders: ordersAsync.value!,
                                      );
                                    },
                            ),
                          ]
                        : [
                            IconButton(
                              icon: const Icon(Icons.print_outlined, color: Colors.orange),
                              tooltip: 'Print All',
                              onPressed: ordersAsync.value == null
                                  ? null
                                  : () {
                                      PrintHelper.printAllOrders(
                                        context: context,
                                        ref: ref,
                                        orders: ordersAsync.value!,
                                      );
                                    },
                            ),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).orderHistory),
                          ],
                  ),
                ),
          leading: isSelectionMode
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.orange),
                  onPressed: () => ref.read(selectedOrdersProvider.notifier).state = {},
                )
              : null,
          actions: [
            if (isSelectionMode)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red, size: 28),
                onPressed: () => _confirmBulkDelete(context, ref, selectedIds.toList()),
              ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            // This does the exact same thing as your IconButton
            ref.invalidate(orderListProvider);
            // Optional: wait for the next value to ensure the spinner stays long enough
            await ref.read(orderListProvider.future);
          },
          child: ordersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text(AppLocalizations.of(context).errorOccurred(err.toString())),
            ),
            data: (orders) {
              if (orders.isEmpty) {
                return Center(child: Text(AppLocalizations.of(context).noOrdersFound));
              }

              // ... inside the 'data: (orders)' block of your build method ...

              return ListView.builder(
                itemCount: orders.length,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final int id = order['id'];

                  // 1. NEW: Get status as an integer (default to 0 if null)
                  final int statusInt = order['status'] is int
                      ? order['status']
                      : (int.tryParse(order['status']?.toString() ?? '0') ?? 0);

                  final String? rawName = order['customer_name'];
                  final String displayTitle = (rawName == null || rawName.trim().isEmpty)
                      ? AppLocalizations.of(context).orderId(id)
                      : rawName;

                  final bool isSelected = selectedIds.contains(id);
                  final DateTime dt = DateTime.parse(order['created_at']);

                  final String dateStr = dt.toLocalDateTime(ref);
                  // final String dateStr = DateFormat(
                  //   'd MMM HH:mm',
                  //   Localizations.localeOf(context).toString(),
                  // ).format(dt);

                  // 2. NEW: UI logic based on 0/1
                  final bool isServed = statusInt == 1;
                  final Color statusThemeColor = isServed ? Colors.blue : Colors.orange;
                  final IconData statusIcon = isServed
                      ? Icons.check_circle_rounded
                      : Icons.timer_outlined;
                  final String statusLabel = isServed
                      ? AppLocalizations.of(context).served
                      : AppLocalizations.of(context).pending;

                  return Card(
                    clipBehavior: Clip.antiAlias,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    color: isSelected
                        ? Colors.orange.withAlpha(isDark ? 80 : 40)
                        : (isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.orange
                            : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade300),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        if (isSelectionMode) {
                          _toggleSelection(ref, id);
                        } else {
                          context.push(
                            '/order-history/$id',
                            extra: {
                              'total_price': (order['total_price'] as num).toDouble(),
                              'customer_name': order['customer_name'] ?? '',
                              'notes': order['notes'],
                              'status': statusInt, // Pass the integer instead of string
                              'created_at': dt, // Pass the integer instead of string
                            },
                          );
                        }
                      },
                      onLongPress: () => _toggleSelection(ref, id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          leading: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: CircleAvatar(
                              radius: 22,
                              backgroundColor: isSelected
                                  ? Colors.orange
                                  : statusThemeColor.withAlpha(30),
                              child: isSelected
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : Icon(statusIcon, color: statusThemeColor, size: 20),
                            ),
                          ),
                          title: Text(
                            displayTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.blueGrey.shade900,
                            ),
                          ),
                           subtitle: Text(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? "$statusLabel • $dateStr"
                                : "$dateStr • $statusLabel",
                            style: TextStyle(
                              color: isServed
                                  ? Colors.blue.shade300
                                  : (isDark ? Colors.grey.shade400 : Colors.blueGrey.shade400),
                              fontSize: 12,
                              fontWeight: isServed ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withAlpha(30),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: (order['total_price'] as num).toPriceWidget(
                              ref,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: Colors.green,
                                fontSize: 15,
                              ),

                              //"${(order['total_price'] as num).toStringAsFixed(2)} ${AppLocalizations.of(context).sar}",
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ... (Keep _toggleSelection and _confirmBulkDelete as they are)

  void _toggleSelection(WidgetRef ref, int id) {
    final current = ref.read(selectedOrdersProvider);
    final notifier = ref.read(selectedOrdersProvider.notifier);

    if (current.contains(id)) {
      notifier.state = {...current}..remove(id);
    } else {
      notifier.state = {...current, id};
    }
  }

  // Update your existing _confirmBulkDelete function
  void _confirmBulkDelete(BuildContext context, WidgetRef ref, List<int> ids) {
    ConfirmDialog.show(
      context: context,
      title: AppLocalizations.of(context).deleteOrdersCount(ids.length),
      message: AppLocalizations.of(context).deleteConfirmMessage,
      confirmLabel: AppLocalizations.of(context).deleteAll,
      // We handle the actual logic and context checks here
      onConfirm: () async {
        final repo = OrderRepository(ref.read(databaseServiceProvider));

        // Close the dialog first (using the main context provided)
        Navigator.pop(context);

        // Perform the bulk delete
        await repo.deleteMultipleOrders(ids);

        // Reset selection state
        ref.read(selectedOrdersProvider.notifier).state = {};

        // Force refresh of the history list
        ref.invalidate(orderListProvider);
        if (!context.mounted) return;
        Toaster.show(AppLocalizations.of(context).deleteOrdersCount(ids.length));
      },
    );
  }
}
