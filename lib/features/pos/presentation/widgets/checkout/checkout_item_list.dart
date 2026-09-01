import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/cart_providers.dart';
import 'checkout_item_row.dart';

class CheckoutItemList extends ConsumerWidget {
  const CheckoutItemList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        itemCount: cartItems.length,
        separatorBuilder: (_, __) => Divider(color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200),
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return CheckoutItemRow(item: item);
        },
      ),
    );
  }
}
