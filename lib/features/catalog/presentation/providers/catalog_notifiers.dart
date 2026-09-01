import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/add_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import 'catalog_providers.dart';

// --- PRODUCT NOTIFIER ---
class ProductNotifier extends AsyncNotifier<List<ProductEntity>> {
  @override
  FutureOr<List<ProductEntity>> build() async {
    final result = await ref.watch(catalogRepositoryProvider).getProducts();
    return result.fold((l) => throw l.errMessage, (r) => r);
  }

  // Inside ProductNotifier...

  // Inside your ProductNotifier
  Future<String?> addItem(ProductEntity item) async {
    // If category has a name but no ID, it's an import from your CatalogService
    final isImport = item.category != null && item.category!.id == null;

    final result = isImport
        ? await ref.read(catalogRepositoryProvider).importProduct(item)
        : await ref.read(catalogRepositoryProvider).addProduct(item);

    return result.fold((l) => l.errMessage, (r) {
      if (isImport) {
        // This forces the Category Tab to reload from the DB
        ref.invalidate(categoryNotifierProvider);
      }
      ref.invalidateSelf();
      return null;
    });
  }

  Future<String?> updateProduct(ProductEntity item) async {
    final result = await ref.read(catalogRepositoryProvider).updateProduct(item);
    return result.fold((l) => l.errMessage, (r) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<void> removeItem(int id) async {
    await ref.read(catalogRepositoryProvider).deleteProduct(id);
    ref.invalidateSelf();
  }

  Future<void> deleteMany(List<int> ids) async {
    final result = await ref.read(catalogRepositoryProvider).deleteManyProducts(ids);
    result.fold(
      (l) => state = AsyncError(l.errMessage, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  // Used by Import logic for simplified price updates
  Future<void> updatePriceByName(String name, double newPrice) async {
    final currentList = state.value ?? [];
    final existing = currentList.firstWhere(
      (p) => p.name.trim().toLowerCase() == name.trim().toLowerCase(),
    );

    final updatedProduct = existing.copyWith(basePrice: newPrice);
    await updateProduct(updatedProduct);
  }
}

// --- CATEGORY NOTIFIER ---
class CategoryNotifier extends AsyncNotifier<List<CategoryEntity>> {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    final result = await ref.watch(catalogRepositoryProvider).getCategories();
    return result.fold((l) => throw l.errMessage, (r) => r);
  }

  // --- ADDED: Update Category ---
  Future<String?> updateCategory(CategoryEntity category) async {
    final result = await ref.read(catalogRepositoryProvider).updateCategory(category);
    return result.fold((l) => l.errMessage, (r) {
      ref.invalidateSelf();
      // Invalidate products because a category name change
      // might need to reflect in the product list immediately
      ref.invalidate(productNotifierProvider);
      return null;
    });
  }

  Future<String?> addCategory(CategoryEntity category) async {
    final result = await ref.read(catalogRepositoryProvider).addCategory(category);
    return result.fold((l) => l.errMessage, (r) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<void> removeCategory(int id) async {
    await ref.read(catalogRepositoryProvider).deleteCategory(id);
    ref.invalidateSelf();
    ref.invalidate(productNotifierProvider);
  }

  // --- ADDED: Delete Multiple (For the multi-select feature) ---
  // inside class CategoryNotifier ...

  Future<void> deleteMany(List<int> ids) async {
    // Use the repository to delete all at once
    final result = await ref.read(catalogRepositoryProvider).deleteManyCategories(ids);

    result.fold((l) => state = AsyncValue.error(l.errMessage, StackTrace.current), (r) {
      // Refresh the category list
      ref.invalidateSelf();
      // IMPORTANT: Also refresh products because their category links are now null
      ref.invalidate(productNotifierProvider);
    });
  }
}

// final categoryNotifierProvider =
//     AsyncNotifierProvider<CategoryNotifier, List<CategoryEntity>>(CategoryNotifier.new);

// --- ADDON NOTIFIER ---
class AddonNotifier extends AsyncNotifier<List<AddEntity>> {
  @override
  FutureOr<List<AddEntity>> build() async {
    final result = await ref.watch(catalogRepositoryProvider).getAdds();
    return result.fold((l) => throw l.errMessage, (r) => r);
  }

  Future<String?> addAddon(AddEntity addon) async {
    final result = await ref.read(catalogRepositoryProvider).addAddon(addon);
    return result.fold((l) => l.errMessage, (r) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<String?> updateAddon(AddEntity addon) async {
    final result = await ref.read(catalogRepositoryProvider).updateAddon(addon);
    return result.fold((l) => l.errMessage, (r) {
      ref.invalidateSelf();
      return null;
    });
  }

  Future<void> deleteAddon(int id) async {
    final result = await ref.read(catalogRepositoryProvider).deleteAddon(id);
    result.fold(
      (l) => state = AsyncError(l.errMessage, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  Future<void> deleteMany(List<int> ids) async {
    final result = await ref.read(catalogRepositoryProvider).deleteManyAddons(ids);
    result.fold(
      (l) => state = AsyncError(l.errMessage, StackTrace.current),
      (r) => ref.invalidateSelf(),
    );
  }

  /// THE FIX: This method bridges the gap between CSV (no ID) and DB (needs ID)
  Future<void> updateAddonByName(AddEntity importedAddon) async {
    final currentState = state.value ?? [];

    // 1. Find the existing addon by name
    final existingIndex = currentState.indexWhere(
      (a) => a.name.trim().toLowerCase() == importedAddon.name.trim().toLowerCase(),
    );

    if (existingIndex != -1) {
      final existingAddon = currentState[existingIndex];

      // 2. Attach the existing ID to the imported data using copyWith
      final updatedAddon = existingAddon.copyWith(basePrice: importedAddon.basePrice);

      // 3. Send to Repository and invalidate to refresh UI
      await updateAddon(updatedAddon);
    }
  }
  // Inside AddonNotifier class in catalog_notifiers.dart

  Future<void> updateAddonPriceByName(String name, double newPrice) async {
    final currentList = state.value ?? [];

    // 1. Find the existing item by name (ignoring case/spaces)
    // This is the "Identity" check
    final existing = currentList.firstWhere(
      (a) => a.name.trim().toLowerCase() == name.trim().toLowerCase(),
      orElse: () => throw "Addon not found",
    );

    // 2. Use copyWith to keep the ID and isPriced status, but change the price
    final updatedAddon = existing.copyWith(basePrice: newPrice);

    // 3. Call the standard update method to save to Database
    await updateAddon(updatedAddon);
  }
}

// ///POS screen notifiers well be moved later
// // 1. A simple string provider for the search bar
// final productSearchProvider = StateProvider<String>((ref) => "");
//
// // 2. The filtered list that your GridView will actually use
// final filteredProductsProvider = Provider<AsyncValue<List<ProductEntity>>>((ref) {
//   final searchQuery = ref.watch(productSearchProvider).toLowerCase();
//   final allProductsAsync = ref.watch(productNotifierProvider);
//
//   return allProductsAsync.whenData((products) {
//     if (searchQuery.isEmpty) return products;
//
//     // Simple but powerful local filtering
//     return products.where((p) {
//       final nameMatch = p.name.toLowerCase().contains(searchQuery);
//       // Optional: search by price too!
//       final priceMatch = p.basePrice.toString().contains(searchQuery);
//       return nameMatch || priceMatch;
//     }).toList();
//   });
// });
// final isSearchVisibleProvider = StateProvider<bool>((ref) => false);

///POS screen notifiers END

// --- PROVIDERS ---
// final productNotifierProvider =
//     AsyncNotifierProvider<ProductNotifier, List<ProductEntity>>(ProductNotifier.new);
//
// final addonNotifierProvider = AsyncNotifierProvider<AddonNotifier, List<AddEntity>>(
//   AddonNotifier.new,
// );
