// lib/services/colocation_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/colocation.dart';

class ColocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  // Créer une nouvelle colocation
  Future<Colocation> createColocation(String name, String adminId) async {
    final inviteCode = _uuid.v4().substring(0, 6).toUpperCase();
    final docRef = _firestore.collection('colocations').doc();

    final colocation = Colocation(
      id: docRef.id,
      name: name,
      inviteCode: inviteCode,
      adminId: adminId,
      members: [adminId],
      createdAt: DateTime.now(),
    );

    await docRef.set(colocation.toMap());
    return colocation;
  }

  // Rejoindre avec code d’invitation
  Future<Colocation?> joinColocation(String inviteCode, String userId) async {
    final query = await _firestore
        .collection('colocations')
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    final doc = query.docs.first;
    final colocation = Colocation.fromMap(doc.data(), doc.id);

    if (colocation.members.contains(userId)) return colocation;

    await doc.reference.update({
      'members': FieldValue.arrayUnion([userId]),
    });

    return Colocation.fromMap(doc.data(), doc.id);
  }

  // Récupérer la colocation d’un utilisateur
  Stream<Colocation?> getColocationStream(String colocationId) {
    if (colocationId.isEmpty) return Stream.value(null);
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .snapshots()
        .map((snap) =>
            snap.exists ? Colocation.fromMap(snap.data()!, snap.id) : null);
  }
}
