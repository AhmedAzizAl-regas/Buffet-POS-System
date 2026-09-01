import 'package:buffet_app/core/database/database_service.dart';
import 'package:buffet_app/core/providers/config_provider.dart';
import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/core/utils/nav_helper.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/widgets/confirm_dialog.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_empty_widget.dart';
import 'package:buffet_app/features/order/data/repositories/order_repository.dart';
import 'package:buffet_app/features/order/presentation/providers/order_providers.dart';
import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:buffet_app/features/pos/presentation/providers/pending_orders_provider.dart';
import 'package:buffet_app/features/pos/presentation/widgets/bottom_summary_bar.dart';
import 'package:buffet_app/features/pos/presentation/widgets/cart_review_sheet.dart';
import 'package:buffet_app/features/pos/presentation/widgets/customization_sheet.dart';
import 'package:buffet_app/features/pos/presentation/widgets/paused_orders_sheet.dart';
import 'package:buffet_app/features/pos/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../catalog/domain/entities/product_entity.dart';
import '../../../catalog/presentation/providers/catalog_providers.dart';
import '../../../catalog/presentation/widgets/catalog_tile.dart';
import '../providers/cart_providers.dart';
import '../widgets/checkout/checkout_item_list.dart';
import '../widgets/checkout/checkout_summary_tags.dart';
import '../widgets/checkout/checkout_total_card.dart';

class POSScreen extends ConsumerStatefulWidget {
  const POSScreen({super.key});

  @override
  ConsumerState<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends ConsumerState<POSScreen> {
  final TextEditingController _searchController = TextEditingController();
  @override
  void dispose() {
    _searchController.dispose(); // Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartProvider.notifier).cartTotal;
    final totalCount = ref.watch(cartProvider.notifier).totalItemsCount;
    final editingId = ref.watch(editingOrderIdProvider);
    final isSearchVisible = ref.watch(isSearchVisibleProvider);
    final configs = ref.watch(configProvider);
    final editingCustomerName = ref.watch(editingOrderMetadataProvider)?.name;
    final isGrid = ref.watch(isGridLayoutProvider);
    final AppBarThemeData appBarTheme = Theme.of(context).appBarTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (configs.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final filteredProducts = ref.watch(filteredProductsProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: NavHelper.buildNavTitle(
          context,
          title: Text(AppLocalizations.of(context).posTerminal),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearchVisible ? Icons.search_off_rounded : Icons.search_rounded,
              color: isSearchVisible
                  ? context.primaryColor
                  : appBarTheme.foregroundColor,
            ),
            onPressed: () {
              final wasVisible = ref.read(isSearchVisibleProvider);
              ref.read(isSearchVisibleProvider.notifier).state = !wasVisible;

              // Clear search text when closing
              if (wasVisible) {
                ref.read(productSearchProvider.notifier).state = "";
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: cartItems.isEmpty ? Colors.grey.shade300 : Colors.red,
            ),
            onPressed: cartItems.isEmpty
                ? null
                : () => _confirmClearCart(context, ref),
          ),

          // 3. POPUP MENU (For "Paused" and "Pending" actions)
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),

            onSelected: (value) {
              if (value == 'pending') {
                _showPendingOrdersSheet(context, ref);
              } else if (value == 'pause') {
                _showPauseDialog(context, ref);

              } else if (value == 'search') {
                final wasVisible = ref.read(isSearchVisibleProvider);
                ref.read(isSearchVisibleProvider.notifier).state = !wasVisible;

                // Clear search text when closing
                if (wasVisible) {
                  ref.read(productSearchProvider.notifier).state = "";
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'pause',
                child: Row(
                  children: [
                    Icon(
                      Icons.pause_circle_outline_rounded,
                      color: context.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).pauseOrder),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'pending',
                child: Row(
                  children: [
                    const Icon(Icons.history_toggle_off_rounded, size: 20),
                    const SizedBox(width: 12),
                    Text(AppLocalizations.of(context).pausedOrders),
                  ],
                ),
              ),

              const PopupMenuDivider(),

              PopupMenuItem(
                value: 'search',
                child: Row(
                  children: [
                    Icon(
                      isSearchVisible
                          ? Icons.search_off_rounded
                          : Icons.search_rounded,
                      color: isSearchVisible
                          ? context.primaryColor
                          : appBarTheme.foregroundColor,
                    ),

                    const SizedBox(width: 12),
                    Text(
                      isSearchVisible
                          ? AppLocalizations.of(context).hideSearch
                          : AppLocalizations.of(context).search,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // --- SEARCH BAR ---
          if (isSearchVisible)
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(
                      0,
                      (1 - value) * -10,
                    ), // Slides down slightly
                    child: child,
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true, // Automatically focus when toggled open
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  onChanged: (value) =>
                      ref.read(productSearchProvider.notifier).state = value,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context).searchProducts,
                    hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
                    prefixIcon: Icon(Icons.search, color: context.primaryColor),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        size: 20,
                        color: isDark ? Colors.grey.shade400 : Colors.black54,
                      ),
                      onPressed: () {
                        if (_searchController.text.isEmpty) {
                          ref.read(isSearchVisibleProvider.notifier).state =
                              false;
                        } else {
                          ref.read(productSearchProvider.notifier).state = "";
                          _searchController.clear();
                        }

                        // Logic to hide if empty (from your current code)
                      },
                    ),
                    filled: true,
                    fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
            ),

          if (editingId != null)
            Container(
              color: context.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.edit_document,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    AppLocalizations.of(context).editingOrder(
                      (editingCustomerName != null &&
                              editingCustomerName.isNotEmpty)
                          ? editingCustomerName
                          : editingId.toString(),
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(editingOrderIdProvider);
                      ref.invalidate(
                        editingOrderMetadataProvider,
                      ); // Clean slate
                      ref.read(cartProvider.notifier).clearCart();
                      Toaster.show(AppLocalizations.of(context).editCancelled);
                    },
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // --- CATEGORY SELECTOR (MATCHING CATALOG UI) ---
          // --- CATEGORY STRIP (MATCHING CATALOG EXACTLY) ---
          _buildCategorySelector(ref),
          // --- PRODUCT GRID (WITH FADE-IN ANIMATION) ---
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              key: ValueKey(
                'pos_body_${ref.watch(selectedCategoryIdProvider)}_${ref.watch(posLayoutProvider)}',
              ),
              child: filteredProducts.when(
                // We combine CategoryID and LayoutMode in the key to trigger animations for BOTH
                data: (products) {
                  if (products.isEmpty) {
                    return CatalogEmptyState(
                      key: const ValueKey('pos_empty'),
                      title: AppLocalizations.of(context).noProducts,
                      onActionTap: () => context.go('/catalog'),
                      actionText: AppLocalizations.of(
                        context,
                      ).addNewProductsNow,
                      icon: Icons.inventory_2_outlined,
                    );
                  }

                  return isGrid
                      ? GridView.builder(
                          key: const ValueKey('pos_grid_view'),

                          padding: const EdgeInsets.all(16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 1.0,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 14,
                              ),
                          itemCount: products.length,
                          itemBuilder: (context, index) => ProductCard(
                            product: products[index],
                            onTap: () {
                              if (products[index].quantity <= 0) {
                                Toaster.show(
                                  Localizations.localeOf(context).languageCode == 'ar'
                                      ? 'نفذت الكمية، اطلبها من المورد من جديد'
                                      : 'Out of stock, order it from the supplier again',
                                  isError: true,
                                );
                              } else {
                                _showCustomization(context, ref, products[index]);
                                ref.read(isSearchVisibleProvider.notifier).state =
                                    false;
                              }
                            },
                          ),
                        )
                      : ListView.builder(
                          key: const ValueKey('pos_list_view'),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final p = products[index];
                            return CatalogTile(
                              name: p.name,
                              basePrice: p.basePrice,
                              subName:
                                  p.category?.name ??
                                  AppLocalizations.of(context).uncategorized,
                              isProduct: true,
                              icon: Icons.fastfood_rounded,
                              onTap: () {
                                if (p.quantity <= 0) {
                                  Toaster.show(
                                    Localizations.localeOf(context).languageCode == 'ar'
                                        ? 'نفذت الكمية، اطلبها من المورد من جديد'
                                        : 'Out of stock, order it from the supplier again',
                                    isError: true,
                                  );
                                } else {
                                  _showCustomization(context, ref, p);
                                  ref
                                          .read(isSearchVisibleProvider.notifier)
                                          .state =
                                      false;
                                }
                              },
                              isSelected: false,
                              onLongPress: () {},
                            );
                          },
                        );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ),
          ),

          BottomSummaryBar(
            total: total,
            count: totalCount,
            onShowCart: () => _showCartSheet(context, ref),
            onCheckout: () => _showCheckoutSheet(context, ref),
          ),
        ],
      ),
    );
  }

  // --- MODALS ---
  // ignore: unused_element
  Widget _buildCategorySelector(WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryNotifierProvider);
    final selectedCatId = ref.watch(selectedCategoryIdProvider);

    return categoriesAsync.when(
      data: (categories) => Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1, // +1 for "All"
          itemBuilder: (context, index) {
            final isAll = index == 0;
            final category = isAll ? null : categories[index - 1];
            final isSelected = isAll
                ? selectedCatId == null
                : selectedCatId == category?.id;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                // The label text
                label: Text(
                  isAll ? AppLocalizations.of(context).all : category!.name,
                ),
                selected: isSelected,

                // This triggers the built-in animation and the check icon
                onSelected: (_) {
                  ref.read(selectedCategoryIdProvider.notifier).state = isAll
                      ? null
                      : category?.id;
                },
              ),
            );
          },
        ),
      ),
      loading: () => const SizedBox(height: 60),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  void _showCustomization(
    BuildContext context,
    WidgetRef ref,
    ProductEntity product, {
    CartItem? existingItem,
    int? index,
  }) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'CustomizationSheet'),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => CustomizationSheet(
        product: product,
        existingItem: existingItem,
        itemIndex: index,
      ),
    );
  }

  void _showCartSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'CartReviewSheet'),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => CartReviewSheet(
        onEdit: (item, index) => _showCustomization(
          context,
          ref,
          item.product,
          existingItem: item,
          index: index,
        ),
      ),
    );
  }

  // --- LOGIC ---

  void _confirmClearCart(BuildContext context, WidgetRef ref) {
    ConfirmDialog.show(
      context: context,
      title: AppLocalizations.of(context).clearOrder,
      message: AppLocalizations.of(context).removeAllItemsFromTheCart,
      confirmLabel: AppLocalizations.of(context).clear,
      onConfirm: () {
        ref.read(cartProvider.notifier).clearCart();
        Navigator.of(context, rootNavigator: true).pop();
      },
    );
  }

  Future<void> _handleCheckout(
    BuildContext context,
    WidgetRef ref, {
    String? customerName,
    String? notes,
    int status = 0,
  }) async {
    final cartItems = ref.read(cartProvider);

    // 1. Basic Validation
    if (cartItems.isEmpty) {
      Toaster.show(AppLocalizations.of(context).cartIsEmpty, isError: true);
      return;
    }

    try {
      final cartNotifier = ref.read(cartProvider.notifier);
      final dbService = ref.read(databaseServiceProvider);
      final orderRepo = OrderRepository(dbService);

      // 2. Check if we are currently in "Edit Mode"
      final int? editId = ref.read(editingOrderIdProvider);

      int finalOrderId;

      if (editId != null) {
        // --- MODE: UPDATE EXISTING ---
        await orderRepo.updateExistingOrder(
          orderId: editId,
          totalPrice: cartNotifier.cartTotal,
          customerName: customerName,
          notes: notes,
          cartItems: cartItems,
          status: status,
        );
        finalOrderId = editId;

        // Reset the editing state back to null
        ref.read(editingOrderIdProvider.notifier).state = null;
      } else {
        // --- MODE: NEW SALE ---
        finalOrderId = await orderRepo.saveCompleteOrder(
          totalPrice: cartNotifier.cartTotal,
          customerName: customerName,
          cartItems: cartItems,
          notes: notes,
          status: status,
        );
      }

      // Post-Success Cleanup
      ref.read(cartProvider.notifier).clearCart();
      ref.invalidate(orderListProvider);
      ref.invalidate(orderDetailsProvider(finalOrderId));
      ref.invalidate(productNotifierProvider); // Refresh stock counts in POS
      ref.invalidate(addonNotifierProvider);   // Refresh addon stock counts
      ref.read(editingOrderIdProvider.notifier).state = null;
      ref.read(editingOrderMetadataProvider.notifier).state = null;

      if (!context.mounted) return;

      Toaster.show(
        editId != null
            ? AppLocalizations.of(context).orderUpdatedSuccessfully(
                (customerName != null && customerName.isNotEmpty)
                    ? customerName
                    : finalOrderId.toString(),
              )
            : AppLocalizations.of(context).orderSaved(
                (customerName != null && customerName.isNotEmpty)
                    ? customerName
                    : finalOrderId.toString(),
              ),
      );
    } catch (e) {
      debugPrint(AppLocalizations.of(context).checkoutError(e.toString()));
      Toaster.show(
        AppLocalizations.of(context).failedToSaveOrder,
        isError: true,
      );
    }
  }

  void _showPauseDialog(BuildContext context, WidgetRef ref) {
    if (ref.read(editingOrderIdProvider) != null) {
      Toaster.show(
        AppLocalizations.of(context).cannotPauseWhileEditing,
        isError: true,
      );
      return;
    }

    final controller = TextEditingController();
    showDialog(
      context: context,
      routeSettings: const RouteSettings(name: 'PauseOrderDialog'),
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).pauseOrder),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).customerName,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(pendingOrdersProvider.notifier)
                  .pauseOrder(controller.text.trim(), ref.read(cartProvider));
              ref.read(cartProvider.notifier).clearCart();
              Navigator.pop(context);
              Toaster.show(AppLocalizations.of(context).orderPaused);
            },
            child: Text(AppLocalizations.of(context).confirm),
          ),
        ],
      ),
    );
  }

  void _showPendingOrdersSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'PausedOrdersSheet'),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => PausedOrdersSheet(),
    );
  }

  void _showCheckoutSheet(BuildContext context, WidgetRef ref) {
    final editMeta = ref.read(editingOrderMetadataProvider);
    final nameController = TextEditingController(text: editMeta?.name);
    final notesController = TextEditingController(text: editMeta?.notes);
    bool isCompleted = true; // Checked by default!

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'CheckoutSheet'),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHandle(context),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context).checkoutSummary,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 16),

                const CheckoutSummaryTags(), // Modular Tag Cloud
                const SizedBox(height: 16),

                const CheckoutItemList(), // Modular Scrollable List
                const SizedBox(height: 24),

                const CheckoutTotalCard(), // Modular Total Display
                const SizedBox(height: 24),

                _buildCustomerForm(
                  context,
                  nameController,
                  notesController,
                  isCompleted,
                  (val) => setSheetState(() => isCompleted = val ?? false),
                ),
                const SizedBox(height: 32),

                _buildConfirmButton(
                  context,
                  ref,
                  nameController,
                  notesController,
                  isCompleted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(
    BuildContext context,
    WidgetRef ref,
    TextEditingController nameController,
    TextEditingController notesController,
    bool isCompleted,
  ) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          final name = nameController.text.trim();
          final notes = notesController.text.trim();

          // 1. Close the BottomSheet first
          Navigator.pop(context);

          // 2. Trigger the actual save logic
          _handleCheckout(
            context,
            ref,
            customerName: name,
            notes: notes,
            status: isCompleted ? 1 : 0,
          );
        },
        child: Text(
          AppLocalizations.of(context).confirmOrder,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCustomerForm(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController notesController,
    bool isCompleted,
    void Function(bool?) onCompletedChanged,
  ) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Localizations.localeOf(context).languageCode;
    final checkboxLabel = locale == 'ar' ? 'تحديد كمكتمل' : 'Mark as Completed';

    final labelStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: isDark ? Colors.blueGrey.shade300 : Colors.blueGrey,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.customerInfo,
          style: labelStyle,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: nameController,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: l10n.enterCustomerName,
            hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
            prefixIcon: Icon(Icons.person_outline, color: context.primaryColor),
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: notesController,
          maxLines: 2,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: l10n.addOrderNotes,
            hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
            prefixIcon: Icon(
              Icons.sticky_note_2_outlined,
              color: context.primaryColor,
            ),
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: isDark ? const Color(0xFF3C3C3C) : Colors.grey.shade200),
            ),
          ),
        ),
        const SizedBox(height: 12),
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          activeColor: Colors.orange,
          checkColor: Colors.white,
          title: Text(
            checkboxLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          value: isCompleted,
          onChanged: onCompletedChanged,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }
}
