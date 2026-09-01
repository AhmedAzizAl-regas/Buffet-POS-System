import 'dart:async';
import 'package:buffet_app/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';
import 'package:buffet_app/features/suppliers/data/supplier_database_service.dart';

class SupplierNotifier extends AsyncNotifier<List<SupplierEntity>> {
  @override
  FutureOr<List<SupplierEntity>> build() async {
    final db = ref.watch(supplierDatabaseServiceProvider);
    return await db.getAllSuppliers();
  }

  Future<void> addSupplier(SupplierEntity supplier) async {
    final db = ref.read(supplierDatabaseServiceProvider);
    await db.insertSupplier(supplier);
    ref.invalidateSelf();
  }

  Future<void> updateSupplier(SupplierEntity supplier) async {
    final db = ref.read(supplierDatabaseServiceProvider);
    await db.updateSupplier(supplier);
    ref.invalidateSelf();
  }

  Future<void> deleteSupplier(int id) async {
    final db = ref.read(supplierDatabaseServiceProvider);
    await db.deleteSupplier(id);
    ref.invalidateSelf();
    
    // Invalidate product and addon notifier providers so their supplier reference updates
    ref.invalidate(productNotifierProvider);
    ref.invalidate(addonNotifierProvider);
  }

  Future<void> addSupplierTransaction(SupplierTransactionEntity txn) async {
    final db = ref.read(supplierDatabaseServiceProvider);
    await db.addTransaction(txn);
    
    ref.invalidateSelf(); // Refresh suppliers list to update balance
    ref.invalidate(supplierTransactionsProvider(txn.supplierId)); // Refresh transaction list
    ref.invalidate(dailyAccountsStatsProvider); // Invalidate daily summary stats
    ref.invalidate(dailySupplierTransactionsProvider); // Invalidate daily transactions list
  }
}

// --- PROVIDERS ---

final supplierNotifierProvider =
    AsyncNotifierProvider<SupplierNotifier, List<SupplierEntity>>(SupplierNotifier.new);

/// Provider to fetch transactions for a specific supplier
final supplierTransactionsProvider = FutureProvider.family.autoDispose<List<SupplierTransactionEntity>, int>((ref, supplierId) async {
  final db = ref.watch(supplierDatabaseServiceProvider);
  return await db.getTransactionsForSupplier(supplierId);
});

/// Provider to fetch products linked to a specific supplier
final supplierProductsProvider = FutureProvider.family.autoDispose<List<Map<String, dynamic>>, int>((ref, supplierId) async {
  final db = ref.watch(supplierDatabaseServiceProvider);
  return await db.getProductsForSupplier(supplierId);
});

/// Provider to fetch addons linked to a specific supplier
final supplierAddonsProvider = FutureProvider.family.autoDispose<List<Map<String, dynamic>>, int>((ref, supplierId) async {
  final db = ref.watch(supplierDatabaseServiceProvider);
  return await db.getAddonsForSupplier(supplierId);
});

/// Provider to get daily accounts statistics (Sales, Credit, Debit)
final selectedAccountsDateProvider = StateProvider<String>((ref) {
  // Defaults to today's date formatted as YYYY-MM-DD
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
});

final dailyAccountsStatsProvider = FutureProvider.autoDispose<Map<String, double>>((ref) async {
  final db = ref.watch(supplierDatabaseServiceProvider);
  final dateStr = ref.watch(selectedAccountsDateProvider);
  return await db.getDailyAccountsStats(dateStr);
});

final dailySupplierTransactionsProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  final db = ref.watch(supplierDatabaseServiceProvider);
  final dateStr = ref.watch(selectedAccountsDateProvider);
  return await db.getDailySupplierTransactions(dateStr);
});
