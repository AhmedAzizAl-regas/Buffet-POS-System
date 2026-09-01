import 'package:buffet_app/features/catalog/domain/entities/category_entity.dart';
import 'package:buffet_app/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_empty_widget.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_tile.dart';
import 'package:buffet_app/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryTab extends ConsumerWidget {
  final Set<int> selectedIds;
  final Function(int) onToggle;
  final VoidCallback onAddPressed;
  final Function(CategoryEntity)? onEdit; // <--- Add this
  const CategoryTab({
    super.key,
    required this.selectedIds,
    required this.onToggle,
    required this.onAddPressed,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching the same notifier used for categories
    final categoriesAsync = ref.watch(categoryNotifierProvider);
    final productsAsync = ref.watch(productNotifierProvider);
    return Column(
      children: [
        // We keep the Column to match ProductTab structure
        Expanded(
          child: categoriesAsync.when(
            data: (categories) {
              if (categories.isEmpty) {
                final l10n = AppLocalizations.of(context);
                return CatalogEmptyState(
                  title: l10n.noCategories,
                  actionText: l10n.addNewCategoriesNow,
                  icon: Icons.category_outlined,
                  onActionTap: onAddPressed,
                );
              }
              final products = productsAsync.value ?? [];
              final Map<int, int> countsMap = {};

              for (final p in products) {
                final catId = p.category?.id;
                if (catId != null) {
                  countsMap[catId] = (countsMap[catId] ?? 0) + 1;
                }
              }
              return ListView.builder(
                padding: EdgeInsetsGeometry.symmetric(vertical: 12),
                itemCount: categories.length,
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final int count = countsMap[cat.id] ?? 0;

                  return CatalogTile(
                    name: cat.name,
                    subName: AppLocalizations.of(context).productCount(count),
                    basePrice: -1, // Categories don't have a price
                    isSelected: selectedIds.contains(cat.id),
                    isProduct: false, // This ensures the price tag doesn't show
                    icon: Icons.category_outlined,
                    // EXACT LOGIC MATCH:
                    onTap: () {
                      // ONLY toggle if the selection mode is already active
                      if (selectedIds.isNotEmpty) {
                        onToggle(cat.id!);
                      } else {
                        if (onEdit != null) {
                          onEdit!(cat);
                        }
                      }
                    },
                    onLongPress: () {
                      // ALWAYS toggle on long press to start the selection mode
                      onToggle(cat.id!);
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
