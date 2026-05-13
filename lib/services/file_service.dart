// lib/services/file_service.dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/document.dart';

class FileService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Upload réel via Firebase Storage
  Future<AppDocument?> uploadDocument(
    String colocationId,
    File file,
    String fileName,
    String uploadedBy,
    String uploadedByName,
  ) async {
    try {
      final ref = _storage.ref('colocations/$colocationId/documents/$fileName');
      await ref.putFile(file);

      final url = await ref.getDownloadURL();

      final document = AppDocument(
        id: '',
        name: fileName,
        url: url,
        uploadedBy: uploadedBy,
        uploadedByName: uploadedByName,
        uploadedAt: DateTime.now(),
        type: 'file',
      );

      final docRef = await _firestore
          .collection('colocations')
          .doc(colocationId)
          .collection('documents')
          .add(document.toMap());

      return document.copyWith(id: docRef.id);
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }

  // Ajout direct via URL (pour la méthode via URL)
  Future<void> addDocumentDirectly(
      String colocationId, AppDocument document) async {
    try {
      await _firestore
          .collection('colocations')
          .doc(colocationId)
          .collection('documents')
          .add(document.toMap());
    } catch (e) {
      print("Add document error: $e");
    }
  }

  // Récupérer les documents
  Stream<List<AppDocument>> getDocuments(String colocationId) {
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('documents')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppDocument.fromMap(doc.data(), doc.id))
            .toList());
  }
}
