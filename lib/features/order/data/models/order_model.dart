import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';

class OrderModel {
  final int? id;
  final double totalAmount;
  final String customerName;
  final String? notes;
  final DateTime createdAt;
  final List<CartItem> items;
  // --- NEW FIELD ---
  final int status; // 0 for Pending, 1 for Served

  OrderModel({
    this.id,
    required this.totalAmount,
    this.customerName = 'Order',
    this.notes,
    required this.createdAt,
    required this.items,
    this.status = 0, // Default to Pending (0)
  });

  /// Helper to check if served without magic numbers in UI
  bool get isServed => status == 1;

  /// Helper to convert Database Map + List of CartItems into a Model
  factory OrderModel.fromMap(Map<String, dynamic> map, List<CartItem> items) {
    return OrderModel(
      id: map['id'] as int?,
      totalAmount: (map['total_price'] as num).toDouble(),
      customerName: map['customer_name'] as String? ?? 'Order',
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      items: items,
      // --- MAP THE STATUS FROM DB ---
      status: map['status'] as int? ?? 0,
    );
  }

  /// Add toMap if you are using it for Database Inserts
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'total_price': totalAmount,
      'customer_name': customerName,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'status': status, // Saves 0 or 1 to DB
    };
  }
}
