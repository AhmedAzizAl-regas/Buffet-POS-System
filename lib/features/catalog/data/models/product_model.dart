import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    super.id,
    required super.name,
    required super.basePrice,
    super.category,
    super.supplier,
    super.quantity = 0,
  });

  // Convert SQL Map to Model
  // Expects 'category_id', 'category_name', and optional 'supplier_id', 'supplier_name' from a JOIN query
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      basePrice: (map['base_price'] as num).toDouble(),
      category: map['category_id'] != null
          ? CategoryEntity(
              id: map['category_id'] as int?,
              name: map['category_name'] as String? ?? '',
            )
          : null,
      supplier: map['supplier_id'] != null
          ? SupplierEntity(
              id: map['supplier_id'] as int?,
              name: map['supplier_name'] as String? ?? '',
            )
          : null,
      quantity: map['quantity'] as int? ?? 0,
    );
  }

  // Convert Model to SQL Map for saving
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'base_price': basePrice,
      'category_id': category?.id, // Saves the ID to the foreign key column
      'supplier_id': supplier?.id, // Saves the ID to the foreign key column
      'quantity': quantity,
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      basePrice: entity.basePrice,
      category: entity.category,
      supplier: entity.supplier,
      quantity: entity.quantity,
    );
  }
}
