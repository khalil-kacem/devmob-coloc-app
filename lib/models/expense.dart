// lib/models/expense.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String id;
  final String title;
  final double amount;
  final String paidBy; // UID de celui qui a payé
  final String paidByName;
  final DateTime date;
  final List<String> splitBetween; // UIDs des membres concernés

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.paidBy,
    required this.paidByName,
    required this.date,
    required this.splitBetween,
  });

  factory Expense.fromMap(Map<String, dynamic> map, String id) {
    return Expense(
      id: id,
      title: map['title'] ?? '',
      amount: (map['amount'] as num).toDouble(),
      paidBy: map['paidBy'] ?? '',
      paidByName: map['paidByName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      splitBetween: List<String>.from(map['splitBetween'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'paidBy': paidBy,
      'paidByName': paidByName,
      'date': FieldValue.serverTimestamp(),
      'splitBetween': splitBetween,
    };
  }
}
