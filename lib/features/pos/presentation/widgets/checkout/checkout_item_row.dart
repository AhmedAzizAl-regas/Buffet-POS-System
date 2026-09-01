import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../generated/l10n.dart';
import '../../../domain/entities/cart_item.dart';

class CheckoutItemRow extends ConsumerWidget {
  final CartItem item;

  const CheckoutItemRow({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = TextStyle(
      fontSize: 12,
      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Main Product Row ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  AppLocalizations.of(context).quantityLabel(
                    item.quantity.toLocalNum(ref),
                    item.product.name,
                  ),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              (item.product.basePrice * item.quantity).toPriceWidget(
                ref,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),

          // --- Addons List (Indented) ---
          if (item.selectedAddons.isNotEmpty)
            ...item.selectedAddons.map((addon) {
              return Padding(
                padding: const EdgeInsetsDirectional.only(
                  top: 4,
                  start: 16, // Indent addons to show hierarchy
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).addonPrefix(addon.name),
                        style: textStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Show "Free" or the calculated price
                    addon.basePrice == 0
                        ? Text(
                            AppLocalizations.of(context).free,
                            style: textStyle,
                          )
                        : addon.basePrice.toPriceWidget(
                            ref,
                            style: textStyle,
                          ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
