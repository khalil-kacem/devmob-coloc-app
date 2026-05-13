// lib/models/shopping_item.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class ShoppingItem {
  final String id;
  final String name;
  final bool isChecked;
  final String addedBy;
  final String addedByName;
  final DateTime addedAt;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.isChecked,
    required this.addedBy,
    required this.addedByName,
    required this.addedAt,
  });

  factory ShoppingItem.fromMap(Map<String, dynamic> map, String id) {
    return ShoppingItem(
      id: id,
      name: map['name'] ?? '',
      isChecked: map['isChecked'] ?? false,
      addedBy: map['addedBy'] ?? '',
      addedByName: map['addedByName'] ?? '',
      addedAt: (map['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isChecked': isChecked,
      'addedBy': addedBy,
      'addedByName': addedByName,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}
