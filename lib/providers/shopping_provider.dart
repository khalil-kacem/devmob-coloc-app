// lib/providers/shopping_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shopping_service.dart';
import 'colocation_provider.dart';

final shoppingServiceProvider =
    Provider<ShoppingService>((ref) => ShoppingService());

final shoppingListProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);
  if (colocationId == null || colocationId.isEmpty) return Stream.value([]);
  return ref.watch(shoppingServiceProvider).getShoppingList(colocationId);
});
