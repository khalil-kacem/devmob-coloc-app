// lib/models/document.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class AppDocument {
  final String id;
  final String name;
  final String url;
  final String uploadedBy;
  final String uploadedByName;
  final DateTime uploadedAt;
  final String type;

  AppDocument({
    required this.id,
    required this.name,
    required this.url,
    required this.uploadedBy,
    required this.uploadedByName,
    required this.uploadedAt,
    required this.type,
  });

  factory AppDocument.fromMap(Map<String, dynamic> map, String id) {
    return AppDocument(
      id: id,
      name: map['name'] ?? '',
      url: map['url'] ?? '',
      uploadedBy: map['uploadedBy'] ?? '',
      uploadedByName: map['uploadedByName'] ?? '',
      uploadedAt: (map['uploadedAt'] as Timestamp).toDate(),
      type: map['type'] ?? 'pdf',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'url': url,
      'uploadedBy': uploadedBy,
      'uploadedByName': uploadedByName,
      'uploadedAt': FieldValue.serverTimestamp(),
      'type': type,
    };
  }

  // ← Méthode copyWith ajoutée
  AppDocument copyWith({String? id}) {
    return AppDocument(
      id: id ?? this.id,
      name: name,
      url: url,
      uploadedBy: uploadedBy,
      uploadedByName: uploadedByName,
      uploadedAt: uploadedAt,
      type: type,
    );
  }
}
