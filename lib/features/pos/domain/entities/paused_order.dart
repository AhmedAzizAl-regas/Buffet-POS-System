import 'package:buffet_app/features/pos/domain/entities/cart_item.dart';

class PausedOrder {
  final List<CartItem> items;
  final DateTime timestamp;

  PausedOrder({required this.items, required this.timestamp});
}
