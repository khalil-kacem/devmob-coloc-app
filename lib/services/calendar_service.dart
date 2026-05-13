// lib/services/calendar_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class CalendarService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(String colocationId, Event event) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('events')
        .add(event.toMap());
  }

  Stream<List<Event>> getEvents(String colocationId) {
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('events')
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Event.fromMap(doc.data(), doc.id))
            .toList());
  }
}
