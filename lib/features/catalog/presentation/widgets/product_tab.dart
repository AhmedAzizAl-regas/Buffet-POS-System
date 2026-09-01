import 'package:buffet_app/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_empty_widget.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../../domain/entities/product_entity.dart';

class ProductTab extends ConsumerWidget {
  final Set<int> selectedIds;
  final Function(int) onToggle;
  final VoidCallback onAddPressed;
  final Function(ProductEntity)? onEdit; // <--- Add this
  const ProductTab({
    super.key,
    required this.selectedIds,
    required this.onToggle,
    required this.onAddPressed,
    this.onEdit,
  });

  @override
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Watch the filtered products instead of all products
    final productsAsync = ref.watch(filteredProductsProvider);
    final categoriesAsync = ref.watch(categoryNotifierProvider);
    final selectedCatId = ref.watch(selectedCategoryIdProvider);

    return Column(
      children: [
        // --- CATEGORY SELECTOR ---
        categoriesAsync.when(
          data: (categories) => Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length + 1, // +1 for "All"
              itemBuilder: (context, index) {
                final isAll = index == 0;
                final category = isAll ? null : categories[index - 1];
                final isSelected = isAll
                    ? selectedCatId == null
                    : selectedCatId == category?.id;

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(isAll ? AppLocalizations.of(context).all : category!.name),
                    selected: isSelected,
                    onSelected: (_) {
                      ref.read(selectedCategoryIdProvider.notifier).state = isAll
                          ? null
                          : category?.id;
                    },
                  ),
                );
              },
            ),
          ),
          loading: () => const SizedBox(height: 60),
          error: (_, _) => const SizedBox.shrink(),
        ),

        // --- PRODUCT LIST ---
        Expanded(
          child: productsAsync.when(
            data: (products) {
              if (products.isEmpty) {
                return CatalogEmptyState(
                  title: AppLocalizations.of(context).noProducts,
                  actionText: AppLocalizations.of(context).addProductsNow,
                  icon: Icons.inventory_2_outlined,
                  onActionTap: onAddPressed, // 3. Use it here
                );
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, i) {
                  final p = products[i];
                  return CatalogTile(
                    name: p.name,
                    basePrice: p.basePrice,
                    isSelected: selectedIds.contains(p.id),
                    subName: p.category != null
                        ? p.category!.name
                        : AppLocalizations.of(context).uncategorized,
                    isProduct: true,
                    icon: Icons.inventory_2_outlined,
                    onTap: () {
                      // ONLY toggle if the selection mode is already active
                      if (selectedIds.isNotEmpty) {
                        onToggle(p.id!);
                      } else {
                        if (onEdit != null) {
                          onEdit!(p);
                        }
                      }
                    },
                    onLongPress: () {
                      // ALWAYS toggle on long press to start the selection mode
                      onToggle(p.id!);
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
          ),
        ),
      ],
    );
  }
}
