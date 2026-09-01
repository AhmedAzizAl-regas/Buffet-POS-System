import 'package:buffet_app/features/suppliers/domain/entities/supplier_entity.dart';

class AddEntity {
  final int? id;
  final String name;
  final double basePrice;
  final SupplierEntity? supplier; // Add supplier association
  final int quantity;

  AddEntity({this.id, required this.name, this.basePrice = 0.0, this.supplier, this.quantity = 0});

  /// --- THE MISSING LINK FOR "REPLACE" ---
  /// Creates a new AddEntity from an existing one, allowing you to
  /// update specific fields (like price) while keeping the original ID.
  AddEntity copyWith({int? id, String? name, double? basePrice, SupplierEntity? supplier, int? quantity}) {
    return AddEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      basePrice: basePrice ?? this.basePrice,
      supplier: supplier ?? this.supplier,
      quantity: quantity ?? this.quantity,
    );
  }

  /// Convert to Map for JSON Export / Database Storage
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id, 
      'name': name, 
      'base_price': basePrice,
      'supplier_id': supplier?.id,
      'quantity': quantity,
    };
  }

  /// Create from Map for JSON Import / Database Retrieval
  factory AddEntity.fromMap(Map<String, dynamic> map) {
    return AddEntity(
      id: map['id'] as int?,
      name: map['name'] ?? '',
      // Safe casting: handles int, double, and null values from CSV/JSON
      basePrice: (map['base_price'] as num?)?.toDouble() ?? 0.0,
      supplier: map['supplier_id'] != null
          ? SupplierEntity(
              id: map['supplier_id'] as int?,
              name: map['supplier_name'] as String? ?? '',
            )
          : null,
      quantity: map['quantity'] as int? ?? 0,
    );
  }

  // --- HELPER FOR UI COMPARISON ---
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddEntity &&
          runtimeType == other.runtimeType &&
          name.trim().toLowerCase() == other.name.trim().toLowerCase();

  @override
  int get hashCode => name.trim().toLowerCase().hashCode;
}
