// lib/models/task.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String assignedTo; // UID du colocataire
  final String assignedToName; // Nom affiché
  final bool isDone;
  final DateTime createdAt;
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.assignedTo,
    required this.assignedToName,
    required this.isDone,
    required this.createdAt,
    this.dueDate,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      assignedTo: map['assignedTo'] ?? '',
      assignedToName: map['assignedToName'] ?? 'Non assigné',
      isDone: map['isDone'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      dueDate: map['dueDate'] != null
          ? (map['dueDate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'assignedTo': assignedTo,
      'assignedToName': assignedToName,
      'isDone': isDone,
      'createdAt': FieldValue.serverTimestamp(),
      'dueDate': dueDate,
    };
  }
}
