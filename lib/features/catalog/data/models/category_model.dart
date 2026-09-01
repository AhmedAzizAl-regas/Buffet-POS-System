import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({super.id, required super.name});

  /// Convert SQL Map to Model
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as int?,
      name: map['name'] as String? ?? 'Unknown',
    );
  }

  /// Convert Model to SQL Map for saving
  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'name': name};
  }

  /// Helper to convert Entity back to Model for Repository operations
  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(id: entity.id, name: entity.name);
  }
}
