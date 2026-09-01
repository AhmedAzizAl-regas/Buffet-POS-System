import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:sqflite/sqflite.dart';

import 'package:buffet_app/core/database/database_service.dart';
import 'package:buffet_app/core/utils/app_logger.dart'; // Ensure this import is correct

class OrderRepository {
  final DatabaseService _service;

  OrderRepository(this._service);

  /// Helper to decrement stock for list of CartItems
  Future<void> _deductStock(Transaction txn, List<CartItem> cartItems) async {
    for (var item in cartItems) {
      if (item.product.id != null) {
        await txn.rawUpdate(
          'UPDATE products SET quantity = MAX(0, quantity - ?) WHERE id = ?',
          [item.quantity, item.product.id],
        );
      }
      for (var add in item.selectedAddons) {
        if (add.id != null) {
          await txn.rawUpdate(
            'UPDATE adds_catalog SET quantity = MAX(0, quantity - 1) WHERE id = ?',
            [add.id],
          );
        }
      }
    }
  }

  /// Helper to restore stock for a specific order ID before it's deleted/modified
  Future<void> _restoreStockForOrder(Transaction txn, int orderId) async {
    final List<Map<String, dynamic>> items = await txn.query(
      'order_items',
      where: 'order_id = ?',
      whereArgs: [orderId],
    );

    for (var item in items) {
      final int? productId = item['product_id'] as int?;
      final int qty = item['quantity'] as int;
      final int orderItemId = item['id'] as int;

      if (productId != null) {
        await txn.rawUpdate(
          'UPDATE products SET quantity = quantity + ? WHERE id = ?',
          [qty, productId],
        );
      }

      final List<Map<String, dynamic>> adds = await txn.query(
        'order_item_adds',
        where: 'order_item_id = ?',
        whereArgs: [orderItemId],
      );

      for (var add in adds) {
        final int? addonId = add['add_id'] as int?;
        if (addonId != null) {
          await txn.rawUpdate(
            'UPDATE adds_catalog SET quantity = quantity + 1 WHERE id = ?',
            [addonId],
          );
        }
      }
    }
  }

  /// Saves a new cart to the database and returns the generated Order ID.
  Future<int> saveCompleteOrder({
    required double totalPrice,
    String? customerName,
    String? notes,
    required List<CartItem> cartItems,
    int status = 0,
  }) async {
    final db = _service.db;

    try {
      AppLogger.info("OrderRepo: Initiating save for new order (Total: $totalPrice)");

      return await db.transaction((txn) async {
        // 1. Insert the main Order record
        int orderId = await txn.insert('orders', {
          'total_price': totalPrice,
          'customer_name': customerName ?? 'Walk-in',
          'notes': notes ?? '',
          'status': status,
          'created_at': DateTime.now().toIso8601String(),
        });

        // 2. Loop through Cart Items
        for (var item in cartItems) {
          int orderItemId = await txn.insert('order_items', {
            'order_id': orderId,
            'product_id': item.product.id,
            'name_at_sale': item.product.name,
            'price_at_sale': item.product.basePrice,
            'quantity': item.quantity,
          });

          // 3. Loop through Addons
          for (var add in item.selectedAddons) {
            await txn.insert('order_item_adds', {
              'order_item_id': orderItemId,
              'add_id': add.id,
              'name_at_sale': add.name,
              'price_at_sale': add.basePrice,
            });
          }
        }

        // 4. Deduct stock for the items
        await _deductStock(txn, cartItems);

        AppLogger.info(
          "OrderRepo: Order #$orderId saved successfully with ${cartItems.length} items.",
        );
        return orderId;
      });
    } catch (e, stack) {
      AppLogger.error("OrderRepo: Failed to save complete order", e, stack);
      rethrow;
    }
  }

  /// Updates order status (e.g., 0 for Pending, 1 for Served)
  Future<void> updateOrderStatus(int orderId, int newStatus) async {
    try {
      final db = _service.db;
      await db.update(
        'orders',
        {'status': newStatus},
        where: 'id = ?',
        whereArgs: [orderId],
      );
      AppLogger.info("OrderRepo: Order #$orderId status changed to $newStatus");
    } catch (e) {
      AppLogger.error("OrderRepo: Failed to update status for Order #$orderId", e);
    }
  }

  /// Fetches a list of all orders for the summary view
  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final db = _service.db;
      AppLogger.debug("OrderRepo: Fetching all orders summary.");
      return await db.query('orders', orderBy: 'status ASC, created_at DESC');
    } catch (e) {
      AppLogger.error("OrderRepo: Failed to fetch all orders", e);
      return [];
    }
  }

  /// Fetches full structure (Items + Addons) for a specific order.
  Future<List<Map<String, dynamic>>> getOrderFullDetails(int orderId) async {
    try {
      final db = _service.db;
      AppLogger.debug("OrderRepo: Building full details for Order #$orderId");

      final List<Map<String, dynamic>> items = await db.query(
        'order_items',
        where: 'order_id = ?',
        whereArgs: [orderId],
      );

      List<Map<String, dynamic>> completeItems = [];

      for (var item in items) {
        final List<Map<String, dynamic>> adds = await db.query(
          'order_item_adds',
          where: 'order_item_id = ?',
          whereArgs: [item['id']],
        );
        completeItems.add({...item, 'addons': adds});
      }

      return completeItems;
    } catch (e, stack) {
      AppLogger.error(
        "OrderRepo: Error retrieving details for Order #$orderId",
        e,
        stack,
      );
      return [];
    }
  }

  /// Deletes a single order
  Future<void> deleteOrder(int orderId) async {
    try {
      final db = _service.db;
      await db.transaction((txn) async {
        await _restoreStockForOrder(txn, orderId);
        await txn.delete('orders', where: 'id = ?', whereArgs: [orderId]);
      });
      AppLogger.warning("OrderRepo: DELETED Order #$orderId");
    } catch (e) {
      AppLogger.error("OrderRepo: Failed to delete Order #$orderId", e);
    }
  }

  /// Deletes multiple orders at once (Bulk Delete)
  Future<void> deleteMultipleOrders(List<int> ids) async {
    if (ids.isEmpty) return;
    try {
      final db = _service.db;
      await db.transaction((txn) async {
        for (var orderId in ids) {
          await _restoreStockForOrder(txn, orderId);
        }
        final placeholders = List.filled(ids.length, '?').join(',');
        await txn.delete(
          'orders',
          where: 'id IN ($placeholders)',
          whereArgs: ids,
        );
      });
      AppLogger.warning("OrderRepo: Bulk deleted orders with IDs: $ids");
    } catch (e) {
      AppLogger.error("OrderRepo: Failed bulk deletion", e);
    }
  }

  /// Updates an existing order (Clears old items and re-inserts new ones)
  Future<void> updateExistingOrder({
    required int orderId,
    required double totalPrice,
    required List<CartItem> cartItems,
    String? customerName,
    String? notes,
    int status = 0,
  }) async {
    final db = _service.db;

    try {
      AppLogger.info("OrderRepo: Updating Order #$orderId (New Total: $totalPrice)");

      await db.transaction((txn) async {
        // 1. Restore old stock before deleting old items
        await _restoreStockForOrder(txn, orderId);

        // 2. Update main order details
        await txn.update(
          'orders',
          {
            'total_price': totalPrice,
            'customer_name': customerName,
            'notes': notes,
            'status': status,
          },
          where: 'id = ?',
          whereArgs: [orderId],
        );

        // 3. Delete old items (Foreign Key cascade will handle addons)
        await txn.delete('order_items', where: 'order_id = ?', whereArgs: [orderId]);

        // 4. Re-insert new items from cart
        for (var item in cartItems) {
          final itemId = await txn.insert('order_items', {
            'order_id': orderId,
            'product_id': item.product.id,
            'name_at_sale': item.product.name,
            'price_at_sale': item.product.basePrice,
            'quantity': item.quantity,
          });

          for (var addon in item.selectedAddons) {
            await txn.insert('order_item_adds', {
              'order_item_id': itemId,
              'add_id': addon.id,
              'name_at_sale': addon.name,
              'price_at_sale': addon.basePrice,
            });
          }
        }

        // 5. Deduct new stock
        await _deductStock(txn, cartItems);
      });
      AppLogger.info("OrderRepo: Order #$orderId updated successfully.");
    } catch (e, stack) {
      AppLogger.error("OrderRepo: Failed to update Order #$orderId", e, stack);
      rethrow;
    }
  }

  /// Shortcut to mark an order as Served (status 1)
  Future<void> markAsServed(int orderId) async {
    AppLogger.info("OrderRepo: Marking Order #$orderId as SERVED.");
    await updateOrderStatus(orderId, 1);
  }
}
