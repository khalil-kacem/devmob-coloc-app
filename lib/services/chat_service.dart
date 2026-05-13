// lib/services/chat_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String colocationId, Message message) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('messages')
        .add(message.toMap());
  }

  Stream<List<Message>> getMessages(String colocationId) {
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data(), doc.id))
            .toList());
  }
}
