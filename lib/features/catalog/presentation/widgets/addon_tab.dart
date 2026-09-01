import 'package:buffet_app/features/catalog/domain/entities/add_entity.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_empty_widget.dart';
import 'package:buffet_app/features/catalog/presentation/widgets/catalog_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../generated/l10n.dart';
import '../providers/catalog_providers.dart';

class AddonTab extends ConsumerWidget {
  final Set<int> selectedIds;
  final Function(int) onToggle;
  final VoidCallback onAddPressed;
  final Function(AddEntity)? onEdit; // <--- Add this
  const AddonTab({
    super.key,
    required this.selectedIds,
    required this.onToggle,
    required this.onAddPressed,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addonsAsync = ref.watch(addonNotifierProvider);

    return addonsAsync.when(
      data: (addons) {
        if (addons.isEmpty) {
          return CatalogEmptyState(
            title: AppLocalizations.of(context).noAddons,
            actionText: AppLocalizations.of(context).addAddonsNow,
            icon: Icons.add_circle_outline,
            onActionTap: onAddPressed, // 3. Use it here
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: addons.length,
          itemBuilder: (context, index) {
            final item = addons[index];
            return CatalogTile(
              isProduct: false,
              name: item.name,
              basePrice: item.basePrice,
              icon: Icons.add_circle_outline, // Addon Icon
              isSelected: selectedIds.contains(item.id),
              onTap: () {
                if (selectedIds.isNotEmpty) {
                  onToggle(item.id!);
                } else {
                  if (onEdit != null) {
                    onEdit!(item);
                  }
                }
              },
              onLongPress: () => onToggle(item.id!),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: Colors.orange)),
      error: (e, _) =>
          Center(child: Text(AppLocalizations.of(context).errorOccurred(e.toString()))),
    );
  }
}
