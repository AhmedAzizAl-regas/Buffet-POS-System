import 'package:buffet_app/core/database/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/datasources/catalog_local_datasource.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/entities/add_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import 'catalog_notifiers.dart'; // Import Notifiers for the NotifierProviders

// --- INFRASTRUCTURE ---
final catalogLocalDataSourceProvider = Provider<CatalogLocalDataSource>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return CatalogLocalDataSource(dbService.db);
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final dataSource = ref.watch(catalogLocalDataSourceProvider);
  return CatalogRepositoryImpl(dataSource);
});

// --- NOTIFIER PROVIDERS (The Data) ---
final productNotifierProvider =
    AsyncNotifierProvider<ProductNotifier, List<ProductEntity>>(ProductNotifier.new);

final addonNotifierProvider = AsyncNotifierProvider<AddonNotifier, List<AddEntity>>(
  AddonNotifier.new,
);

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, List<CategoryEntity>>(CategoryNotifier.new);

// --- UI STATE PROVIDERS (The Filters) ---
final productSearchProvider = StateProvider<String>((ref) => "");
final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);
final isSearchVisibleProvider = StateProvider<bool>((ref) => false);

// --- COMPUTED PROVIDERS (The Logic) ---
final filteredProductsProvider = Provider<AsyncValue<List<ProductEntity>>>((ref) {
  final searchQuery = ref.watch(productSearchProvider).toLowerCase();
  final selectedCatId = ref.watch(selectedCategoryIdProvider);
  final allProductsAsync = ref.watch(productNotifierProvider);

  return allProductsAsync.whenData((products) {
    return products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(searchQuery);

      // Ensure IDs are compared correctly (int vs int)
      final matchesCategory = selectedCatId == null || p.category?.id == selectedCatId;

      return matchesSearch && matchesCategory;
    }).toList();
  });
});

// true = Grid, false = List
final posLayoutProvider = StateProvider<bool>((ref) => true);
