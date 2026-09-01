import 'package:buffet_app/core/errors/failures.dart';
import 'package:buffet_app/core/utils/app_logger.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/add_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_local_datasource.dart';
import '../models/add_model.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogLocalDataSource localDataSource;

  CatalogRepositoryImpl(this.localDataSource);

  // --- Product Implementation ---

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts() async {
    try {
      AppLogger.debug("CatalogRepo: Fetching all products with categories...");
      final models = await localDataSource.getProducts();
      return Right(models);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Failed to load products", e, stack);
      return Left(DatabaseFailure("Failed to load products from database."));
    }
  }

  @override
  Future<Either<Failure, void>> addProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      await localDataSource.insertProduct(model.toMap());
      AppLogger.info("CatalogRepo: Product added - Name: ${product.name}");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Error adding product", e, stack);
      return Left(DatabaseFailure("Failed to save product."));
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(ProductEntity product) async {
    try {
      final model = ProductModel.fromEntity(product);
      await localDataSource.updateProduct(model.toMap());
      AppLogger.info("CatalogRepo: Product updated - ID: ${product.id}");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Error updating product", e, stack);
      return Left(DatabaseFailure("Failed to update product."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(int id) async {
    try {
      await localDataSource.deleteProduct(id);
      AppLogger.warning("CatalogRepo: Deleted Product ID: $id");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Failed to delete product", e, stack);
      return Left(DatabaseFailure("Failed to delete product."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteManyProducts(List<int> ids) async {
    try {
      await localDataSource.deleteMultipleProducts(ids);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Could not delete selected products"));
    }
  }

  // features/catalog/data/repositories/catalog_repository_impl.dart

  // features/catalog/data/repositories/catalog_repository_impl.dart

  @override
  Future<Either<Failure, void>> importProduct(ProductEntity product) async {
    try {
      int? resolvedId;

      // 1. Resolve Category Name to ID (Find or Create)
      if (product.category != null && product.category!.name.isNotEmpty) {
        resolvedId = await localDataSource.getOrCreateCategoryId(product.category!.name);
      }

      // 2. Convert to Map and FORCE the ID
      final productMap = ProductModel.fromEntity(product).toMap();

      // This is the critical line: Overwrite the null ID with the one we just found/created
      productMap['category_id'] = resolvedId;

      await localDataSource.insertProduct(productMap);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  // --- Category Implementation ---

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      AppLogger.debug("CatalogRepo: Fetching all categories...");
      final models = await localDataSource.getCategories();
      return Right(models);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Failed to load categories", e, stack);
      return Left(DatabaseFailure("Failed to load categories."));
    }
  }

  @override
  Future<Either<Failure, void>> addCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      await localDataSource.insertCategory(model.toMap());
      AppLogger.info("CatalogRepo: Category added - Name: ${category.name}");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Error adding category", e, stack);
      return Left(DatabaseFailure("Failed to save category."));
    }
  }

  @override
  Future<Either<Failure, void>> updateCategory(CategoryEntity category) async {
    try {
      final model = CategoryModel.fromEntity(category);
      await localDataSource.updateCategory(model.toMap());
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure("Failed to update category."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCategory(int id) async {
    try {
      await localDataSource.deleteCategory(id);
      AppLogger.warning(
        "CatalogRepo: Deleted Category ID: $id. Products are now Uncategorized.",
      );
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Failed to delete category", e, stack);
      return Left(DatabaseFailure("Failed to delete category."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteManyCategories(List<int> ids) async {
    try {
      // 1. Call the local data source
      await localDataSource.deleteManyCategories(ids);

      // 2. Return Right(null) on success
      return const Right(null);
    } catch (e) {
      // 3. Return your custom Failure object on error
      return Left(DatabaseFailure(e.toString()));
    }
  }
  // --- Add-on Implementation ---

  @override
  Future<Either<Failure, List<AddEntity>>> getAdds() async {
    try {
      AppLogger.debug("CatalogRepo: Fetching all add-ons...");
      final models = await localDataSource.getAdds();
      return Right(models);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Failed to load add-ons", e, stack);
      return Left(DatabaseFailure("Failed to load add-ons."));
    }
  }

  @override
  Future<Either<Failure, void>> addAddon(AddEntity add) async {
    try {
      final model = AddModel.fromEntity(add);
      await localDataSource.insertAddon(model.toMap());

      AppLogger.info("CatalogRepo: Add-on successfully added - Name: ${add.name}");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Error adding add-on - Name: ${add.name}", e, stack);
      return Left(DatabaseFailure("Failed to save add-on."));
    }
  }

  @override
  Future<Either<Failure, void>> updateAddon(AddEntity add) async {
    try {
      final model = AddModel.fromEntity(add);
      await localDataSource.updateAddon(model.toMap());

      AppLogger.info("CatalogRepo: Add-on updated - ID: ${add.id}, Name: ${add.name}");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Error updating add-on - ID: ${add.id}", e, stack);
      return Left(DatabaseFailure("Failed to update add-on."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAddon(int id) async {
    try {
      await localDataSource.deleteAddon(id);
      AppLogger.warning("CatalogRepo: User deleted Add-on ID: $id");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Failed to delete add-on - ID: $id", e, stack);
      return Left(DatabaseFailure("Failed to delete add-on."));
    }
  }

  @override
  Future<Either<Failure, void>> deleteManyAddons(List<int> ids) async {
    try {
      await localDataSource.deleteMultipleAddons(ids);
      AppLogger.warning("CatalogRepo: Bulk deletion executed for Add-on IDs: $ids");
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error("CatalogRepo: Bulk add-on deletion failed for IDs: $ids", e, stack);
      return Left(DatabaseFailure("Could not delete selected add-ons"));
    }
  }
}
