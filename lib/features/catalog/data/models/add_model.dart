import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';
import 'package:buffet_app/features/catalog/domain/entities/add_entity.dart';

class AddModel extends AddEntity {
  AddModel({super.id, required super.name, super.basePrice, super.supplier, super.quantity = 0});

  // 1. From Database
  factory AddModel.fromMap(Map<String, dynamic> map) {
    return AddModel(
      id: map['id'],
      name: map['name'],
      basePrice: map['base_price']?.toDouble() ?? 0.0,
      supplier: map['supplier_id'] != null
          ? SupplierEntity(
              id: map['supplier_id'] as int?,
              name: map['supplier_name'] as String? ?? '',
            )
          : null,
      quantity: map['quantity'] as int? ?? 0,
    );
  }

  // 2. From Domain Entity
  factory AddModel.fromEntity(AddEntity entity) {
    return AddModel(
      id: entity.id,
      name: entity.name,
      basePrice: entity.basePrice,
      supplier: entity.supplier,
      quantity: entity.quantity,
    );
  }

  // 3. To Database
  @override
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, 
      'name': name, 
      'base_price': basePrice,
      'supplier_id': supplier?.id,
      'quantity': quantity,
    };
  }
}
