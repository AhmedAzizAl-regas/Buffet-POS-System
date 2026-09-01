import 'package:sqflite/sqflite.dart';

import 'package:buffet_app/core/utils/app_logger.dart';
import '../models/add_model.dart';
import '../models/category_model.dart'; // Add this
import '../models/product_model.dart';

class CatalogLocalDataSource {
  final Database db;

  CatalogLocalDataSource(this.db);

  // --- Product Operations ---

  Future<List<ProductModel>> getProducts() async {
    AppLogger.debug("DB Query: Fetching products with categories and suppliers...");

    // Using rawQuery for the LEFT JOIN to populate the CategoryEntity and SupplierEntity inside the Product
    final List<Map<String, dynamic>> results = await db.rawQuery('''
      SELECT 
        p.*, 
        c.name AS category_name,
        s.name AS supplier_name
      FROM products p 
      LEFT JOIN categories c ON p.category_id = c.id
      LEFT JOIN suppliers s ON p.supplier_id = s.id
      ORDER BY p.name ASC
    ''');

    AppLogger.debug("DB Result: Found ${results.length} products.");
    return results.map((map) => ProductModel.fromMap(map)).toList();
  }

  Future<int> insertProduct(Map<String, dynamic> productMap) async {
    final id = await db.insert('products', productMap);
    AppLogger.debug("DB Insert: Product added with ID: $id");
    return id;
  }

  Future<int> updateProduct(Map<String, dynamic> productMap) async {
    final id = productMap['id'];
    final count = await db.update(
      'products',
      productMap,
      where: 'id = ?',
      whereArgs: [id],
    );
    return count;
  }

  Future<int> deleteProduct(int id) async {
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMultipleProducts(List<int> ids) async {
    final placeholders = List.filled(ids.length, '?').join(',');
    return await db.delete('products', where: 'id IN ($placeholders)', whereArgs: ids);
  }

  // --- Category Operations ---

  Future<List<CategoryModel>> getCategories() async {
    AppLogger.debug("DB Query: Fetching all categories...");
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      orderBy: 'name ASC',
    );
    return maps.map((map) => CategoryModel.fromMap(map)).toList();
  }

  Future<int> insertCategory(Map<String, dynamic> categoryMap) async {
    final id = await db.insert('categories', categoryMap);
    AppLogger.debug("DB Insert: Category '${categoryMap['name']}' added with ID: $id");
    return id;
  }

  Future<int> updateCategory(Map<String, dynamic> categoryMap) async {
    final id = categoryMap['id'];
    return await db.update('categories', categoryMap, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteCategory(int id) async {
    // Note: Due to ON DELETE SET NULL in DatabaseService,
    // products linked to this category will automatically become null.
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteManyCategories(List<int> ids) async {
    // This creates a string like (?, ?, ?) based on the number of IDs
    final placeholders = List.filled(ids.length, '?').join(',');

    await db.delete('categories', where: 'id IN ($placeholders)', whereArgs: ids);
  }

  Future<int> getOrCreateCategoryId(String name) async {
    final trimmedName = name.trim();

    // 1. Check if exists
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'LOWER(name) = ?',
      whereArgs: [trimmedName],
    );

    if (maps.isNotEmpty) {
      return maps.first['id'] as int;
    }

    // 2. Create new if not found
    return await db.insert('categories', {'name': trimmedName});
  }

  // --- Add-on Operations ---

  Future<List<AddModel>> getAdds() async {
    AppLogger.debug("DB Query: Fetching all add-ons with suppliers...");
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        a.*, 
        s.name AS supplier_name 
      FROM adds_catalog a 
      LEFT JOIN suppliers s ON a.supplier_id = s.id
      ORDER BY a.name ASC
    ''');
    return maps.map((map) => AddModel.fromMap(map)).toList();
  }

  Future<int> insertAddon(Map<String, dynamic> addMap) async {
    return await db.insert('adds_catalog', addMap);
  }

  Future<int> updateAddon(Map<String, dynamic> addonMap) async {
    return await db.update(
      'adds_catalog',
      addonMap,
      where: 'id = ?',
      whereArgs: [addonMap['id']],
    );
  }

  Future<int> deleteAddon(int id) async {
    return await db.delete('adds_catalog', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMultipleAddons(List<int> ids) async {
    final placeholders = List.filled(ids.length, '?').join(',');
    return await db.delete(
      'adds_catalog',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
  }
}
