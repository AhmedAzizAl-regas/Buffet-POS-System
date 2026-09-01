import 'package:buffet_app/features/catalog/domain/entities/add_entity.dart';
import 'package:buffet_app/features/catalog/domain/entities/product_entity.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'package:buffet_app/core/utils/app_logger.dart';
import '../../domain/entities/cart_item.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart(ProductEntity product, List<AddEntity> addons, int qty) {
    // 1. Check if it already exists
    final existingItemIndex = state.indexWhere(
      (item) => item.isSameConfiguration(product.id!, addons.map((e) => e.id!).toList()),
    );

    if (existingItemIndex != -1) {
      // 2. Increase Quantity
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existingItemIndex)
            CartItem(
              product: state[i].product,
              selectedAddons: state[i].selectedAddons,
              quantity: state[i].quantity + qty,
            )
          else
            state[i],
      ];
      AppLogger.info(
        "Cart: Increased quantity for ${product.name} to ${state[existingItemIndex].quantity}",
      );
    } else {
      // 3. New combo
      state = [
        ...state,
        CartItem(product: product, selectedAddons: addons, quantity: qty),
      ];
      AppLogger.info("Cart: Added New Item - ${product.name} (Qty: $qty)");
    }
  }

  void removeItem(int index) {
    final removedItem = state[index];
    state = [...state..removeAt(index)];
    AppLogger.warning("Cart: Removed Item at index $index (${removedItem.product.name})");
  }

  void updateItem(int index, int newQty, List<AddEntity> newAddons) {
    final oldItem = state[index];
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          CartItem(product: state[i].product, selectedAddons: newAddons, quantity: newQty)
        else
          state[i],
    ];
    AppLogger.info(
      "Cart: Updated ${oldItem.product.name} - Qty: ${oldItem.quantity} -> $newQty",
    );
  }

  void clearCart() {
    AppLogger.warning("Cart: User manually cleared the entire cart.");
    state = [];
  }

  void loadExistingOrder(List<CartItem> items) {
    AppLogger.info("Cart: Loaded existing order with ${items.length} unique lines.");
    state = items;
  }

  double get cartTotal => state.fold(0, (sum, item) => sum + item.totalRowPrice);
  int get totalItemsCount => state.fold<int>(0, (sum, item) => sum + item.quantity);
}
