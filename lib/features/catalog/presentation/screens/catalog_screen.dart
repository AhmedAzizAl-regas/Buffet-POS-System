import 'dart:io';
import 'package:intl/intl.dart';

import 'package:buffet_app/core/errors/error_dialog.dart';
import 'package:buffet_app/core/utils/context_extensions.dart';
import 'package:buffet_app/core/utils/file_naming.dart';
import 'package:buffet_app/core/utils/nav_helper.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/widgets/confirm_dialog.dart';
import 'package:buffet_app/features/catalog/data/services/catalog_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/permission_helper.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/add_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/catalog_providers.dart';
import '../widgets/addon_tab.dart';
import '../widgets/category_tab.dart';
import '../widgets/product_tab.dart';
import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';
import 'package:buffet_app/features/suppliers/presentation/providers/supplier_providers.dart';
import 'package:buffet_app/features/suppliers/data/supplier_database_service.dart';
import 'import_preview_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_routes.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen>
    with SingleTickerProviderStateMixin {
  bool _showFab = true; // Add this
  bool _isImporting = false;
  double _importProgress = 0.0;
  late TabController _tabController;
  final Set<int> _selectedProductIds = {};
  final Set<int> _selectedAddonIds = {};
  final Set<int> _selectedCategoryIds = {}; // <--- ADD THIS
  int? selectedCatId; // This holds the ID for the database
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _clearSelection();
      }
    });
  }

  @override
  void dispose() {
    _categoryController.dispose(); // Always dispose controllers
    _tabController.dispose();
    super.dispose();
  }

  void _clearSelection() {
    setState(() {
      _selectedProductIds.clear();
      _selectedAddonIds.clear();
      _selectedCategoryIds.clear(); // <--- ADD THIS
    });
  }

  void _toggleSelection(int id, int tabIndex) {
    setState(() {
      if (tabIndex == 0) {
        _selectedProductIds.contains(id)
            ? _selectedProductIds.remove(id)
            : _selectedProductIds.add(id);
      } else if (tabIndex == 1) {
        _selectedAddonIds.contains(id)
            ? _selectedAddonIds.remove(id)
            : _selectedAddonIds.add(id);
      } else {
        _selectedCategoryIds.contains(id)
            ? _selectedCategoryIds.remove(id)
            : _selectedCategoryIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          !(_selectedProductIds.isNotEmpty ||
              _selectedAddonIds.isNotEmpty ||
              _selectedCategoryIds.isNotEmpty), // ADDED category check
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedProductIds.isNotEmpty ||
            _selectedAddonIds.isNotEmpty ||
            _selectedCategoryIds.isNotEmpty) {
          _clearSelection();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          // Title logic: Shows selection count or "Catalog"
          title: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, _) {
              final activeIndex = _tabController.animation!.value.round();

              // UPDATED: Check all three sets
              final currentSelection = activeIndex == 0
                  ? _selectedProductIds
                  : activeIndex == 1
                  ? _selectedAddonIds
                  : _selectedCategoryIds;

              if (currentSelection.isNotEmpty) {
                return InkWell(
                  onTap: () => _selectAll(activeIndex),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          ).selectedCount(currentSelection.length),
                          style: TextStyle(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.select_all_rounded,
                          size: 18,
                          color: context.primaryColor,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return NavHelper.buildNavTitle(
                context,
                title: Text(AppLocalizations.of(context).catalog),
              );
            },
          ),
          // Leading logic: NO back button when selecting. Only close icon.
          automaticallyImplyLeading: false,
          leadingWidth:
              (_selectedProductIds.isNotEmpty ||
                  _selectedAddonIds.isNotEmpty ||
                  _selectedCategoryIds.isNotEmpty)
              ? 56
              : 0,
          leading: AnimatedBuilder(
            animation: _tabController.animation!,
            builder: (context, _) {
              final activeIndex = _tabController.animation!.value.round();
              final currentSelection = activeIndex == 0
                  ? _selectedProductIds
                  : activeIndex == 1
                  ? _selectedAddonIds
                  : _selectedCategoryIds;

              // 1. Show the Close icon ONLY when items are selected
              if (currentSelection.isNotEmpty) {
                return IconButton(
                  icon: Icon(Icons.close, color: context.primaryColor),
                  onPressed: _clearSelection,
                );
              }

              // 2. Otherwise, return null to keep the AppBar clean
              return const SizedBox(height: 0, width: 0);
            },
          ),

          // This prevents Flutter from automatically putting a back button there
          actions: [
            AnimatedBuilder(
              animation: _tabController.animation!,
              builder: (context, _) {
                final activeIndex = _tabController.animation!.value.round();

                final currentSelection = activeIndex == 0
                    ? _selectedProductIds
                    : activeIndex == 1
                    ? _selectedAddonIds
                    : _selectedCategoryIds;

                return Row(
                  children: [
                    // Edit button logic
                    if (currentSelection.length == 1)
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => _handleEdit(activeIndex),
                      ),

                    // Delete button logic
                    if (currentSelection.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _handleDeleteMulti(activeIndex),
                      ),
                    if (currentSelection.isEmpty)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert),
                        // Pass the current integer index instead of a boolean
                        onSelected: (val) =>
                            _handleMenuAction(val, _tabController.index),
                        itemBuilder: (context) {
                          final int activeIndex = _tabController.index;
                          final l10n = AppLocalizations.of(context);

                          // Determine the name based on the current tab
                          final String tabName = activeIndex == 0
                              ? l10n.products
                              : activeIndex == 1
                              ? l10n.addons
                              : l10n.categories; // Or l10n.categories if you have it

                          return [
                            PopupMenuItem(
                              value: 'export',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.upload_rounded,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(l10n.exportType(tabName)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'import',
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.download_rounded,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(l10n.importType(tabName)),
                                ],
                              ),
                            ),
                          ];
                        },
                      ),
                  ],
                );
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabController,

            tabs: [
              Tab(text: AppLocalizations.of(context).products),
              Tab(text: AppLocalizations.of(context).addons),
              Tab(
                text: AppLocalizations.of(context).categories,
              ), // <--- NEW TAB
            ],
          ),
        ),
        body: Column(
          children: [
            if (_isImporting)
              LinearProgressIndicator(
                value: _importProgress,
                backgroundColor: context.primaryColor.withAlpha(50),
                color: context.primaryColor,
                minHeight: 4,
              ),
            Expanded(
              child: NotificationListener<UserScrollNotification>(
                onNotification: (notification) {
                  final ScrollDirection direction = notification.direction;
                  final Axis axis = notification.metrics.axis;
                  setState(() {
                    if (direction == ScrollDirection.reverse &&
                        axis == Axis.vertical) {
                      _showFab = false; // User is scrolling down
                    } else if (direction == ScrollDirection.forward &&
                        axis == Axis.vertical) {
                      _showFab = true; // User is scrolling up
                    }
                  });
                  return true;
                },
                child: TabBarView(
                  controller: _tabController,

                  children: [
                    ProductTab(
                      selectedIds: _selectedProductIds,
                      onToggle: (id) => _toggleSelection(id, 0), // Index 0
                      onAddPressed: () => showProductForm(context, ref),
                      onEdit: (product) =>
                          _editSingleProduct(product), // <--- Connect it here
                    ),
                    AddonTab(
                      selectedIds: _selectedAddonIds,
                      onToggle: (id) => _toggleSelection(id, 1), // Index 1
                      onAddPressed: () => showAddonForm(context, ref),
                      onEdit: (addon) =>
                          _editSingleAddon(addon), // <--- Connect it here
                    ),
                    CategoryTab(
                      selectedIds: _selectedCategoryIds,
                      // We check if the set is empty inside _toggleSelection now
                      onToggle: (id) => _toggleSelection(id, 2),
                      onAddPressed: () => showCategoryForm(context, ref),
                      onEdit: (cat) =>
                          _editSingleCategory(cat), // <--- Connect it here
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: AnimatedBuilder(
          animation: _tabController.animation!,
          builder: (context, _) {
            final int activeIndex = _tabController.animation!.value.round();

            // Hide if selecting items OR if user scrolled down
            final bool isSelecting =
                _selectedProductIds.isNotEmpty ||
                _selectedAddonIds.isNotEmpty ||
                _selectedCategoryIds.isNotEmpty;

            final bool visible = _showFab && !isSelecting;

            return AnimatedScale(
              // Scale is 1.0 (normal) when visible, 0.0 (disappeared) when hidden
              scale: visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              // BackOut gives it a slight "bounce" at the end of the popup
              curve: Curves.linear,
              child: FloatingActionButton(
                onPressed: () => _handleAddNew(activeIndex),
                backgroundColor: context.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- LOGIC ---
  // Update the signature in your _CatalogMasterScreenState
  Future<void> _handleMenuAction(String value, int activeIndex) async {
    // 1. Check permissions first
    final bool isGranted = await PermissionHelper.requestStoragePermission();

    if (!isGranted) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ConfirmDialog.show(
          context: context,
          title: l10n.permissionRequired,
          message: l10n.storagePermissionMessage,
          confirmLabel: l10n.grant,
          onConfirm: () async {
            Navigator.of(context, rootNavigator: true).pop();
            await Future.delayed(const Duration(milliseconds: 300));

            _handleMenuAction(value, activeIndex); // Recursive retry
          },
        );
      }
      return; // Exit here since permission wasn't granted yet
    }

    // 2. If granted, proceed with existing logic
    if (value == 'export') {
      final products = ref.read(productNotifierProvider).value ?? [];
      final addons = ref.read(addonNotifierProvider).value ?? [];
      final categories = ref.read(categoryNotifierProvider).value ?? [];

      final List<dynamic> listToExport = activeIndex == 0
          ? products
          : activeIndex == 1
          ? addons
          : categories;

      if (mounted) _showExportOptions(context, listToExport, activeIndex);
    } else {
      await _handleImport(activeIndex);
    }
  }

  Future<void> showCategoryForm(
    BuildContext context,
    WidgetRef ref, {
    CategoryEntity? category,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: category?.name);

    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'CategoryFormSheet'),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      // Use a slightly smaller radius or none for a true full-screen "Page" look
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        // 2. FORCE FULL SCREEN HEIGHT
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Safe Area top padding for full screen sheets
            SizedBox(height: MediaQuery.of(context).padding.top + 30),

            // --- HEADER SECTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel/Close Button
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    category == null
                        ? AppLocalizations.of(context).newCategory
                        : AppLocalizations.of(context).editCategory,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  // Done/Save shortcut (Optional but very Pro)
                  TextButton(
                    onPressed: () => _submitCategory(
                      formKey,
                      nameController,
                      category,
                      ref,
                      context,
                    ),
                    child: Text(
                      AppLocalizations.of(context).save,
                      style: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // --- FORM CONTENT ---
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 32,
                  // Automatically pushes everything up when keyboard opens
                  bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).categoryName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nameController,
                        autofocus: true,
                        style: const TextStyle(fontSize: 18),
                        decoration: _buildInputDecoration(
                          hint: AppLocalizations.of(context).enterName,
                          icon: Icons.category_outlined,
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? AppLocalizations.of(context).required
                            : null,
                      ),

                      const SizedBox(height: 40),

                      // Main Action Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () => _submitCategory(
                            formKey,
                            nameController,
                            category,
                            ref,
                            context,
                          ),
                          child: Text(
                            AppLocalizations.of(context).saveCategory,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Logic helper to keep the UI code clean
  void _submitCategory(
    GlobalKey<FormState> formKey,
    TextEditingController controller,
    CategoryEntity? oldCategory,
    WidgetRef ref,
    BuildContext context,
  ) async {
    if (formKey.currentState!.validate()) {
      final item = CategoryEntity(
        id: oldCategory?.id,
        name: controller.text.trim(),
      );

      final notifier = ref.read(categoryNotifierProvider.notifier);

      if (oldCategory == null) {
        await notifier.addCategory(item);
      } else {
        await notifier.updateCategory(item);
      }

      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> _handleImport(int activeIndex) async {
    final l10n = AppLocalizations.of(context);

    try {
      // 1. Pick and Parse the CSV file
      final List<dynamic> incoming = await CatalogService.importFromCsv(
        activeIndex: activeIndex,
      );

      if (incoming.isEmpty || !mounted) return;

      // 2. Get the current existing items to check for duplicates
      final List<dynamic> existing = activeIndex == 0
          ? ref.read(productNotifierProvider).value ?? []
          : activeIndex == 1
          ? ref.read(addonNotifierProvider).value ?? []
          : ref.read(categoryNotifierProvider).value ?? [];

      // 3. Show Conflict Screen and wait for User Choices
      final Map<int, ImportAction>? choices = await context
          .pushNamed<Map<int, ImportAction>>(
            AppRoutes.importPreview.name,
            extra: {
              'incomingItems': incoming,
              'existingItems': existing,
              'activeIndex': activeIndex,
            },
          );

      // If user swiped back or cancelled
      if (choices == null || !mounted) return;

      // 4. Start the Import Process
      setState(() {
        _isImporting = true;
        _importProgress = 0.0;
      });

      int processedCount = 0;
      final total = incoming.length;

      for (int i = 0; i < total; i++) {
        final action = choices[i];
        final item = incoming[i];

        // Skip if user chose "Skip"
        if (action == ImportAction.skip) {
          processedCount++;
          continue;
        }

        // Execute based on Tab
        switch (activeIndex) {
          case 0: // PRODUCTS
            final product = item as ProductEntity;

            if (action == ImportAction.replace) {
              // Find existing item ID to perform an update/overwrite
              final existingItem = existing.firstWhere(
                (e) =>
                    e.name.trim().toLowerCase() ==
                    product.name.trim().toLowerCase(),
              );
              // Call your update logic or delete then add
              await ref
                  .read(productNotifierProvider.notifier)
                  .addItem(product.copyWith(id: existingItem.id));
            } else {
              // "Add" or "Duplicate" logic
              await ref.read(productNotifierProvider.notifier).addItem(product);
            }
            break;

          case 1: // ADD-ONS
            final addon = item as AddEntity;
            if (action == ImportAction.replace) {
              final existingItem = existing.firstWhere(
                (e) =>
                    e.name.trim().toLowerCase() ==
                    addon.name.trim().toLowerCase(),
              );
              await ref
                  .read(addonNotifierProvider.notifier)
                  .addAddon(addon.copyWith(id: existingItem.id));
            } else {
              await ref.read(addonNotifierProvider.notifier).addAddon(addon);
            }
            break;

          case 2: // CATEGORIES
            final category = item as CategoryEntity;
            // Note: Categories usually don't support "Duplicate" names in DB
            if (action == ImportAction.replace) {
              final existingItem = existing.firstWhere(
                (e) =>
                    e.name.trim().toLowerCase() ==
                    category.name.trim().toLowerCase(),
              );
              await ref
                  .read(categoryNotifierProvider.notifier)
                  .addCategory(category.copyWith(id: existingItem.id));
            } else {
              await ref
                  .read(categoryNotifierProvider.notifier)
                  .addCategory(category);
            }
            break;
        }

        processedCount++;
        if (mounted) {
          setState(() => _importProgress = processedCount / total);
        }
      }

      // 5. Final UI Refresh & Feedback
      if (mounted) {
        setState(() => _isImporting = false);

        // If we added products, categories might have been created as a side effect
        if (activeIndex == 0) {
          ref.invalidate(categoryNotifierProvider);
        }

        Toaster.show(l10n.processedItems(processedCount));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isImporting = false);
        Toaster.show(l10n.importError(e.toString()));
      }
    }
  }

  void _handleDeleteMulti(int index) {
    final l10n = AppLocalizations.of(context); // Capture
    final ids = index == 0
        ? _selectedProductIds
        : (index == 1 ? _selectedAddonIds : _selectedCategoryIds);

    ConfirmDialog.show(
      context: context,
      title: l10n.deleteItems,
      message: l10n.deleteWarning(ids.length),
      onConfirm: () async {
        Navigator.of(context, rootNavigator: true).pop(); // Close dialog

        // Perform delete
        if (index == 0) {
          await ref
              .read(productNotifierProvider.notifier)
              .deleteMany(ids.toList());
        } else if (index == 1) {
          await ref
              .read(addonNotifierProvider.notifier)
              .deleteMany(ids.toList());
        } else {
          // You'll need a deleteManyCategories in your CategoryNotifier
          for (final id in ids) {
            await ref
                .read(categoryNotifierProvider.notifier)
                .removeCategory(id);
          }
        }

        _clearSelection();
        Toaster.show(l10n.deletedSuccessfully); // Or a specific delete message
      },
    );
  }

  void _handleEdit(int index) {
    if (index == 0 && _selectedProductIds.isNotEmpty) {
      final p = ref
          .read(productNotifierProvider)
          .value!
          .firstWhere((p) => p.id == _selectedProductIds.first);
      showProductForm(context, ref, product: p);
    } else if (index == 1 && _selectedAddonIds.isNotEmpty) {
      final a = ref
          .read(addonNotifierProvider)
          .value!
          .firstWhere((a) => a.id == _selectedAddonIds.first);
      showAddonForm(context, ref, addon: a);
    } else if (index == 2 && _selectedCategoryIds.isNotEmpty) {
      // ADD THIS: Handle Category Edit
      final c = ref
          .read(categoryNotifierProvider)
          .value!
          .firstWhere((c) => c.id == _selectedCategoryIds.first);
      showCategoryForm(context, ref, category: c);
    }
    _clearSelection();
  }

  void _handleAddNew(int index) {
    if (index == 0) {
      showProductForm(context, ref);
    } else if (index == 1) {
      showAddonForm(context, ref);
    } else {
      showCategoryForm(context, ref); // The method we created earlier
    }
  }

  // --- FORMS ---
  // --- FORMS ---
  Future<void> showProductForm(
    BuildContext context,
    WidgetRef ref, {
    ProductEntity? product,
  }) {
    final formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: product?.name);
    final priceController = TextEditingController(
      text: product?.basePrice.toString() ?? "",
    );
    final categoryController = TextEditingController(
      text:
          product?.category?.name ?? AppLocalizations.of(context).uncategorized,
    );
    final supplierController = TextEditingController(
      text: product?.supplier?.name ?? AppLocalizations.of(context).noSupplier,
    );
    final quantityController = TextEditingController(
      text: product?.quantity.toString() ?? "0",
    );
    final cashCostController = TextEditingController(text: "0");
    final creditCostController = TextEditingController(text: "0");
    final cashQtyController = TextEditingController(text: product?.quantity.toString() ?? "0");
    final creditQtyController = TextEditingController(text: "0");

    // Local state for the category and supplier ID & payment options
    int? selectedCatId = product?.category?.id;
    int? selectedSupplierId = product?.supplier?.id;
    bool cashIsPerUnit = true;   // true = per-unit price, false = total
    bool creditIsPerUnit = true; // true = per-unit price, false = total
    bool noCash = false;
    bool noCredit = false;
    int priorityMode = 3; // 1 = credit first, 2 = cash first, 3 = auto
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'ProductFormSheet'),
      isScrollControlled: true, // Crucial for full height
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setFormState) {
          void updateQuantities() {
            final totalStock = int.tryParse(quantityController.text) ?? 0;
            if (noCash && noCredit) {
              cashQtyController.text = "0";
              creditQtyController.text = "0";
              cashCostController.text = "0";
              creditCostController.text = "0";
              return;
            }
            if (noCash) {
              cashQtyController.text = "0";
              cashCostController.text = "0";
              creditQtyController.text = totalStock.toString();
              priorityMode = 3;
              return;
            }
            if (noCredit) {
              creditQtyController.text = "0";
              creditCostController.text = "0";
              cashQtyController.text = totalStock.toString();
              priorityMode = 3;
              return;
            }
            if (priorityMode == 1) {
              final cQty = int.tryParse(creditQtyController.text) ?? 0;
              final kQty = (totalStock - cQty).clamp(0, totalStock);
              cashQtyController.text = kQty.toString();
            } else if (priorityMode == 2) {
              final kQty = int.tryParse(cashQtyController.text) ?? 0;
              final cQty = (totalStock - kQty).clamp(0, totalStock);
              creditQtyController.text = cQty.toString();
            }
          }

          return Container(
            // Forces the sheet to take the entire screen height
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              // Keep a slight radius for a modern "layered" feel
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // 1. Safe Area Top Padding (Avoids the Notch/Status Bar)
                SizedBox(height: MediaQuery.of(context).padding.top + 30),

                // 2. Full Screen Header Navigation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context).cancel,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        product == null
                            ? AppLocalizations.of(context).addNewProduct
                            : AppLocalizations.of(context).editProduct,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      // Quick Action "Save" at top right
                      TextButton(
                        onPressed: () => _handleSubmit(
                          context,
                          ref,
                          formKey,
                          product,
                          nameController,
                          priceController,
                          selectedCatId,
                          selectedSupplierId,
                          quantityController,
                          cashCostController,
                          creditCostController,
                          cashQtyController,
                          creditQtyController,
                          noCash: noCash,
                          noCredit: noCredit,
                          cashIsPerUnit: cashIsPerUnit,
                          creditIsPerUnit: creditIsPerUnit,
                        ),
                        child: Text(
                          AppLocalizations.of(context).save,
                          style: TextStyle(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // 3. Scrollable Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      // Pushes everything up when keyboard opens
                      bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Product Name ---
                          _buildLabel(AppLocalizations.of(context).productName),
                          TextFormField(
                            controller: nameController,
                            decoration: _buildInputDecoration(
                              hint: AppLocalizations.of(
                                context,
                              ).egChickenBurger,
                              icon: Icons.shopping_bag_outlined,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? AppLocalizations.of(context).required
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // --- Base Price ---
                          _buildLabel(AppLocalizations.of(context).basePrice),
                          TextFormField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: _buildInputDecoration(
                              hint: AppLocalizations.of(context).price,
                              icon: Icons.payments_outlined,
                            ),
                            validator: (v) => (double.tryParse(v ?? '') == null)
                                ? AppLocalizations.of(context).invalid
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // --- Category Picker ---
                          _buildLabel(AppLocalizations.of(context).category),
                          TextFormField(
                            controller: categoryController,
                            readOnly: true,
                            onTap: () {
                              _showCategoryPicker(context, ref, selectedCatId, (id, name) {
                                setFormState(() {
                                  selectedCatId = id;
                                  categoryController.text = name;
                                });
                              });
                            },
                            decoration: _buildInputDecoration(
                              hint: AppLocalizations.of(context).selectCategory,
                              icon: Icons.category_outlined,
                              suffixIcon: Icons.expand_more_rounded,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // --- Supplier Picker ---
                          _buildLabel(AppLocalizations.of(context).supplier),
                          TextFormField(
                            controller: supplierController,
                            readOnly: true,
                            onTap: () {
                              _showSupplierPicker(context, ref, selectedSupplierId, (id, name) {
                                setFormState(() {
                                  selectedSupplierId = id;
                                  supplierController.text = name;
                                });
                              });
                            },
                            decoration: _buildInputDecoration(
                              hint: AppLocalizations.of(context).selectSupplier,
                              icon: Icons.business_outlined,
                              suffixIcon: Icons.expand_more_rounded,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // --- Quantity ---
                          _buildLabel(isArabic ? 'الكمية المتوفرة' : 'Quantity in Stock'),
                          TextFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              hint: isArabic ? 'أدخل الكمية' : 'Enter quantity',
                              icon: Icons.inventory_outlined,
                            ),
                            onChanged: (_) => setFormState(() => updateQuantities()),
                            validator: (v) => (int.tryParse(v ?? '') == null || int.parse(v!) < 0)
                                ? AppLocalizations.of(context).invalid
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // --- Cash Purchase Cost & Quantity ---
                          _buildLabel(isArabic ? 'تكلفة شراء نقداً' : 'Cash Purchase Cost'),
                          Row(
                            children: [
                              Checkbox(
                                value: noCash,
                                activeColor: context.primaryColor,
                                onChanged: (val) {
                                  setFormState(() {
                                    noCash = val ?? false;
                                    if (noCash) {
                                      cashCostController.text = "0";
                                      cashQtyController.text = "0";
                                      priorityMode = 3;
                                      final totalStock = int.tryParse(quantityController.text) ?? 0;
                                      if (!noCredit) creditQtyController.text = totalStock.toString();
                                    } else {
                                      updateQuantities();
                                    }
                                  });
                                },
                              ),
                              Text(
                                isArabic ? 'لا يوجد شراء نقداً' : 'No Cash Purchase',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: noCash ? Colors.red : Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: cashCostController,
                            enabled: !noCash,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _buildInputDecoration(
                              hint: '0.00',
                              icon: Icons.money_outlined,
                            ),
                            validator: (v) {
                              if (noCash) return null;
                              return (double.tryParse(v ?? '') == null || double.parse(v!) < 0)
                                  ? AppLocalizations.of(context).invalid
                                  : null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ChoiceChip(
                                label: Text(isArabic ? 'للقطعة' : 'Per Unit'),
                                selected: cashIsPerUnit,
                                onSelected: noCash ? null : (_) => setFormState(() => cashIsPerUnit = true),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: cashIsPerUnit ? context.primaryColor : null,
                                  fontWeight: cashIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: Text(isArabic ? 'إجمالي' : 'Total'),
                                selected: !cashIsPerUnit,
                                onSelected: noCash ? null : (_) => setFormState(() => cashIsPerUnit = false),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: !cashIsPerUnit ? context.primaryColor : null,
                                  fontWeight: !cashIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildLabel(isArabic ? 'كمية الشراء نقداً' : 'Cash Purchase Quantity'),
                          TextFormField(
                            controller: cashQtyController,
                            enabled: !noCash && priorityMode != 1,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              hint: '0',
                              icon: Icons.shopping_cart_outlined,
                            ),
                            onChanged: (_) {
                              if (priorityMode == 2) {
                                setFormState(() => updateQuantities());
                              }
                            },
                            validator: (v) {
                              if (noCash) return null;
                              final kQty = int.tryParse(v ?? '');
                              final totalQty = int.tryParse(quantityController.text) ?? 0;
                              if (kQty == null || kQty < 0) return AppLocalizations.of(context).invalid;
                              if (kQty > totalQty) {
                                return isArabic
                                    ? 'الكمية النقدية ($kQty) تتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Cash quantity ($kQty) exceeds total stock ($totalQty)';
                              }
                              final cQty = int.tryParse(creditQtyController.text) ?? 0;
                              if (kQty + cQty > totalQty) {
                                return isArabic
                                    ? 'مجموع الكميات (${kQty + cQty}) يتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Total cash & credit qty (${kQty + cQty}) exceeds stock ($totalQty)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // --- Credit Purchase Cost & Quantity ---
                          _buildLabel(isArabic ? 'تكلفة شراء أجلاً (دين)' : 'Credit Purchase Cost (Debt)'),
                          Row(
                            children: [
                              Checkbox(
                                value: noCredit,
                                activeColor: context.primaryColor,
                                onChanged: (val) {
                                  setFormState(() {
                                    noCredit = val ?? false;
                                    if (noCredit) {
                                      creditCostController.text = "0";
                                      creditQtyController.text = "0";
                                      priorityMode = 3;
                                      final totalStock = int.tryParse(quantityController.text) ?? 0;
                                      if (!noCash) cashQtyController.text = totalStock.toString();
                                    } else {
                                      updateQuantities();
                                    }
                                  });
                                },
                              ),
                              Text(
                                isArabic ? 'لا يوجد شراء أجلاً' : 'No Credit Purchase',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: noCredit ? Colors.red : Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: creditCostController,
                            enabled: !noCredit,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _buildInputDecoration(
                              hint: '0.00',
                              icon: Icons.money_off_outlined,
                            ),
                            validator: (v) {
                              if (noCredit) return null;
                              final parsed = double.tryParse(v ?? '');
                              if (parsed == null || parsed < 0) {
                                return AppLocalizations.of(context).invalid;
                              }
                              final cQty = int.tryParse(creditQtyController.text) ?? 0;
                              if ((parsed > 0 || cQty > 0) && selectedSupplierId == null) {
                                return isArabic ? 'يجب اختيار مورد للشراء الآجل' : 'Supplier is required for credit purchase';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ChoiceChip(
                                label: Text(isArabic ? 'للقطعة' : 'Per Unit'),
                                selected: creditIsPerUnit,
                                onSelected: noCredit ? null : (_) => setFormState(() => creditIsPerUnit = true),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: creditIsPerUnit ? context.primaryColor : null,
                                  fontWeight: creditIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: Text(isArabic ? 'إجمالي' : 'Total'),
                                selected: !creditIsPerUnit,
                                onSelected: noCredit ? null : (_) => setFormState(() => creditIsPerUnit = false),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: !creditIsPerUnit ? context.primaryColor : null,
                                  fontWeight: !creditIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildLabel(isArabic ? 'كمية الشراء أجلاً' : 'Credit Purchase Quantity'),
                          TextFormField(
                            controller: creditQtyController,
                            enabled: !noCredit && priorityMode != 2,
                            keyboardType: TextInputType.number,
                            decoration: _buildInputDecoration(
                              hint: '0',
                              icon: Icons.credit_card_outlined,
                            ),
                            onChanged: (_) {
                              if (priorityMode == 1) {
                                setFormState(() => updateQuantities());
                              }
                            },
                            validator: (v) {
                              if (noCredit) return null;
                              final cQty = int.tryParse(v ?? '');
                              final totalQty = int.tryParse(quantityController.text) ?? 0;
                              if (cQty == null || cQty < 0) return AppLocalizations.of(context).invalid;
                              if (cQty > totalQty) {
                                return isArabic
                                    ? 'الكمية الآجلة ($cQty) تتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Credit quantity ($cQty) exceeds total stock ($totalQty)';
                              }
                              final kQty = int.tryParse(cashQtyController.text) ?? 0;
                              if (kQty + cQty > totalQty) {
                                return isArabic
                                    ? 'مجموع الكميات (${kQty + cQty}) يتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Total cash & credit qty (${kQty + cQty}) exceeds stock ($totalQty)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // --- Priority Calculation Modes ---
                          _buildLabel(isArabic ? 'أولوية احتساب الكمية' : 'Quantity Calculation Priority'),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF3C3C3C) : Colors.grey.shade200,
                              ),
                            ),
                            child: Column(
                              children: [
                                RadioListTile<int>(
                                  title: Text(isArabic ? '1. حساب كمية الأجل أولاً ثم النقد' : '1. Calculate Credit Qty first, then Cash'),
                                  value: 1,
                                  groupValue: priorityMode,
                                  activeColor: context.primaryColor,
                                  onChanged: (noCash || noCredit)
                                      ? null
                                      : (val) {
                                          setFormState(() {
                                            priorityMode = val!;
                                            updateQuantities();
                                          });
                                        },
                                ),
                                RadioListTile<int>(
                                  title: Text(isArabic ? '2. حساب كمية النقد أولاً ثم الأجل' : '2. Calculate Cash Qty first, then Credit'),
                                  value: 2,
                                  groupValue: priorityMode,
                                  activeColor: context.primaryColor,
                                  onChanged: (noCash || noCredit)
                                      ? null
                                      : (val) {
                                          setFormState(() {
                                            priorityMode = val!;
                                            updateQuantities();
                                          });
                                        },
                                ),
                                RadioListTile<int>(
                                  title: Text(isArabic ? '3. تلقائياً (يدوي)' : '3. Automatic / Default'),
                                  value: 3,
                                  groupValue: priorityMode,
                                  activeColor: context.primaryColor,
                                  onChanged: (val) {
                                    setFormState(() {
                                      priorityMode = val!;
                                      updateQuantities();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // --- Big Main Save Button ---
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => _handleSubmit(
                                context,
                                ref,
                                formKey,
                                product,
                                nameController,
                                priceController,
                                selectedCatId,
                                selectedSupplierId,
                                quantityController,
                                cashCostController,
                                creditCostController,
                                cashQtyController,
                                creditQtyController,
                                noCash: noCash,
                                noCredit: noCredit,
                                cashIsPerUnit: cashIsPerUnit,
                                creditIsPerUnit: creditIsPerUnit,
                              ),
                              child: Text(
                                AppLocalizations.of(context).saveProduct,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Logic Helper: Extracting the submission code to avoid duplication
  Future<void> _handleSubmit(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    ProductEntity? originalProduct,
    TextEditingController nameCtrl,
    TextEditingController priceCtrl,
    int? catId,
    int? supId,
    TextEditingController quantityCtrl,
    TextEditingController cashCostCtrl,
    TextEditingController creditCostCtrl,
    TextEditingController cashQtyCtrl,
    TextEditingController creditQtyCtrl, {
    bool noCash = false,
    bool noCredit = false,
    bool cashIsPerUnit = true,
    bool creditIsPerUnit = true,
  }) async {
    if (formKey.currentState!.validate()) {
      final newQuantity = int.parse(quantityCtrl.text);
      final item = ProductEntity(
        id: originalProduct?.id,
        name: nameCtrl.text.trim(),
        basePrice: double.parse(priceCtrl.text),
        category: catId != null ? CategoryEntity(id: catId, name: "") : null,
        supplier: supId != null ? SupplierEntity(id: supId, name: "") : null,
        quantity: newQuantity,
      );

      final oldQuantity = originalProduct?.quantity ?? 0;
      final addedQuantity = newQuantity - oldQuantity;

      final err = originalProduct == null
          ? await ref.read(productNotifierProvider.notifier).addItem(item)
          : await ref
                .read(productNotifierProvider.notifier)
                .updateProduct(item);

      if (err == null) {
        if (addedQuantity > 0 && supId != null) {
          final cQty = noCredit ? 0 : (int.tryParse(creditQtyCtrl.text) ?? 0);
          final kQty = noCash ? 0 : (int.tryParse(cashQtyCtrl.text) ?? 0);
          final rawCredit = noCredit ? 0.0 : (double.tryParse(creditCostCtrl.text) ?? 0.0);
          final rawCash = noCash ? 0.0 : (double.tryParse(cashCostCtrl.text) ?? 0.0);

          final creditCost = creditIsPerUnit ? rawCredit * cQty : rawCredit;
          final cashCost = cashIsPerUnit ? rawCash * kQty : rawCash;

          final dbService = ref.read(supplierDatabaseServiceProvider);

          if (creditCost > 0 && cQty > 0) {
            await dbService.addTransaction(SupplierTransactionEntity(
              supplierId: supId,
              type: 'credit',
              amount: creditCost,
              description: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'شراء $cQty قطعة أجلاً من ${nameCtrl.text.trim()}'
                  : 'Purchased $cQty on credit of ${nameCtrl.text.trim()}',
              createdAt: DateTime.now(),
            ));
          }

          if (cashCost > 0 && kQty > 0) {
            await dbService.addTransaction(SupplierTransactionEntity(
              supplierId: supId,
              type: 'debit',
              amount: cashCost,
              description: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'دفعة نقدية لشراء $kQty قطعة من ${nameCtrl.text.trim()}'
                  : 'Cash paid for $kQty of ${nameCtrl.text.trim()}',
              createdAt: DateTime.now(),
            ));
          }
        }
        if (context.mounted) Navigator.pop(context);
      } else {
        if (context.mounted) ErrorDialog.show(context, message: err);
      }
    }
  }

  // UI Helper: Label Styling
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  // UI Helper: Input Styling
  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
    IconData? suffixIcon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
      prefixIcon: Icon(icon, color: context.primaryColor),
      suffixIcon: suffixIcon != null
          ? Icon(suffixIcon, color: isDark ? Colors.grey.shade400 : Colors.grey)
          : null,
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
      ),
    );
  }

  void _showCategoryPicker(
    BuildContext context,
    WidgetRef ref,
    int? selectedCatId,
    Function(int?, String) onSelected,
  ) {
    final categories = ref.read(categoryNotifierProvider).value ?? [];
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'CategoryPickerSheet'),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(sheetContext).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(sheetContext).selectCategory,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // LIST OF CATEGORIES
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // Uncategorized Option
                    _buildPickerTile(
                      label: AppLocalizations.of(sheetContext).uncategorized,
                      isSelected: selectedCatId == null,
                      onTap: () {
                        onSelected(
                          null,
                          AppLocalizations.of(sheetContext).uncategorized,
                        );
                        Navigator.pop(sheetContext);
                      },
                    ),

                    // Dynamic Categories
                    ...categories.map(
                      (cat) => _buildPickerTile(
                        label: cat.name,
                        isSelected: selectedCatId == cat.id,
                        onTap: () {
                          onSelected(cat.id, cat.name);
                          Navigator.pop(sheetContext);
                        },
                      ),
                    ),

                    const Divider(height: 32),

                    // ADD NEW ACTION
                    _buildPickerTile(
                      label: AppLocalizations.of(sheetContext).addNewCategory,
                      isSelected: false,
                      isAction: true,
                      onTap: () {
                        Navigator.pop(sheetContext); // Close picker
                        showCategoryForm(context, ref); // Open form
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupplierPicker(
    BuildContext context,
    WidgetRef ref,
    int? selectedSupplierId,
    Function(int?, String) onSelected,
  ) {
    final suppliers = ref.read(supplierNotifierProvider).value ?? [];
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'SupplierPickerSheet'),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            12,
            24,
            MediaQuery.of(sheetContext).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(sheetContext).selectSupplier,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    // No Supplier Option
                    _buildPickerTile(
                      label: AppLocalizations.of(sheetContext).noSupplier,
                      isSelected: selectedSupplierId == null,
                      onTap: () {
                        onSelected(null, AppLocalizations.of(sheetContext).noSupplier);
                        Navigator.pop(sheetContext);
                      },
                    ),
                    // Dynamic Suppliers
                    ...suppliers.map(
                      (sup) => _buildPickerTile(
                        label: sup.name,
                        isSelected: selectedSupplierId == sup.id,
                        onTap: () {
                          onSelected(sup.id, sup.name);
                          Navigator.pop(sheetContext);
                        },
                      ),
                    ),

                    const Divider(height: 32),

                    // ADD NEW SUPPLIER ACTION
                    _buildPickerTile(
                      label: Localizations.localeOf(sheetContext).languageCode == 'ar'
                          ? 'إضافة مورد جديد'
                          : 'Add New Supplier',
                      isSelected: false,
                      isAction: true,
                      onTap: () {
                        Navigator.pop(sheetContext); // Close picker
                        _showSupplierQuickAddForm(
                          context,
                          ref,
                          onAdded: onSelected,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Quick-add supplier form (minimal: name only, like category quick-add)
  void _showSupplierQuickAddForm(
    BuildContext context,
    WidgetRef ref, {
    required Function(int?, String) onAdded,
  }) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'SupplierQuickAddSheet'),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        height: MediaQuery.of(ctx).size.height * 0.85,
        decoration: BoxDecoration(
          color: Theme.of(ctx).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(ctx).padding.top + 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      isArabic ? 'إلغاء' : 'Cancel',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    isArabic ? 'إضافة مورد جديد' : 'Add New Supplier',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final newSupplier = SupplierEntity(
                          name: nameCtrl.text.trim(),
                          phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
                          email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                          address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
                        );
                        await ref.read(supplierNotifierProvider.notifier).addSupplier(newSupplier);
                        // Re-read list to get the newly created supplier with its ID
                        final suppliers = ref.read(supplierNotifierProvider).value ?? [];
                        final added = suppliers.lastWhere(
                          (s) => s.name == nameCtrl.text.trim(),
                          orElse: () => newSupplier,
                        );
                        if (ctx.mounted) Navigator.pop(ctx);
                        onAdded(added.id, added.name);
                      }
                    },
                    child: Text(
                      isArabic ? 'حفظ' : 'Save',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24, right: 24, top: 24,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supplier Name
                      _buildLabel(isArabic ? 'اسم المورد *' : 'Supplier Name *'),
                      TextFormField(
                        controller: nameCtrl,
                        autofocus: true,
                        decoration: _buildInputDecoration(
                          hint: isArabic ? 'أدخل اسم المورد' : 'Enter supplier name',
                          icon: Icons.business_outlined,
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? (isArabic ? 'مطلوب' : 'Required')
                            : null,
                      ),
                      const SizedBox(height: 20),

                      // Phone Number
                      _buildLabel(isArabic ? 'رقم الهاتف' : 'Phone Number'),
                      TextFormField(
                        controller: phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: _buildInputDecoration(
                          hint: isArabic ? 'أدخل رقم الهاتف' : 'Enter phone number',
                          icon: Icons.phone_outlined,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Email
                      _buildLabel(isArabic ? 'البريد الإلكتروني' : 'Email Address'),
                      TextFormField(
                        controller: emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: _buildInputDecoration(
                          hint: isArabic ? 'أدخل البريد الإلكتروني' : 'Enter email address',
                          icon: Icons.email_outlined,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Address
                      _buildLabel(isArabic ? 'العنوان' : 'Address'),
                      TextFormField(
                        controller: addressCtrl,
                        decoration: _buildInputDecoration(
                          hint: isArabic ? 'أدخل عنوان المورد' : 'Enter supplier address',
                          icon: Icons.location_on_outlined,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button inside form
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.primaryColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: const Icon(Icons.check_circle_outline),
                          label: Text(
                            isArabic ? 'حفظ وتحديد المورد' : 'Save & Select Supplier',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              final newSupplier = SupplierEntity(
                                name: nameCtrl.text.trim(),
                                phone: phoneCtrl.text.trim().isEmpty ? null : phoneCtrl.text.trim(),
                                email: emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                                address: addressCtrl.text.trim().isEmpty ? null : addressCtrl.text.trim(),
                              );
                              await ref.read(supplierNotifierProvider.notifier).addSupplier(newSupplier);
                              final suppliers = ref.read(supplierNotifierProvider).value ?? [];
                              final added = suppliers.lastWhere(
                                (s) => s.name == nameCtrl.text.trim(),
                                orElse: () => newSupplier,
                              );
                              if (ctx.mounted) Navigator.pop(ctx);
                              onAdded(added.id, added.name);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // THE REUSABLE PICKER TILE
  Widget _buildPickerTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    bool isAction = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        // Use a light orange background for the 'Add' action to distinguish it
        color: isSelected
            ? context.primaryColor.withAlpha(15)
            : (isAction
                  ? context.primaryColor.withAlpha(8)
                  : Colors.transparent),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? context.primaryColor
                    : (isAction
                          ? context.primaryColor.withAlpha(80)
                          : Colors.grey.shade200),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                if (isAction) ...[
                  Icon(
                    Icons.add_circle_outline_rounded,
                    color: context.primaryColor,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected
                          ? context.primaryColor
                          : (isAction ? context.primaryColor : Colors.black87),
                      fontWeight: isSelected || isAction
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: context.primaryColor,
                    size: 22,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showAddonForm(
    BuildContext context,
    WidgetRef ref, {
    AddEntity? addon,
  }) {
    final formKey = GlobalKey<FormState>();

    // Controllers
    final nameController = TextEditingController(text: addon?.name);
    final priceController = TextEditingController(
      text: addon != null ? addon.basePrice.toString() : "",
    );
    final supplierController = TextEditingController(
      text: addon?.supplier?.name ?? AppLocalizations.of(context).noSupplier,
    );
    final quantityController = TextEditingController(
      text: addon?.quantity.toString() ?? "0",
    );
    final cashCostController = TextEditingController(text: "0");
    final creditCostController = TextEditingController(text: "0");
    final cashQtyController = TextEditingController(text: addon?.quantity.toString() ?? "0");
    final creditQtyController = TextEditingController(text: "0");

    // Local state
    int? selectedSupplierId = addon?.supplier?.id;
    bool cashIsPerUnit = true;   // per-unit vs total toggle
    bool creditIsPerUnit = true;
    bool noCash = false;
    bool noCredit = false;
    int priorityMode = 3; // 1 = credit first, 2 = cash first, 3 = auto
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'AddonFormSheet'),
      isScrollControlled: true, // Crucial for 100% height
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setFormState) {
          void updateQuantities() {
            final totalStock = int.tryParse(quantityController.text) ?? 0;
            if (noCash && noCredit) {
              cashQtyController.text = "0";
              creditQtyController.text = "0";
              cashCostController.text = "0";
              creditCostController.text = "0";
              return;
            }
            if (noCash) {
              cashQtyController.text = "0";
              cashCostController.text = "0";
              creditQtyController.text = totalStock.toString();
              priorityMode = 3;
              return;
            }
            if (noCredit) {
              creditQtyController.text = "0";
              creditCostController.text = "0";
              cashQtyController.text = totalStock.toString();
              priorityMode = 3;
              return;
            }
            if (priorityMode == 1) {
              final cQty = int.tryParse(creditQtyController.text) ?? 0;
              final kQty = (totalStock - cQty).clamp(0, totalStock);
              cashQtyController.text = kQty.toString();
            } else if (priorityMode == 2) {
              final kQty = int.tryParse(cashQtyController.text) ?? 0;
              final cQty = (totalStock - kQty).clamp(0, totalStock);
              creditQtyController.text = cQty.toString();
            }
          }

          return Container(
            // 1. FORCE TRUE FULL SCREEN
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // 2. Safe Area Top Padding
                SizedBox(height: MediaQuery.of(context).padding.top + 30),

                // 3. Navigation Header (Cancel - Title - Save)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          AppLocalizations.of(context).cancel,
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        addon == null
                            ? AppLocalizations.of(context).newAddon
                            : AppLocalizations.of(context).editAddon(addon.name),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _handleSubmitAddon(
                          context,
                          ref,
                          formKey,
                          addon,
                          nameController,
                          priceController,
                          selectedSupplierId,
                          quantityController,
                          cashCostController,
                          creditCostController,
                          cashQtyController,
                          creditQtyController,
                          noCash: noCash,
                          noCredit: noCredit,
                          cashIsPerUnit: cashIsPerUnit,
                          creditIsPerUnit: creditIsPerUnit,
                        ),
                        child: Text(
                          AppLocalizations.of(context).save,
                          style: TextStyle(
                            color: context.primaryColor,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // 4. Scrollable Form Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(
                      left: 24,
                      right: 24,
                      top: 24,
                      // Automatically pushes content above the keyboard
                      bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Addon Name ---
                          _buildAddonLabel(AppLocalizations.of(context).addonName),
                          TextFormField(
                            controller: nameController,
                            autofocus:
                                addon == null, // Autofocus only for new items
                            decoration: _buildAddonInputDecoration(
                              hint: AppLocalizations.of(context).egExtraCheese,
                              icon: Icons.add_circle_outline,
                            ),
                            validator: (v) => (v == null || v.isEmpty)
                                ? AppLocalizations.of(context).required
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // --- Price ---
                          _buildAddonLabel(AppLocalizations.of(context).price),
                          TextFormField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: _buildAddonInputDecoration(
                              hint: AppLocalizations.of(context).price,
                              icon: Icons.payments_outlined,
                            ),
                            validator: (v) => (double.tryParse(v ?? '') == null)
                                ? AppLocalizations.of(context).invalid
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // --- Supplier Picker ---
                          _buildAddonLabel(AppLocalizations.of(context).supplier),
                          TextFormField(
                            controller: supplierController,
                            readOnly: true,
                            onTap: () {
                              _showSupplierPicker(context, ref, selectedSupplierId, (id, name) {
                                setFormState(() {
                                  selectedSupplierId = id;
                                  supplierController.text = name;
                                });
                              });
                            },
                            decoration: _buildAddonInputDecoration(
                              hint: AppLocalizations.of(context).selectSupplier,
                              icon: Icons.business_outlined,
                            ),
                          ),

                          const SizedBox(height: 24),

                          // --- Quantity ---
                          _buildAddonLabel(isArabic ? 'الكمية المتوفرة' : 'Quantity in Stock'),
                          TextFormField(
                            controller: quantityController,
                            keyboardType: TextInputType.number,
                            decoration: _buildAddonInputDecoration(
                              hint: isArabic ? 'أدخل الكمية' : 'Enter quantity',
                              icon: Icons.inventory_outlined,
                            ),
                            onChanged: (_) => setFormState(() => updateQuantities()),
                            validator: (v) => (int.tryParse(v ?? '') == null || int.parse(v!) < 0)
                                ? AppLocalizations.of(context).invalid
                                : null,
                          ),

                          const SizedBox(height: 24),

                          // --- Cash Purchase Cost & Quantity ---
                          _buildAddonLabel(isArabic ? 'تكلفة شراء نقداً' : 'Cash Purchase Cost'),
                          Row(
                            children: [
                              Checkbox(
                                value: noCash,
                                activeColor: context.primaryColor,
                                onChanged: (val) {
                                  setFormState(() {
                                    noCash = val ?? false;
                                    if (noCash) {
                                      cashCostController.text = "0";
                                      cashQtyController.text = "0";
                                      priorityMode = 3;
                                      final totalStock = int.tryParse(quantityController.text) ?? 0;
                                      if (!noCredit) creditQtyController.text = totalStock.toString();
                                    } else {
                                      updateQuantities();
                                    }
                                  });
                                },
                              ),
                              Text(
                                isArabic ? 'لا يوجد شراء نقداً' : 'No Cash Purchase',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: noCash ? Colors.red : Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: cashCostController,
                            enabled: !noCash,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _buildAddonInputDecoration(
                              hint: '0.00',
                              icon: Icons.money_outlined,
                            ),
                            validator: (v) {
                              if (noCash) return null;
                              return (double.tryParse(v ?? '') == null || double.parse(v!) < 0)
                                  ? AppLocalizations.of(context).invalid
                                  : null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ChoiceChip(
                                label: Text(isArabic ? 'للقطعة' : 'Per Unit'),
                                selected: cashIsPerUnit,
                                onSelected: noCash ? null : (_) => setFormState(() => cashIsPerUnit = true),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: cashIsPerUnit ? context.primaryColor : null,
                                  fontWeight: cashIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: Text(isArabic ? 'إجمالي' : 'Total'),
                                selected: !cashIsPerUnit,
                                onSelected: noCash ? null : (_) => setFormState(() => cashIsPerUnit = false),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: !cashIsPerUnit ? context.primaryColor : null,
                                  fontWeight: !cashIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildAddonLabel(isArabic ? 'كمية الشراء نقداً' : 'Cash Purchase Quantity'),
                          TextFormField(
                            controller: cashQtyController,
                            enabled: !noCash && priorityMode != 1,
                            keyboardType: TextInputType.number,
                            decoration: _buildAddonInputDecoration(
                              hint: '0',
                              icon: Icons.shopping_cart_outlined,
                            ),
                            onChanged: (_) {
                              if (priorityMode == 2) {
                                setFormState(() => updateQuantities());
                              }
                            },
                            validator: (v) {
                              if (noCash) return null;
                              final kQty = int.tryParse(v ?? '');
                              final totalQty = int.tryParse(quantityController.text) ?? 0;
                              if (kQty == null || kQty < 0) return AppLocalizations.of(context).invalid;
                              if (kQty > totalQty) {
                                return isArabic
                                    ? 'الكمية النقدية ($kQty) تتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Cash quantity ($kQty) exceeds total stock ($totalQty)';
                              }
                              final cQty = int.tryParse(creditQtyController.text) ?? 0;
                              if (kQty + cQty > totalQty) {
                                return isArabic
                                    ? 'مجموع الكميات (${kQty + cQty}) يتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Total cash & credit qty (${kQty + cQty}) exceeds stock ($totalQty)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // --- Credit Purchase Cost & Quantity ---
                          _buildAddonLabel(isArabic ? 'تكلفة شراء أجلاً (دين)' : 'Credit Purchase Cost (Debt)'),
                          Row(
                            children: [
                              Checkbox(
                                value: noCredit,
                                activeColor: context.primaryColor,
                                onChanged: (val) {
                                  setFormState(() {
                                    noCredit = val ?? false;
                                    if (noCredit) {
                                      creditCostController.text = "0";
                                      creditQtyController.text = "0";
                                      priorityMode = 3;
                                      final totalStock = int.tryParse(quantityController.text) ?? 0;
                                      if (!noCash) cashQtyController.text = totalStock.toString();
                                    } else {
                                      updateQuantities();
                                    }
                                  });
                                },
                              ),
                              Text(
                                isArabic ? 'لا يوجد شراء أجلاً' : 'No Credit Purchase',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: noCredit ? Colors.red : Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: creditCostController,
                            enabled: !noCredit,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: _buildAddonInputDecoration(
                              hint: '0.00',
                              icon: Icons.money_off_outlined,
                            ),
                            validator: (v) {
                              if (noCredit) return null;
                              final parsed = double.tryParse(v ?? '');
                              if (parsed == null || parsed < 0) {
                                return AppLocalizations.of(context).invalid;
                              }
                              final cQty = int.tryParse(creditQtyController.text) ?? 0;
                              if ((parsed > 0 || cQty > 0) && selectedSupplierId == null) {
                                return isArabic ? 'يجب اختيار مورد للشراء الآجل' : 'Supplier is required for credit purchase';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ChoiceChip(
                                label: Text(isArabic ? 'للقطعة' : 'Per Unit'),
                                selected: creditIsPerUnit,
                                onSelected: noCredit ? null : (_) => setFormState(() => creditIsPerUnit = true),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: creditIsPerUnit ? context.primaryColor : null,
                                  fontWeight: creditIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8),
                              ChoiceChip(
                                label: Text(isArabic ? 'إجمالي' : 'Total'),
                                selected: !creditIsPerUnit,
                                onSelected: noCredit ? null : (_) => setFormState(() => creditIsPerUnit = false),
                                selectedColor: context.primaryColor.withAlpha(30),
                                labelStyle: TextStyle(
                                  color: !creditIsPerUnit ? context.primaryColor : null,
                                  fontWeight: !creditIsPerUnit ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildAddonLabel(isArabic ? 'كمية الشراء أجلاً' : 'Credit Purchase Quantity'),
                          TextFormField(
                            controller: creditQtyController,
                            enabled: !noCredit && priorityMode != 2,
                            keyboardType: TextInputType.number,
                            decoration: _buildAddonInputDecoration(
                              hint: '0',
                              icon: Icons.credit_card_outlined,
                            ),
                            onChanged: (_) {
                              if (priorityMode == 1) {
                                setFormState(() => updateQuantities());
                              }
                            },
                            validator: (v) {
                              if (noCredit) return null;
                              final cQty = int.tryParse(v ?? '');
                              final totalQty = int.tryParse(quantityController.text) ?? 0;
                              if (cQty == null || cQty < 0) return AppLocalizations.of(context).invalid;
                              if (cQty > totalQty) {
                                return isArabic
                                    ? 'الكمية الآجلة ($cQty) تتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Credit quantity ($cQty) exceeds total stock ($totalQty)';
                              }
                              final kQty = int.tryParse(cashQtyController.text) ?? 0;
                              if (kQty + cQty > totalQty) {
                                return isArabic
                                    ? 'مجموع الكميات (${kQty + cQty}) يتجاوز الكمية المتوفرة ($totalQty)'
                                    : 'Total cash & credit qty (${kQty + cQty}) exceeds stock ($totalQty)';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // --- Priority Calculation Modes ---
                          _buildAddonLabel(isArabic ? 'أولوية احتساب الكمية' : 'Quantity Calculation Priority'),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF3C3C3C) : Colors.grey.shade200,
                              ),
                            ),
                            child: Column(
                              children: [
                                RadioListTile<int>(
                                  title: Text(isArabic ? '1. حساب كمية الأجل أولاً ثم النقد' : '1. Calculate Credit Qty first, then Cash'),
                                  value: 1,
                                  groupValue: priorityMode,
                                  activeColor: context.primaryColor,
                                  onChanged: (noCash || noCredit)
                                      ? null
                                      : (val) {
                                          setFormState(() {
                                            priorityMode = val!;
                                            updateQuantities();
                                          });
                                        },
                                ),
                                RadioListTile<int>(
                                  title: Text(isArabic ? '2. حساب كمية النقد أولاً ثم الأجل' : '2. Calculate Cash Qty first, then Credit'),
                                  value: 2,
                                  groupValue: priorityMode,
                                  activeColor: context.primaryColor,
                                  onChanged: (noCash || noCredit)
                                      ? null
                                      : (val) {
                                          setFormState(() {
                                            priorityMode = val!;
                                            updateQuantities();
                                          });
                                        },
                                ),
                                RadioListTile<int>(
                                  title: Text(isArabic ? '3. تلقائياً (يدوي)' : '3. Automatic / Default'),
                                  value: 3,
                                  groupValue: priorityMode,
                                  activeColor: context.primaryColor,
                                  onChanged: (val) {
                                    setFormState(() {
                                      priorityMode = val!;
                                      updateQuantities();
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // --- Bottom Action Button ---
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: () => _handleSubmitAddon(
                                context,
                                ref,
                                formKey,
                                addon,
                                nameController,
                                priceController,
                                selectedSupplierId,
                                quantityController,
                                cashCostController,
                                creditCostController,
                                cashQtyController,
                                creditQtyController,
                                noCash: noCash,
                                noCredit: noCredit,
                                cashIsPerUnit: cashIsPerUnit,
                                creditIsPerUnit: creditIsPerUnit,
                              ),
                              child: Text(
                                AppLocalizations.of(context).saveAddon,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Logic Helper: Centralized Submit
  Future<void> _handleSubmitAddon(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    AddEntity? originalAddon,
    TextEditingController nameCtrl,
    TextEditingController priceCtrl,
    int? supId,
    TextEditingController quantityCtrl,
    TextEditingController cashCostCtrl,
    TextEditingController creditCostCtrl,
    TextEditingController cashQtyCtrl,
    TextEditingController creditQtyCtrl, {
    bool noCash = false,
    bool noCredit = false,
    bool cashIsPerUnit = true,
    bool creditIsPerUnit = true,
  }) async {
    if (formKey.currentState!.validate()) {
      final newQuantity = int.parse(quantityCtrl.text);
      final item = AddEntity(
        id: originalAddon?.id,
        name: nameCtrl.text.trim(),
        basePrice: double.parse(priceCtrl.text),
        supplier: supId != null ? SupplierEntity(id: supId, name: "") : null,
        quantity: newQuantity,
      );

      final oldQuantity = originalAddon?.quantity ?? 0;
      final addedQuantity = newQuantity - oldQuantity;

      final notifier = ref.read(addonNotifierProvider.notifier);
      final String? error = (originalAddon == null)
          ? await notifier.addAddon(item)
          : await notifier.updateAddon(item);

      if (error == null) {
        if (addedQuantity > 0 && supId != null) {
          final cQty = noCredit ? 0 : (int.tryParse(creditQtyCtrl.text) ?? 0);
          final kQty = noCash ? 0 : (int.tryParse(cashQtyCtrl.text) ?? 0);
          final rawCredit = noCredit ? 0.0 : (double.tryParse(creditCostCtrl.text) ?? 0.0);
          final rawCash = noCash ? 0.0 : (double.tryParse(cashCostCtrl.text) ?? 0.0);

          final creditCost = creditIsPerUnit ? rawCredit * cQty : rawCredit;
          final cashCost = cashIsPerUnit ? rawCash * kQty : rawCash;

          final dbService = ref.read(supplierDatabaseServiceProvider);

          if (creditCost > 0 && cQty > 0) {
            await dbService.addTransaction(SupplierTransactionEntity(
              supplierId: supId,
              type: 'credit',
              amount: creditCost,
              description: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'شراء إضافة $cQty قطعة أجلاً من ${nameCtrl.text.trim()}'
                  : 'Purchased addon $cQty on credit of ${nameCtrl.text.trim()}',
              createdAt: DateTime.now(),
            ));
          }

          if (cashCost > 0 && kQty > 0) {
            await dbService.addTransaction(SupplierTransactionEntity(
              supplierId: supId,
              type: 'debit',
              amount: cashCost,
              description: Localizations.localeOf(context).languageCode == 'ar'
                  ? 'دفعة نقدية لشراء إضافة $kQty قطعة من ${nameCtrl.text.trim()}'
                  : 'Cash paid for addon $kQty of ${nameCtrl.text.trim()}',
              createdAt: DateTime.now(),
            ));
          }
        }
        if (context.mounted) Navigator.pop(context);
      } else {
        if (context.mounted) ErrorDialog.show(context, message: error);
      }
    }
  }

  // UI Helpers to keep things clean
  Widget _buildAddonLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  InputDecoration _buildAddonInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: isDark ? Colors.grey.shade500 : Colors.grey),
      prefixIcon: Icon(icon, color: context.primaryColor),
      filled: true,
      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: isDark ? const BorderSide(color: Color(0xFF3C3C3C)) : BorderSide.none,
      ),
    );
  }

  // --- EXPORT UI ---

  void _showExportOptions(
    BuildContext context,
    List<dynamic> items,
    int activeIndex,
  ) {
    // 1. Match your 3-tab logic for data generation
    final csvData = CatalogService.generateCsvString(items, activeIndex);

    // 2. Dynamic naming based on the active index
    final fileName = activeIndex == 0
        ? FileNaming.generateFileName('products')
        : activeIndex == 1
        ? FileNaming.generateFileName('addons')
        : FileNaming.generateFileName('categories');

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      routeSettings: const RouteSettings(name: 'ExportOptionsSheet'),
      backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
          bottom: 32,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).exportOptions,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 20),

            // Option 1: Internal App Storage
            _exportTile(
              icon: Icons.folder_special,
              color: context.primaryColor,
              title: AppLocalizations.of(context).saveToDefault,
              subtitle: Platform.isAndroid
                  ? "Android/data/.../files/exports/$fileName"
                  : "Documents/${AppStrings.appFolder}/exports/$fileName",
              onTap: () async {
                final p = await CatalogService.saveToDefaultDir(
                  csvData,
                  fileName,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
                Toaster.show(AppLocalizations.of(context).savedTo(p));
              },
            ),

            // Option 2: System File Picker
            _exportTile(
              icon: Icons.create_new_folder,
              color: Colors.blue,
              title: AppLocalizations.of(context).selectLocation,
              subtitle: AppLocalizations.of(context).chooseFolder,
              onTap: () async {
                final p = await CatalogService.saveToCustomDir(
                  csvData,
                  fileName,
                );
                if (!context.mounted) return;
                Navigator.pop(context);
                if (p != null) {
                  Toaster.show(AppLocalizations.of(context).savedSuccessfully);
                }
              },
            ),

            // Option 3: Share (WhatsApp, Email, etc.)
            _exportTile(
              icon: Icons.share,
              color: Colors.green,
              title: AppLocalizations.of(context).shareCsv,
              subtitle: AppLocalizations.of(context).whatsappEmail,
              onTap: () async {
                // Note: Pop first so the sheet doesn't block the share intent
                Navigator.pop(context);
                await CatalogService.shareCsv(csvData, fileName);
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper to open the edit form for a single product
  void _editSingleProduct(ProductEntity product) {
    // Reuse your existing showProductForm but pass the product to edit
    showProductForm(context, ref, product: product);
  }

  // Helper to open the edit form for a single addon
  void _editSingleAddon(AddEntity addon) {
    showAddonForm(context, ref, addon: addon);
  }

  void _editSingleCategory(CategoryEntity category) {
    showCategoryForm(context, ref, category: category);
  }

  Widget _exportTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: color.withAlpha(26),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.withAlpha(26)),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withAlpha(26),
                child: Icon(icon, color: color),
              ),
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
              trailing: const Icon(Icons.chevron_right, size: 18),
            ),
          ),
        ),
      ),
    );
  }

  void _selectAll(int activeIndex) {
    setState(() {
      if (activeIndex == 0) {
        final items = ref.read(productNotifierProvider).value ?? [];
        _selectedProductIds.length == items.length
            ? _selectedProductIds.clear()
            : _selectedProductIds.addAll(items.map((e) => e.id!));
      } else if (activeIndex == 1) {
        final items = ref.read(addonNotifierProvider).value ?? [];
        _selectedAddonIds.length == items.length
            ? _selectedAddonIds.clear()
            : _selectedAddonIds.addAll(items.map((e) => e.id!));
      } else {
        final items = ref.read(categoryNotifierProvider).value ?? [];
        _selectedCategoryIds.length == items.length
            ? _selectedCategoryIds.clear()
            : _selectedCategoryIds.addAll(items.map((e) => e.id!));
      }
    });
  }
}
