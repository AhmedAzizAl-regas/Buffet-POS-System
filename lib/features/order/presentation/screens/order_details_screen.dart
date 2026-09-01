import 'package:buffet_app/core/database/database_service.dart';
import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/utils/print_helper.dart';
import 'package:buffet_app/features/order/data/repositories/order_repository.dart';
import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../generated/l10n.dart';
import '../../../pos/presentation/providers/cart_providers.dart';
import '../providers/order_providers.dart';

// Tracks which item name is currently pinned to the top. Null means default order.

class OrderDetailsScreen extends ConsumerWidget {
  final int orderId;
  final double totalPrice;
  final String customerName;
  final String? notes;
  final int status; // 0 = Pending, 1 = Served
  final DateTime createdAt;
  final ScrollController _scrollController = ScrollController();

  OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.totalPrice,
    required this.customerName,
    required this.createdAt,
    this.notes,
    this.status = 0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailsAsync = ref.watch(orderDetailsProvider(orderId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String displayTitle = (customerName.trim().isEmpty)
        ? AppLocalizations.of(context).orderId(orderId)
        : customerName;

    // --- STATUS LOGIC (0 = Pending, 1 = Served) ---
    final bool isServed = status == 1;
    final Color statusThemeColor = isServed ? Colors.blue : Colors.orange;
    final String statusLabel = isServed
        ? AppLocalizations.of(context).served
        : AppLocalizations.of(context).pending;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: isDark ? Colors.white : Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              displayTitle,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 20,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Text(
              createdAt.toLocalDateTime(ref), // <--- Use your extension here
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: Icon(Icons.print_outlined, color: statusThemeColor),
            onPressed: detailsAsync.value == null
                ? null
                : () {
                    PrintHelper.printSingleOrder(
                      context: context,
                      ref: ref,
                      orderId: orderId,
                      totalPrice: totalPrice,
                      customerName: customerName,
                      createdAt: createdAt,
                      status: status,
                      notes: notes,
                      items: detailsAsync.value!,
                    );
                  },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: detailsAsync.when(
        loading: () => Center(child: CircularProgressIndicator(color: statusThemeColor)),
        error: (err, stack) => Center(
          child: Text(AppLocalizations.of(context).errorOccurred(err.toString())),
        ),
        data: (items) {
          // 1. POPULATE GROUPED ITEMS (Fixing the commented-out code)
          final Map<String, int> groupedItems = {};
          for (var item in items) {
            final name = item['name_at_sale'] as String;
            final qty = item['quantity'] as int;
            groupedItems[name] = (groupedItems[name] ?? 0) + qty;
          }

          final int totalItemsCount = items.fold<int>(
            0,
            (sum, item) => sum + (item['quantity'] as int),
          );

          final activeFilter = ref.watch(orderFilterProvider);

          // 2. SORT THE LIST BASED ON ACTIVE FILTER
          final sortedItems = List<Map<String, dynamic>>.from(items);

          if (activeFilter != null) {
            sortedItems.sort((a, b) {
              if (a['name_at_sale'] == activeFilter &&
                  b['name_at_sale'] != activeFilter) {
                return -1; // Move matches to top
              } else if (a['name_at_sale'] != activeFilter &&
                  b['name_at_sale'] == activeFilter) {
                return 1;
              }
              return 0; // Maintain original relative order for others
            });
          }

          return Column(
            children: [
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  children: [
                    if (notes != null && notes!.trim().isNotEmpty)
                      _buildNotesSection(context),

                    _buildStatsHeader(
                      context,
                      totalItemsCount,
                      statusLabel,
                      statusThemeColor,
                    ),

                    // 3. SHOW TAGS (Reorder trigger)
                    if (groupedItems.isNotEmpty)
                      _buildSortingTags(
                        context,
                        ref,
                        groupedItems,
                        activeFilter,
                        statusThemeColor,
                      ),

                    const SizedBox(height: 8),

                    // 4. MAP OVER THE SORTED ITEMS (Crucial fix)
                    ...sortedItems.map(
                      (item) => _buildItemTile(ref, context, item, statusThemeColor),
                    ),

                    const SizedBox(height: 100), // Padding for bottom area
                  ],
                ),
              ),
              _buildBottomActionArea(context, ref, statusThemeColor, isServed),
            ],
          );
        },
      ),
    );
  }

  // --- SUB-WIDGETS ---
  Widget _buildSortingTags(
    BuildContext context,
    WidgetRef ref,
    Map<String, int> grouped,
    String? activeFilter,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // <--- Add this
      children: [
        // --- THE HINT TEXT ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              Icon(Icons.touch_app_outlined, size: 14, color: color.withAlpha(179)),
              const SizedBox(width: 6),
              Text(
                AppLocalizations.of(
                  context,
                ).tapAnItemToPinItToTheTop, // Replace with AppLocalizations
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color.withAlpha(204),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: grouped.entries.map((entry) {
              final bool isSelected = activeFilter == entry.key;

              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text("${entry.value}x ${entry.key}"),
                  selected: isSelected,
                  onSelected: (selected) {
                    // If already selected, clear filter. Otherwise, set it.
                    ref.read(orderFilterProvider.notifier).state = selected
                        ? entry.key
                        : null;
                    if (selected) {
                      Feedback.forTap(context);
                    }
                  },
                  selectedColor: color,
                  backgroundColor: color.withAlpha(21),
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: isSelected ? color : color.withAlpha(40)),
                  showCheckmark: false,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // --- NEW WIDGET: Summary Tags ---
  Widget _buildSummaryTags(
    Map<String, int> grouped,
    List<dynamic> rawItems,
    Color color,
  ) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: grouped.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              backgroundColor: color.withAlpha(20),
              side: BorderSide(color: color.withAlpha(40)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              label: Text(
                "${entry.value}x ${entry.key}",
                style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
              ),
              onPressed: () {
                // Find the first index of this item in the original list
                final index = rawItems.indexWhere(
                  (it) => it['name_at_sale'] == entry.key,
                );
                if (index != -1) {
                  // Approximate height of your tile is ~80-100 pixels
                  // Header/Notes offset is roughly 150 pixels
                  _scrollController.animateTo(
                    (index * 90.0) + 120.0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  // Helper to keep build method clean
  Widget _buildStatsHeader(
    BuildContext context,
    int totalItems,
    String statusLabel,
    Color color,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Row(
        children: [
          _buildStat(
            AppLocalizations.of(context).items,
            "$totalItems",
            isDark ? Colors.white : Colors.black87,
            isDark,
          ),
          Container(width: 1.5, height: 30, color: color.withAlpha(40)),
          _buildStat(
            AppLocalizations.of(context).status,
            statusLabel.toUpperCase(),
            color,
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2C) : Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF3C3C3C) : Colors.blueGrey.withAlpha(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_rounded,
                size: 16,
                color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context).orderNotes,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notes!,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemTile(
    WidgetRef ref,
    BuildContext context,
    Map<String, dynamic> item,
    Color themeColor,
  ) {
    // --- NEW: Check if this specific item matches the active filter ---
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeFilter = ref.watch(orderFilterProvider);
    final bool isHighlighted = activeFilter == item['name_at_sale'];

    final List addons = item['addons'] ?? [];
    double addonsSum = addons.fold(
      0.0,
      (sum, add) => sum + (add['price_at_sale'] as num).toDouble(),
    );
    double rowTotal = (item['price_at_sale'] + addonsSum) * item['quantity'];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      decoration: BoxDecoration(
        // Use opacity instead of shades for a cleaner "flash"
        color: isHighlighted
            ? themeColor.withAlpha(isDark ? 60 : 35)
            : (isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isHighlighted
              ? themeColor.withAlpha(120)
              : (isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200),
          width: isHighlighted ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
              child: Text(
                "${(item['quantity'] as num).toLocalNum(ref)}x",
                style: TextStyle(color: themeColor, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              "${item['name_at_sale']}",
              style: TextStyle(
                fontWeight: isHighlighted ? FontWeight.w900 : FontWeight.bold,
                color: isDark ? Colors.white : (isHighlighted
                    ? Color.lerp(themeColor, Colors.black, 0.3) // 30% darker
                    : Colors.black87),
              ),
            ),
            trailing: rowTotal.toPriceWidget(
              ref,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          if (addons.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(70, 0, 16, 12),
              child: Column(
                children: addons
                    .map(
                      (add) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "• ${add['name_at_sale']}",
                            style: TextStyle(
                              color: isDark ? Colors.grey.shade400 : Colors.blueGrey.shade600,
                              fontSize: 13,
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                "+",
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade500 : Colors.blueGrey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                              (add['price_at_sale'] as num).toPriceWidget(
                                ref,
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade500 : Colors.blueGrey.shade400,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionArea(
    BuildContext context,
    WidgetRef ref,
    Color themeColor,
    bool isServed,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: BoxDecoration(
        color: isDark ? Theme.of(context).scaffoldBackgroundColor : Colors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha(40) : Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          if (!isServed) ...[
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.orange, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).copyWith(elevation: WidgetStateProperty.all(0)),
                    onPressed: () => _handleEditOrder(context, ref),
                    child: const Icon(
                      Icons.edit_note_rounded,
                      color: Colors.orange,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ).copyWith(elevation: WidgetStateProperty.all(0)),
                    onPressed: () {
                      // --- START CONFIRM DIALOG ---
                      ConfirmDialog.show(
                        context: context,
                        title: AppLocalizations.of(context).markAsServed,
                        message: AppLocalizations.of(context).orderServedSuccess(
                          customerName.isNotEmpty ? customerName : orderId.toString(),
                        ),
                        confirmLabel: AppLocalizations.of(context).confirm,
                        icon: Icons.check_circle_outline_rounded, // Better for "Serving"
                        onConfirm: () async {
                          // 1. Close the Dialog
                          Navigator.pop(context);

                          // 2. Perform the update
                          final repo = OrderRepository(ref.read(databaseServiceProvider));
                          await repo.markAsServed(orderId);

                          // 3. Refresh the list
                          ref.invalidate(orderListProvider);

                          if (!context.mounted) return;

                          Toaster.show(
                            AppLocalizations.of(context).orderServedSuccess(
                              customerName.isNotEmpty ? customerName : orderId.toString(),
                            ),
                          );

                          // 4. Go back to previous screen
                          context.pop();
                        },
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context).markAsServed,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (isServed) ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      side: const BorderSide(color: Colors.orange, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).copyWith(elevation: WidgetStateProperty.all(0)),
                    onPressed: () {
                      final title = locale == 'ar' ? 'تعديل حالة الطلب' : 'Change Order Status';
                      final message = locale == 'ar' 
                          ? 'هل أنت متأكد من تغيير حالة الطلب إلى قيد الانتظار؟' 
                          : 'Are you sure you want to change order status to Pending?';
                      final confirmLabel = locale == 'ar' ? 'نعم، تغيير' : 'Yes, Change';

                      ConfirmDialog.show(
                        context: context,
                        title: title,
                        message: message,
                        confirmLabel: confirmLabel,
                        icon: Icons.history_rounded,
                        onConfirm: () async {
                          // 1. Close the dialog
                          Navigator.pop(context);

                          // 2. Perform database update
                          final repo = OrderRepository(ref.read(databaseServiceProvider));
                          await repo.updateOrderStatus(orderId, 0); // 0 = Pending

                          // 3. Refresh providers
                          ref.invalidate(orderListProvider);
                          ref.invalidate(orderDetailsProvider(orderId));

                          if (!context.mounted) return;

                          final toastMsg = locale == 'ar' 
                              ? 'تم إعادة الطلب إلى قيد الانتظار بنجاح' 
                              : 'Order status changed to Pending successfully';
                          Toaster.show(toastMsg);

                          // 4. Go back to previous screen
                          context.pop();
                        },
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          color: Colors.orange,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          locale == 'ar' ? 'إعادة لقيد الانتظار' : 'Change to Pending',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).totalPaid,
                style: TextStyle(
                  color: isDark ? Colors.grey.shade400 : Colors.grey,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: totalPrice.toPriceWidget(
                  ref,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleEditOrder(BuildContext context, WidgetRef ref) async {
    try {
      final repo = OrderRepository(ref.read(databaseServiceProvider));
      final rawData = await repo.getOrderFullDetails(orderId);
      final List<CartItem> itemsToLoad = rawData.map((m) => CartItem.fromMap(m)).toList();

      // 1. Load the items into the cart
      ref.read(cartProvider.notifier).loadExistingOrder(itemsToLoad);

      // 2. Set the editing ID
      ref.read(editingOrderIdProvider.notifier).state = orderId;

      // 3. NEW: Set the metadata so POSScreen doesn't lose the name/notes
      ref.read(editingOrderMetadataProvider.notifier).state = (
        name: customerName,
        notes: notes,
      );

      if (!context.mounted) return;
      context.go('/pos');
      Toaster.show(
        AppLocalizations.of(
          context,
        ).editingOrder((customerName.isNotEmpty) ? customerName : orderId.toString()),
      );
    } catch (e) {
      Toaster.show(AppLocalizations.of(context).errorLoadingOrder);
    }
  }

  Widget _buildStat(String label, String value, Color color, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }
}
