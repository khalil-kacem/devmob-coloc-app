// lib/views/expenses/expenses_screen.dart
import 'package:devmob_coloc_flutter_project/models/colocation.dart'; // ← AJOUTÉ
import 'package:devmob_coloc_flutter_project/models/expense.dart';
import 'package:devmob_coloc_flutter_project/providers/auth_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/expenses_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/expense_service.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expensesProvider);
    final colocationId = ref.watch(userColocationIdProvider);
    final colocationAsync = ref.watch(currentColocationProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () =>
                _showAddExpenseDialog(colocationId, colocationAsync.value),
            icon: const Icon(Icons.add),
            label: Text("Ajouter une dépense", style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: expensesAsync.when(
              data: (expenses) => expenses.isEmpty
                  ? const Center(child: Text("Aucune dépense pour le moment"))
                  : ListView.builder(
                      itemCount: expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenses[index] as Expense;
                        return Card(
                          child: ListTile(
                            title: Text(expense.title,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                "Payé par ${expense.paidByName} • ${expense.date.toString().substring(0, 10)}"),
                            trailing: Text(
                              "${expense.amount.toStringAsFixed(2)} DT",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal),
                            ),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text("Erreur de chargement")),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExpenseDialog(String? colocationId, Colocation? colocation) {
    if (colocationId == null || colocation == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvelle dépense"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                  labelText: "Description (courses, loyer...)"),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Montant (DT)"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty ||
                  _amountController.text.isEmpty) return;

              final currentUser = ref.read(currentUserProvider).value!;

              final expense = Expense(
                id: '',
                title: _titleController.text.trim(),
                amount: double.parse(_amountController.text),
                paidBy: currentUser.uid,
                paidByName: currentUser.displayName,
                date: DateTime.now(),
                splitBetween: colocation.members,
              );

              ExpenseService().addExpense(colocationId, expense);

              _titleController.clear();
              _amountController.clear();
              Navigator.pop(context);
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}
