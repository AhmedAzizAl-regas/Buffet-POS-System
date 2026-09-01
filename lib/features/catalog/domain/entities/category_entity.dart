class CategoryEntity {
  final int? id;
  final String name;

  CategoryEntity({this.id, required this.name});

  // ADD THIS:
  CategoryEntity copyWith({int? id, String? name}) {
    return CategoryEntity(
      // If a new 'id' is provided, use it. Otherwise, use the current one.
      id: id ?? this.id,
      // If a new 'name' is provided, use it. Otherwise, use the current one.
      name: name ?? this.name,
    );
  }
}
