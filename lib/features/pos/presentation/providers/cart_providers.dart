import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/providers/config_provider.dart';
import 'cart_notifiers.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

final cartTotalProvider = Provider<double>((ref) {
  // .watch ensures this provider re-calculates every time the cart list changes
  final cartItems = ref.watch(cartProvider);

  // Calculate the total based on the watched list
  return cartItems.fold(0, (sum, item) => sum + item.totalRowPrice);
});

final isGridLayoutProvider = Provider<bool>((ref) {
  return true;
});
