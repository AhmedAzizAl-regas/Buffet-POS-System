import 'package:buffet_app/core/utils/format_extensions.dart';
import 'package:buffet_app/features/catalog/domain/entities/add_entity.dart';
import 'package:buffet_app/features/catalog/domain/entities/product_entity.dart';
import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';
import 'package:buffet_app/features/pos/presentation/providers/cart_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../../catalog/presentation/providers/catalog_providers.dart';
import 'package:buffet_app/core/utils/toaster.dart';

class CustomizationSheet extends ConsumerStatefulWidget {
  final ProductEntity product;
  final CartItem? existingItem;
  final int? itemIndex;
  const CustomizationSheet({
    super.key,
    required this.product,
    this.existingItem,
    this.itemIndex,
  });

  @override
  ConsumerState<CustomizationSheet> createState() => CustomizationSheetState();
}

class CustomizationSheetState extends ConsumerState<CustomizationSheet> {
  late int localQty;
  late List<AddEntity> selectedAddons;

  @override
  void initState() {
    super.initState();
    localQty = widget.existingItem?.quantity ?? 1;
    selectedAddons = widget.existingItem != null
        ? List.from(widget.existingItem!.selectedAddons)
        : [];
  }

  @override
  Widget build(BuildContext context) {
    final addonsAsync = ref.watch(addonNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existingItem == null
                ? AppLocalizations.of(context).addProductName(widget.product.name)
                : AppLocalizations.of(context).editProductName(widget.product.name),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // ── Product Stock Badge ──
          Builder(builder: (context) {
            final qty = widget.product.quantity;
            final isAr = Localizations.localeOf(context).languageCode == 'ar';
            final color = qty == 0
                ? Colors.red
                : (qty <= 3 ? Colors.orange : Colors.green);
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withAlpha(22),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withAlpha(100)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    qty == 0 ? Icons.remove_circle_outline : Icons.inventory_2_outlined,
                    size: 14,
                    color: color,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAr ? 'الكمية المتبقية: $qty' : 'Stock remaining: $qty',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).quantity,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => setState(() => localQty > 1 ? localQty-- : 1),
                      icon: Icon(
                        Icons.remove,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                    Text(
                      localQty.toLocalNum(ref),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (localQty >= widget.product.quantity) {
                          Toaster.show(
                            Localizations.localeOf(context).languageCode == 'ar'
                                ? 'نفذت الكمية، اطلبها من المورد من جديد'
                                : 'Out of stock, order it from the supplier again',
                            isError: true,
                          );
                        } else {
                          setState(() => localQty++);
                        }
                      },
                      icon: Icon(
                        Icons.add,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(
            height: 32,
            color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade200,
          ),
          Text(
            AppLocalizations.of(context).addons,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.grey.shade400 : Colors.blueGrey,
            ),
          ),
          addonsAsync.when(
            data: (addons) => Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: addons.length,
                itemBuilder: (context, i) {
                  final addon = addons[i];
                  final isChecked = selectedAddons.any((a) => a.id == addon.id);
                  final addonCount = selectedAddons.where((a) => a.id == addon.id).length;

                  // Stock badge color logic
                  final stockColor = addon.quantity == 0
                      ? Colors.red
                      : (addon.quantity <= 3 ? Colors.orange : Colors.green);
                  final isAr = Localizations.localeOf(context).languageCode == 'ar';

                  return Column(
                    children: [
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.orange,
                        checkColor: Colors.white,
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                addon.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // ── Stock Badge ──
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: stockColor.withAlpha(22),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: stockColor.withAlpha(100)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    addon.quantity == 0
                                        ? Icons.remove_circle_outline
                                        : Icons.inventory_2_outlined,
                                    size: 12,
                                    color: stockColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    isAr
                                        ? 'متبقي: ${addon.quantity}'
                                        : 'Stock: ${addon.quantity}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: stockColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        subtitle: addon.basePrice > 0
                            ? Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context).addonPrefix(""),
                                    style: TextStyle(
                                      color: isDark ? Colors.grey.shade400 : Colors.black54,
                                    ),
                                  ),
                                  addon.basePrice.toPriceWidget(ref),
                                ],
                              )
                            : Text(
                                AppLocalizations.of(context).free,
                                style: TextStyle(
                                  color: isDark ? Colors.grey.shade400 : Colors.black54,
                                ),
                              ),
                        value: isChecked,
                        onChanged: (val) {
                          if (val!) {
                            if (addon.quantity <= 0) {
                              Toaster.show(
                                Localizations.localeOf(context).languageCode == 'ar'
                                    ? 'نفذت الكمية، اطلبها من المورد من جديد'
                                    : 'Out of stock, order it from the supplier again',
                                isError: true,
                              );
                              return;
                            }
                            setState(() {
                              selectedAddons.add(addon);
                            });
                          } else {
                            setState(() {
                              selectedAddons.removeWhere((a) => a.id == addon.id);
                            });
                          }
                        },
                      ),
                      if (isChecked)
                        Padding(
                          padding: const EdgeInsets.only(left: 36, right: 36, bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppLocalizations.of(context).quantity,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? Colors.grey.shade400 : Colors.blueGrey,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          final index = selectedAddons.indexWhere((a) => a.id == addon.id);
                                          if (index != -1) {
                                            selectedAddons.removeAt(index);
                                          }
                                        });
                                      },
                                      icon: Icon(
                                        Icons.remove,
                                        size: 18,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      "$addonCount",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (addonCount >= addon.quantity) {
                                          Toaster.show(
                                            Localizations.localeOf(context).languageCode == 'ar'
                                                ? 'نفذت الكمية، اطلبها من المورد من جديد'
                                                : 'Out of stock, order it from the supplier again',
                                            isError: true,
                                          );
                                        } else {
                                          setState(() {
                                            selectedAddons.add(addon);
                                          });
                                        }
                                      },
                                      icon: Icon(
                                        Icons.add,
                                        size: 18,
                                        color: isDark ? Colors.white70 : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(AppLocalizations.of(context).errorLoadingAddons),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (widget.itemIndex != null) {
                  ref
                      .read(cartProvider.notifier)
                      .updateItem(widget.itemIndex!, localQty, selectedAddons);
                } else {
                  ref
                      .read(cartProvider.notifier)
                      .addToCart(widget.product, selectedAddons, localQty);
                }
                Navigator.pop(context);
              },
              child: Text(
                widget.existingItem == null
                    ? AppLocalizations.of(context).addToOrder
                    : AppLocalizations.of(context).updateItem,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
