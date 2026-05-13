// lib/models/event.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String createdBy;
  final String createdByName;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.createdBy,
    required this.createdByName,
  });

  factory Event.fromMap(Map<String, dynamic> map, String id) {
    return Event(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
      createdByName: map['createdByName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
      'createdByName': createdByName,
    };
  }
}
