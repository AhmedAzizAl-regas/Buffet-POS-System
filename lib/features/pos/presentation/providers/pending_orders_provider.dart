
import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:buffet_app/features/pos/domain/entities/paused_order.dart';
import 'package:flutter_riverpod/legacy.dart'; // Standard import

import 'package:buffet_app/core/utils/app_logger.dart';

// Update the State type to Map<String, PausedOrder>
class PendingOrdersNotifier extends StateNotifier<Map<String, PausedOrder>> {
  PendingOrdersNotifier() : super({});

  int _orderCounter = 1;

  void pauseOrder(String? customLabel, List<CartItem> currentCart) {
    if (currentCart.isEmpty) return;

    String finalLabel = (customLabel == null || customLabel.trim().isEmpty)
        ? "Order #$_orderCounter"
        : customLabel.trim();

    if (customLabel == null || customLabel.trim().isEmpty) {
      _orderCounter++;
    }

    // Check for duplicates and append time if needed
    if (state.containsKey(finalLabel)) {
      final now = DateTime.now();
      final time = "${now.hour}:${now.minute.toString().padLeft(2, '0')}";
      finalLabel = "$finalLabel ($time)";
    }

    // --- KEY CHANGE: Store PausedOrder with current timestamp ---
    state = {
      ...state,
      finalLabel: PausedOrder(items: List.from(currentCart), timestamp: DateTime.now()),
    };
    
    AppLogger.info("PendingOrders: Saved order to pending list with ${currentCart.length} item(s).");
  }

  void deletePending(String label) {
    if (state.containsKey(label)) {
      AppLogger.warning("PendingOrders: Deleted a pending order.");
    }
    state = Map<String, PausedOrder>.from(state)..remove(label);
  }
}

final pendingOrdersProvider =
    StateNotifierProvider<PendingOrdersNotifier, Map<String, PausedOrder>>((ref) {
      return PendingOrdersNotifier();
    });
//
// final pendingOrdersProvider =
//     StateNotifierProvider<PendingOrdersNotifier, Map<String, List<CartItem>>>((ref) {
//       return PendingOrdersNotifier();
//     });
