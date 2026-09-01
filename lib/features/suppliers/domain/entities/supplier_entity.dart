class SupplierEntity {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double balance;

  SupplierEntity({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.balance = 0.0,
  });

  SupplierEntity copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? balance,
  }) {
    return SupplierEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      balance: balance ?? this.balance,
    );
  }

  factory SupplierEntity.fromMap(Map<String, dynamic> map) {
    return SupplierEntity(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String?,
      email: map['email'] as String?,
      address: map['address'] as String?,
      balance: (map['balance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'balance': balance,
    };
  }
}

class SupplierTransactionEntity {
  final int? id;
  final int supplierId;
  final String type; // 'credit' (دائن - purchase) or 'debit' (مدين - payment/return)
  final double amount;
  final String? description;
  final DateTime createdAt;

  SupplierTransactionEntity({
    this.id,
    required this.supplierId,
    required this.type,
    required this.amount,
    this.description,
    required this.createdAt,
  });

  SupplierTransactionEntity copyWith({
    int? id,
    int? supplierId,
    String? type,
    double? amount,
    String? description,
    DateTime? createdAt,
  }) {
    return SupplierTransactionEntity(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory SupplierTransactionEntity.fromMap(Map<String, dynamic> map) {
    return SupplierTransactionEntity(
      id: map['id'] as int?,
      supplierId: map['supplier_id'] as int,
      type: map['type'] as String? ?? 'credit',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'supplier_id': supplierId,
      'type': type,
      'amount': amount,
      'description': description,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
