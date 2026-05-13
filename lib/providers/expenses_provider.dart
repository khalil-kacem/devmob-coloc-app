// lib/providers/expenses_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/expense_service.dart';
import 'colocation_provider.dart';

final expenseServiceProvider =
    Provider<ExpenseService>((ref) => ExpenseService());

final expensesProvider = StreamProvider.autoDispose<List<dynamic>>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);
  if (colocationId == null || colocationId.isEmpty) return Stream.value([]);
  return ref.watch(expenseServiceProvider).getExpenses(colocationId);
});
