import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:buffet_app/core/constants/app_routes.dart';
import 'package:buffet_app/core/utils/print_helper.dart';
import 'package:buffet_app/core/utils/toaster.dart';
import 'package:buffet_app/core/widgets/confirm_dialog.dart';
import 'package:buffet_app/generated/l10n.dart';
import '../../domain/entities/supplier_entity.dart';
import '../providers/supplier_providers.dart';
import 'package:buffet_app/core/utils/format_extensions.dart';

/// Shows the main Suppliers & Accounts quick actions menu as a bottom sheet.
void showSuppliersAccountsPopup(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    routeSettings: const RouteSettings(name: 'QuickActionsSheet'),
    builder: (context) {
      final theme = Theme.of(context);
      final isDark = theme.brightness == Brightness.dark;
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Notch/Drag Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isArabic ? 'الوصول السريع' : 'Quick Access',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Suppliers Button
                _buildQuickActionItem(
                  context,
                  icon: Icons.people_alt_rounded,
                  label: isArabic ? 'الموردين' : 'Suppliers',
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.suppliers.path);
                  },
                ),
                // Accounts Button
                _buildQuickActionItem(
                  context,
                  icon: Icons.analytics_rounded,
                  label: isArabic ? 'الحسابات' : 'Accounts',
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.accounts.path);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Widget _buildQuickActionItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: 120,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.12 : 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.2),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    ),
  );
}

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'إدارة الموردين' : 'Manage Suppliers'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: const SuppliersTabContent(),
    );
  }
}

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        title: Text(isArabic ? 'الحسابات اليومية' : 'Daily Accounts'),
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: const AccountsTabContent(),
    );
  }
}

// ==========================================
// 1. SUPPLIERS TAB CONTENT
// ==========================================
class SuppliersTabContent extends ConsumerWidget {
  const SuppliersTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(supplierNotifierProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: suppliersAsync.when(
        data: (suppliers) {
          if (suppliers.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_center_outlined,
                    size: 64,
                    color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noSupplier,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: suppliers.length,
            itemBuilder: (context, index) {
              final supplier = suppliers[index];
              final balance = supplier.balance;

              // Design the balance badge
              Color balanceColor = Colors.grey;
              if (balance > 0) {
                balanceColor = Colors.orange.shade800;
              } else if (balance < 0) {
                balanceColor = Colors.green.shade800;
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
                color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                            child: Text(
                              supplier.name.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  supplier.name,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                if (supplier.phone != null && supplier.phone!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    supplier.phone!,
                                    style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontSize: 13),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          // Balance badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: balanceColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  balance > 0
                                      ? "${l10n.credit}: "
                                      : (balance < 0 ? "${l10n.debit}: " : ""),
                                  style: TextStyle(
                                    color: balanceColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                balance.abs().toPriceWidget(
                                  ref,
                                  style: TextStyle(
                                    color: balanceColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      // Actions row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () => _showSupplierDetails(context, ref, supplier),
                            icon: const Icon(Icons.receipt_long_outlined, size: 18),
                            label: Text(l10n.ledger),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () => _showSupplierForm(context, ref, supplier: supplier),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                            onPressed: () => _confirmDeleteSupplier(context, ref, supplier),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSupplierForm(context, ref),
        backgroundColor: theme.colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- ACTIONS ---

  void _showSupplierForm(BuildContext context, WidgetRef ref, {SupplierEntity? supplier}) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: supplier?.name);
    final phoneController = TextEditingController(text: supplier?.phone);
    final emailController = TextEditingController(text: supplier?.email);
    final addressController = TextEditingController(text: supplier?.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(supplier == null ? l10n.addSupplier : l10n.editSupplier),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: l10n.supplierName,
                    prefixIcon: const Icon(Icons.business_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) => (v == null || v.isEmpty) ? l10n.fieldRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: l10n.phoneNumber,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: l10n.address,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newSupplier = SupplierEntity(
                  id: supplier?.id,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  address: addressController.text.trim(),
                  balance: supplier?.balance ?? 0.0,
                );

                final notifier = ref.read(supplierNotifierProvider.notifier);
                if (supplier == null) {
                  await notifier.addSupplier(newSupplier);
                } else {
                  await notifier.updateSupplier(newSupplier);
                }
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSupplier(BuildContext context, WidgetRef ref, SupplierEntity supplier) {
    final l10n = AppLocalizations.of(context);
    ConfirmDialog.show(
      context: context,
      title: l10n.deleteItems,
      message: "${l10n.deleteWarning(1)}\n(${supplier.name})",
      onConfirm: () async {
        Navigator.pop(context); // Close dialog
        await ref.read(supplierNotifierProvider.notifier).deleteSupplier(supplier.id!);
        Toaster.show(l10n.deletedSuccessfully);
      },
    );
  }

  void _showSupplierDetails(BuildContext context, WidgetRef ref, SupplierEntity supplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SupplierDetailsSheet(supplier: supplier),
    );
  }
}

// ==========================================
// 1.1 SUPPLIER DETAILS SHEET
// ==========================================
class SupplierDetailsSheet extends ConsumerWidget {
  final SupplierEntity supplier;

  const SupplierDetailsSheet({super.key, required this.supplier});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final txnsAsync = ref.watch(supplierTransactionsProvider(supplier.id!));
    final productsAsync = ref.watch(supplierProductsProvider(supplier.id!));
    final addonsAsync = ref.watch(supplierAddonsProvider(supplier.id!));

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Drag handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: [
                        Text(
                          "${l10n.balance}: ",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        supplier.balance.toPriceWidget(
                          ref,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: supplier.balance >= 0 ? Colors.orange.shade800 : Colors.green.shade800,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),

          // Body: Tab details
          Expanded(
            child: DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  TabBar(
                    tabs: [
                      Tab(text: l10n.ledger),
                      Tab(text: l10n.linkedProducts),
                      Tab(text: l10n.linkedAddons),
                    ],
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    indicatorColor: theme.colorScheme.primary,
                    labelColor: theme.colorScheme.primary,
                    unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    dividerColor: Colors.transparent,
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // LEDGER TAB
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: theme.colorScheme.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      onPressed: () => _showTransactionForm(context, ref),
                                      icon: const Icon(Icons.add),
                                      label: Text(l10n.addTransaction),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: txnsAsync.when(
                                data: (txns) {
                                  if (txns.isEmpty) {
                                    return Center(child: Text(l10n.noTransactions));
                                  }
                                  return ListView.builder(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    itemCount: txns.length,
                                    itemBuilder: (context, index) {
                                      final txn = txns[index];
                                      final isCredit = txn.type == 'credit';

                                      return Card(
                                        elevation: 0,
                                        color: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade50,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          title: Text(
                                            txn.description ?? (isCredit ? l10n.creditPurchase : l10n.debitPayment),
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            txn.createdAt.toLocalDateTime(ref),
                                            style: const TextStyle(fontSize: 11),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                isCredit ? '+' : '-',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isCredit ? Colors.orange.shade800 : Colors.green.shade800,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              txn.amount.toPriceWidget(
                                                ref,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: isCredit ? Colors.orange.shade800 : Colors.green.shade800,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                loading: () => const Center(child: CircularProgressIndicator()),
                                error: (err, stack) => Center(child: Text(err.toString())),
                              ),
                            ),
                          ],
                        ),

                        // LINKED PRODUCTS
                        productsAsync.when(
                          data: (prods) {
                            if (prods.isEmpty) {
                              return Center(child: Text(l10n.noProducts));
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: prods.length,
                              itemBuilder: (context, index) {
                                final p = prods[index];
                                return ListTile(
                                  leading: const Icon(Icons.shopping_bag_outlined),
                                  title: Text(p['name'] ?? ''),
                                  trailing: (p['base_price'] as num).toPriceWidget(ref),
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text(err.toString())),
                        ),

                        // LINKED ADDONS
                        addonsAsync.when(
                          data: (adds) {
                            if (adds.isEmpty) {
                              return Center(child: Text(l10n.noAddons));
                            }
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: adds.length,
                              itemBuilder: (context, index) {
                                final a = adds[index];
                                return ListTile(
                                  leading: const Icon(Icons.add_circle_outline),
                                  title: Text(a['name'] ?? ''),
                                  trailing: (a['base_price'] as num).toPriceWidget(ref),
                                );
                              },
                            );
                          },
                          loading: () => const Center(child: CircularProgressIndicator()),
                          error: (err, stack) => Center(child: Text(err.toString())),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionForm(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();
    
    String txnType = 'credit'; // Defaults to credit (purchase)

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(l10n.addTransaction),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Type selector
                DropdownButtonFormField<String>(
                  value: txnType,
                  decoration: InputDecoration(
                    labelText: l10n.transactionType,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: [
                    DropdownMenuItem(value: 'credit', child: Text(l10n.creditPurchase)),
                    DropdownMenuItem(value: 'debit', child: Text(l10n.debitPayment)),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      setDialogState(() => txnType = v);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.amount,
                    prefixIcon: const Icon(Icons.payments_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return l10n.fieldRequired;
                    if (double.tryParse(v) == null) return l10n.invalid;
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    prefixIcon: const Icon(Icons.description_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final txn = SupplierTransactionEntity(
                    supplierId: supplier.id!,
                    type: txnType,
                    amount: double.parse(amountController.text),
                    description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                    createdAt: DateTime.now(),
                  );

                  await ref.read(supplierNotifierProvider.notifier).addSupplierTransaction(txn);
                  
                  // Pop both transaction form AND detail bottom sheet (which holds stale balance)
                  if (context.mounted) {
                    Navigator.pop(context); // Pop form dialog
                    Navigator.pop(context); // Pop details sheet
                  }
                  Toaster.show(l10n.savedSuccessfully);
                }
              },
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 2. ACCOUNTS TAB CONTENT
// ==========================================
class AccountsTabContent extends ConsumerWidget {
  const AccountsTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    final dateStr = ref.watch(selectedAccountsDateProvider);
    final statsAsync = ref.watch(dailyAccountsStatsProvider);
    final transactionsAsync = ref.watch(dailySupplierTransactionsProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Date Selector Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${l10n.date}: $dateStr",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  foregroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.parse(dateStr),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    final formattedDate =
                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                    ref.read(selectedAccountsDateProvider.notifier).state = formattedDate;
                  }
                },
                icon: const Icon(Icons.calendar_today, size: 16),
                label: Text(l10n.selectCountry), // Reuse Select label in Arabic or fallback
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dashboard stats cards
          statsAsync.when(
            data: (stats) {
              final sales = stats['sales'] ?? 0.0;
              final credit = stats['credit'] ?? 0.0;
              final debit = stats['debit'] ?? 0.0;
              final net = sales - credit;

              return Column(
                children: [
                  Row(
                    children: [
                      // Sales
                      Expanded(
                        child: _buildStatCard(
                          ref,
                          title: l10n.dailySales,
                          value: sales,
                          color: Colors.blue,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Net Profit
                      Expanded(
                        child: _buildStatCard(
                          ref,
                          title: l10n.netProfit,
                          value: net,
                          color: Colors.green,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // Credit purchases
                      Expanded(
                        child: _buildStatCard(
                          ref,
                          title: l10n.dailyCredit,
                          value: credit,
                          color: Colors.orange,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Debit payments
                      Expanded(
                        child: _buildStatCard(
                          ref,
                          title: l10n.dailyDebit,
                          value: debit,
                          color: Colors.red,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: LinearProgressIndicator()),
            error: (err, stack) => Container(),
          ),

          const SizedBox(height: 16),
          // Action export button
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(color: theme.colorScheme.primary),
                  ),
                  onPressed: () async {
                    final stats = await ref.read(dailyAccountsStatsProvider.future);
                    final txns = await ref.read(dailySupplierTransactionsProvider.future);
                    
                    if (context.mounted) {
                      await PrintHelper.printDailyAccountsReport(
                        context: context,
                        ref: ref,
                        dateStr: dateStr,
                        stats: stats,
                        transactions: txns,
                      );
                    }
                  },
                  icon: const Icon(Icons.print_outlined),
                  label: Text(l10n.printReport),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          // Daily ledger log list
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.ledger,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: transactionsAsync.when(
                    data: (txns) {
                      if (txns.isEmpty) {
                        return Center(child: Text(l10n.noTransactions));
                      }

                      return ListView.builder(
                        itemCount: txns.length,
                        itemBuilder: (context, index) {
                          final txn = txns[index];
                          final isCredit = txn['type'] == 'credit';
                          final isSales = txn['type'] == 'sales';

                          return Card(
                            elevation: 0,
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              title: Text(
                                isSales
                                    ? (isArabic ? 'مبيعات نقدية (الطلب #${txn['id']})' : 'Cash Sales (Order #${txn['id']})')
                                    : (txn['description'] ?? (isCredit ? l10n.creditPurchase : l10n.debitPayment)),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                isSales
                                    ? "${isArabic ? 'عميل' : 'Customer'}: ${txn['description'] ?? (isArabic ? 'سفري/طاولة' : 'Walk-in')} • ${DateTime.parse(txn['created_at']).toLocalTime(ref)}"
                                    : "${txn['supplier_name']} • ${DateTime.parse(txn['created_at']).toLocalTime(ref)}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isSales ? '+' : (isCredit ? '+' : '-'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSales
                                          ? Colors.blue.shade800
                                          : (isCredit ? Colors.orange.shade800 : Colors.green.shade800),
                                      fontSize: 15,
                                    ),
                                  ),
                                  (txn['amount'] as num).toPriceWidget(
                                    ref,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSales
                                          ? Colors.blue.shade800
                                          : (isCredit ? Colors.orange.shade800 : Colors.green.shade800),
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => Center(child: Text(err.toString())),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    WidgetRef ref, {
    required String title,
    required double value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(isDark ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color.withOpacity(0.85),
            ),
          ),
          const SizedBox(height: 8),
          value.toPriceWidget(
            ref,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
