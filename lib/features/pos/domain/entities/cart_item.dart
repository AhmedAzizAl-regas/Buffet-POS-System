import 'package:buffet_app/features/catalog/domain/entities/add_entity.dart';
import 'package:buffet_app/features/catalog/domain/entities/product_entity.dart';
import 'package:collection/collection.dart'; // Add this package to pubspec for list comparison

class CartItem {
  final ProductEntity product;
  final List<AddEntity> selectedAddons;
  int quantity;

  CartItem({required this.product, required this.selectedAddons, this.quantity = 1});

  // Calculate price for this specific row (Product + all its Addons) * Qty
  double get unitPrice {
    double addonsTotal = selectedAddons.fold(0, (sum, addon) => sum + (addon.basePrice));
    return product.basePrice + (addonsTotal / quantity);
  }

  double get totalRowPrice => (product.basePrice * quantity) + selectedAddons.fold(0, (sum, addon) => sum + (addon.basePrice));

  // This helper helps the Notifier decide:
  // "Is this the SAME burger configuration or a DIFFERENT one?"
  bool isSameConfiguration(int productId, List<int> addonIds) {
    if (product.id != productId) return false;

    // Compare the list of addon IDs
    final currentAddonIds = selectedAddons.map((e) => e.id).toList()..sort();
    final newAddonIds = List<int>.from(addonIds)..sort();

    return const IterableEquality().equals(currentAddonIds, newAddonIds);
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    // 1. Rebuild the Product
    final product = ProductEntity(
      id: map['product_id'],
      name: map['name_at_sale'], // Use the name saved at time of sale
      basePrice: (map['price_at_sale'] as num).toDouble(),
    );

    // 2. Rebuild the Addons list
    final List<dynamic> addonsRaw = map['addons'] ?? [];
    final List<AddEntity> addons = addonsRaw.map((a) {
      return AddEntity(
        id: a['add_id'],
        name: a['name_at_sale'],
        basePrice: (a['price_at_sale'] as num).toDouble(),
      );
    }).toList();

    return CartItem(
      product: product,
      selectedAddons: addons,
      quantity: map['quantity'] as int,
    );
  }
}
