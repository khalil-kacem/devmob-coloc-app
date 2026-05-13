// lib/services/expense_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmob_coloc_flutter_project/services/notification_service.dart';
import '../models/expense.dart';

class ExpenseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExpense(String colocationId, Expense expense) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('expenses')
        .add(expense.toMap());
    NotificationService.sendNotification(
      colocationId: colocationId,
      title: "Nouvelle dépense",
      body: "${expense.title} - ${expense.amount} DT",
      type: "expense",
      userId: expense.paidBy,
    );
  }

  Stream<List<Expense>> getExpenses(String colocationId) {
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('expenses')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Expense.fromMap(doc.data(), doc.id))
            .toList());
  }
}
