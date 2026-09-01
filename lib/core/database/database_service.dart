import 'dart:async';
import 'package:buffet_app/core/constants/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:buffet_app/core/utils/app_logger.dart';

class DatabaseService {
  late Database db;
  Completer<void>? _initCompleter;

  Future<void> init() async {
    if (_initCompleter != null) {
      return _initCompleter!.future;
    }

    _initCompleter = Completer<void>();
    
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, AppStrings.dbName);

      // Level: Info - Essential for verifying the physical file location on the device
      AppLogger.info("DatabaseService: Opening connection at $path");

      db = await openDatabase(
        path,
        version: 4,
        onConfigure: (db) async {
          try {
            await db.execute('PRAGMA foreign_keys = ON');
            // Level: Debug - Confirmation of internal SQLite settings
            AppLogger.debug("DatabaseService: Foreign keys enabled via PRAGMA.");
          } catch (e) {
            AppLogger.error("DatabaseService: Failed to enable foreign keys", e);
          }
        },
        onCreate: (db, version) async {
          // Level: Info - Critical for identifying if a user's data was wiped or reset
          AppLogger.info(
            "DatabaseService: Schema not found. Starting first-time setup (Version $version)...",
          );

          try {
            // 1. Categories Catalog
            await db.execute('''
            CREATE TABLE categories (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE
            );
            ''');

            // 2. Suppliers Catalog (Created before products/addons for foreign keys)
            await db.execute('''
            CREATE TABLE suppliers (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              phone TEXT,
              email TEXT,
              address TEXT,
              balance REAL DEFAULT 0.0
            );
            ''');

            // 3. Products Catalog
            await db.execute('''
            CREATE TABLE products (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE,
              base_price REAL NOT NULL,
              category_id INTEGER,
              supplier_id INTEGER,
              quantity INTEGER DEFAULT 0,
              FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE SET NULL,
              FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE SET NULL
            );
            ''');

            // 4. Adds Catalog
            await db.execute('''
              CREATE TABLE adds_catalog (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                base_price REAL DEFAULT 0.0,
                supplier_id INTEGER,
                quantity INTEGER DEFAULT 0,
                FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE SET NULL
              )
            ''');

            // 5. Orders
            await db.execute('''
              CREATE TABLE orders (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                total_price REAL NOT NULL,
                status INTEGER DEFAULT 0,
                customer_name TEXT,
                notes TEXT, 
                created_at TEXT NOT NULL
              )
            ''');

            // 6. Order Items
            await db.execute('''
              CREATE TABLE order_items (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                order_id INTEGER NOT NULL,
                product_id INTEGER NOT NULL,
                name_at_sale TEXT NOT NULL,
                price_at_sale REAL NOT NULL,
                quantity INTEGER NOT NULL DEFAULT 1,
                FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
              )
            ''');

            // 7. Order Item Adds
            await db.execute('''
              CREATE TABLE order_item_adds (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                order_item_id INTEGER NOT NULL,
                add_id INTEGER NOT NULL,
                name_at_sale TEXT NOT NULL,
                price_at_sale REAL NOT NULL,
                FOREIGN KEY (order_item_id) REFERENCES order_items (id) ON DELETE CASCADE
              )
            ''');

            // 8. Config table
            await db.execute('''
              CREATE TABLE configs (
                key TEXT PRIMARY KEY,
                value TEXT
              )
            ''');

            // 9. Users table
            await db.execute('''
              CREATE TABLE users (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                full_name TEXT NOT NULL,
                phone_number TEXT NOT NULL,
                country_code TEXT NOT NULL,
                email TEXT NOT NULL UNIQUE,
                password TEXT NOT NULL
              );
            ''');

            // 10. Supplier Transactions table (Ledger)
            await db.execute('''
              CREATE TABLE supplier_transactions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                supplier_id INTEGER NOT NULL,
                type TEXT NOT NULL,
                amount REAL NOT NULL,
                description TEXT,
                created_at TEXT NOT NULL,
                FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE CASCADE
              );
            ''');

            AppLogger.info("DatabaseService: All tables created successfully.");
          } catch (e, stack) {
            AppLogger.error("DatabaseService: FAILED to create tables", e, stack);
            rethrow;
          }
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          AppLogger.info("DatabaseService: Upgrading schema from $oldVersion to $newVersion...");
          if (oldVersion < 2) {
            try {
              await db.execute('''
                CREATE TABLE IF NOT EXISTS users (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  full_name TEXT NOT NULL,
                  phone_number TEXT NOT NULL,
                  country_code TEXT NOT NULL,
                  email TEXT NOT NULL UNIQUE,
                  password TEXT NOT NULL
                );
              ''');
              AppLogger.info("DatabaseService: Created table 'users' successfully during upgrade.");
            } catch (e, stack) {
              AppLogger.error("DatabaseService: FAILED to upgrade to version 2", e, stack);
              rethrow;
            }
          }
          if (oldVersion < 3) {
            try {
              // 1. Create suppliers table
              await db.execute('''
                CREATE TABLE IF NOT EXISTS suppliers (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  name TEXT NOT NULL,
                  phone TEXT,
                  email TEXT,
                  address TEXT,
                  balance REAL DEFAULT 0.0
                );
              ''');

              // 2. Create supplier_transactions table
              await db.execute('''
                CREATE TABLE IF NOT EXISTS supplier_transactions (
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  supplier_id INTEGER NOT NULL,
                  type TEXT NOT NULL,
                  amount REAL NOT NULL,
                  description TEXT,
                  created_at TEXT NOT NULL,
                  FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE CASCADE
                );
              ''');

              // 3. Add supplier_id column to products and adds_catalog
              await db.execute('ALTER TABLE products ADD COLUMN supplier_id INTEGER REFERENCES suppliers(id) ON DELETE SET NULL;');
              await db.execute('ALTER TABLE adds_catalog ADD COLUMN supplier_id INTEGER REFERENCES suppliers(id) ON DELETE SET NULL;');
              
              AppLogger.info("DatabaseService: Upgraded to version 3 successfully.");
            } catch (e, stack) {
              AppLogger.error("DatabaseService: FAILED to upgrade to version 3", e, stack);
              rethrow;
            }
          }
          if (oldVersion < 4) {
            try {
              await db.execute('ALTER TABLE products ADD COLUMN quantity INTEGER DEFAULT 0;');
              await db.execute('ALTER TABLE adds_catalog ADD COLUMN quantity INTEGER DEFAULT 0;');
              AppLogger.info("DatabaseService: Upgraded to version 4 successfully.");
            } catch (e, stack) {
              AppLogger.error("DatabaseService: FAILED to upgrade to version 4", e, stack);
              rethrow;
            }
          }
        },
      );

      AppLogger.info("DatabaseService: Initialization complete.");
      _initCompleter!.complete();
    } catch (e, stack) {
      _initCompleter!.completeError(e, stack);
      AppLogger.error(
        "DatabaseService: CRITICAL FAILURE during initialization",
        e,
        stack,
      );
      rethrow;
    }
  }
}

final databaseServiceProvider = Provider<DatabaseService>((ref) => DatabaseService());
