import 'package:buffet_app/features/catalog/domain/entities/add_entity.dart';
import 'package:buffet_app/features/catalog/domain/entities/category_entity.dart'; // Added this
import 'package:buffet_app/features/catalog/domain/entities/product_entity.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class CatalogRepository {
  // --- Products ---
  Future<Either<Failure, List<ProductEntity>>> getProducts();
  Future<Either<Failure, void>> importProduct(ProductEntity product);
  Future<Either<Failure, void>> addProduct(ProductEntity product);
  Future<Either<Failure, void>> updateProduct(ProductEntity product);
  Future<Either<Failure, void>> deleteProduct(int id);
  Future<Either<Failure, void>> deleteManyProducts(List<int> ids);

  // --- Categories (The new spot) ---
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, void>> addCategory(CategoryEntity category);
  Future<Either<Failure, void>> updateCategory(CategoryEntity category);
  Future<Either<Failure, void>> deleteCategory(int id);
  Future<Either<Failure, void>> deleteManyCategories(List<int> ids);

  // --- Add-ons ---
  Future<Either<Failure, List<AddEntity>>> getAdds();
  Future<Either<Failure, void>> addAddon(AddEntity add);
  Future<Either<Failure, void>> updateAddon(AddEntity add);
  Future<Either<Failure, void>> deleteAddon(int id);
  Future<Either<Failure, void>> deleteManyAddons(List<int> ids);
}
