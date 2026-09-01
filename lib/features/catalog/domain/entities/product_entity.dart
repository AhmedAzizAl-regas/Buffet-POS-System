import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';
import 'category_entity.dart';

class ProductEntity {
  final int? id;
  final String name;
  final double basePrice;
  final CategoryEntity? category; // Nested Entity for Clean Arch
  final SupplierEntity? supplier; // Add supplier association
  final int quantity;

  ProductEntity({
    this.id,
    required this.name,
    required this.basePrice,
    this.category,
    this.supplier,
    this.quantity = 0,
  });

  ProductEntity copyWith({
    int? id,
    String? name,
    double? basePrice,
    CategoryEntity? category,
    SupplierEntity? supplier,
    int? quantity,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      category: category ?? this.category,
      supplier: supplier ?? this.supplier,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntity &&
          runtimeType == other.runtimeType &&
          name.trim().toLowerCase() == other.name.trim().toLowerCase();

  @override
  int get hashCode => name.trim().toLowerCase().hashCode;
}
