import 'package:buffet_app/core/database/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';

class SupplierDatabaseService {
  final DatabaseService _dbService;

  SupplierDatabaseService(this._dbService);

  // --- Supplier CRUD ---

  Future<List<SupplierEntity>> getAllSuppliers() async {
    final db = _dbService.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'suppliers',
      orderBy: 'name ASC',
    );
    return maps.map((map) => SupplierEntity.fromMap(map)).toList();
  }

  Future<int> insertSupplier(SupplierEntity supplier) async {
    final db = _dbService.db;
    return await db.insert('suppliers', supplier.toMap());
  }

  Future<int> updateSupplier(SupplierEntity supplier) async {
    final db = _dbService.db;
    return await db.update(
      'suppliers',
      supplier.toMap(),
      where: 'id = ?',
      whereArgs: [supplier.id],
    );
  }

  Future<int> deleteSupplier(int id) async {
    final db = _dbService.db;
    return await db.delete('suppliers', where: 'id = ?', whereArgs: [id]);
  }

  // --- Transactions / Ledger Operations ---

  Future<List<SupplierTransactionEntity>> getTransactionsForSupplier(int supplierId) async {
    final db = _dbService.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'supplier_transactions',
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => SupplierTransactionEntity.fromMap(map)).toList();
  }

  /// Inserts a transaction and updates the supplier's balance atomically in a transaction.
  Future<void> addTransaction(SupplierTransactionEntity transaction) async {
    final db = _dbService.db;

    await db.transaction((txn) async {
      // 1. Insert transaction
      await txn.insert('supplier_transactions', transaction.toMap());

      // 2. Fetch current balance
      final List<Map<String, dynamic>> supplierMap = await txn.query(
        'suppliers',
        columns: ['balance'],
        where: 'id = ?',
        whereArgs: [transaction.supplierId],
      );

      if (supplierMap.isNotEmpty) {
        final double currentBalance = (supplierMap.first['balance'] as num?)?.toDouble() ?? 0.0;
        
        // 3. Recalculate balance
        // Credit (دائن) increases we owe them (balance goes up)
        // Debit (مدين) means we paid them (balance goes down)
        final double newBalance = transaction.type == 'credit'
            ? currentBalance + transaction.amount
            : currentBalance - transaction.amount;

        // 4. Update supplier balance
        await txn.update(
          'suppliers',
          {'balance': newBalance},
          where: 'id = ?',
          whereArgs: [transaction.supplierId],
        );
      }
    });
  }

  /// Returns all products linked to a specific supplier
  Future<List<Map<String, dynamic>>> getProductsForSupplier(int supplierId) async {
    final db = _dbService.db;
    return await db.query(
      'products',
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
      orderBy: 'name ASC',
    );
  }

  /// Returns all addons linked to a specific supplier
  Future<List<Map<String, dynamic>>> getAddonsForSupplier(int supplierId) async {
    final db = _dbService.db;
    return await db.query(
      'adds_catalog',
      where: 'supplier_id = ?',
      whereArgs: [supplierId],
      orderBy: 'name ASC',
    );
  }

  // --- Financial Accounts summary (Daily) ---

  Future<Map<String, double>> getDailyAccountsStats(String dateStr) async {
    final db = _dbService.db;
    final datePattern = '$dateStr%';

    // 1. Get daily sales from orders table
    final List<Map<String, dynamic>> salesResult = await db.rawQuery('''
      SELECT SUM(total_price) as total_sales 
      FROM orders 
      WHERE created_at LIKE ?
    ''', [datePattern]);
    final double sales = (salesResult.first['total_sales'] as num?)?.toDouble() ?? 0.0;

    // 2. Get daily credit transactions (Purchases from suppliers on credit)
    final List<Map<String, dynamic>> creditResult = await db.rawQuery('''
      SELECT SUM(amount) as total_credit 
      FROM supplier_transactions 
      WHERE type = 'credit' AND created_at LIKE ?
    ''', [datePattern]);
    final double credit = (creditResult.first['total_credit'] as num?)?.toDouble() ?? 0.0;

    // 3. Get daily debit transactions (Cash payments made to suppliers)
    final List<Map<String, dynamic>> debitResult = await db.rawQuery('''
      SELECT SUM(amount) as total_debit 
      FROM supplier_transactions 
      WHERE type = 'debit' AND created_at LIKE ?
    ''', [datePattern]);
    final double debit = (debitResult.first['total_debit'] as num?)?.toDouble() ?? 0.0;

    return {
      'sales': sales,
      'credit': credit,
      'debit': debit,
    };
  }

  /// Fetches all transactions (both supplier ledger transactions and cash POS sales) recorded today for a unified ledger list.
  Future<List<Map<String, dynamic>>> getDailySupplierTransactions(String dateStr) async {
    final db = _dbService.db;
    final datePattern = '$dateStr%';

    // 1. Fetch supplier transactions
    final List<Map<String, dynamic>> supplierTxns = await db.rawQuery('''
      SELECT 
        t.id,
        t.supplier_id,
        t.type,
        t.amount,
        t.description,
        t.created_at,
        s.name as supplier_name 
      FROM supplier_transactions t 
      JOIN suppliers s ON t.supplier_id = s.id 
      WHERE t.created_at LIKE ? 
    ''', [datePattern]);

    // 2. Fetch completed POS orders as cash sales
    final List<Map<String, dynamic>> orders = await db.rawQuery('''
      SELECT 
        id,
        NULL as supplier_id,
        'sales' as type,
        total_price as amount,
        customer_name as description,
        created_at,
        'POS Sales' as supplier_name
      FROM orders 
      WHERE created_at LIKE ?
    ''', [datePattern]);

    // 3. Merge and sort descending
    final List<Map<String, dynamic>> merged = [];
    merged.addAll(supplierTxns);
    merged.addAll(orders);

    merged.sort((a, b) => b['created_at'].toString().compareTo(a['created_at'].toString()));
    return merged;
  }
}

final supplierDatabaseServiceProvider = Provider<SupplierDatabaseService>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return SupplierDatabaseService(dbService);
});
