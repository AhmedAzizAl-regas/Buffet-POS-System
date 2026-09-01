import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../../core/database/database_service.dart';
import '../../data/repositories/order_repository.dart';

/// This provider fetches the list of orders from SQLite.
/// We use FutureProvider because database calls are asynchronous.
final orderListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  // 1. Get the database service
  final dbService = ref.watch(databaseServiceProvider);

  // 2. Pass it to the repository
  final repo = OrderRepository(dbService);

  // 3. Return the list of orders
  return await repo.getAllOrders();
});

/// Fetches full details (Items + Adds) for a specific order ID
final orderDetailsProvider = FutureProvider.family<List<Map<String, dynamic>>, int>((
  ref,
  orderId,
) async {
  final dbService = ref.watch(databaseServiceProvider);
  final repo = OrderRepository(dbService);

  return await repo.getOrderFullDetails(orderId);
});
final selectedOrdersProvider = StateProvider<Set<int>>((ref) => {});
final editingOrderIdProvider = StateProvider<int?>((ref) => null);
final editingOrderMetadataProvider = StateProvider<({String? name, String? notes})?>(
  (ref) => null,
);

final orderFilterProvider = StateProvider.autoDispose<String?>((ref) => null);
