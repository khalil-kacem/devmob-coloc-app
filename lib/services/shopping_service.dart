// lib/services/shopping_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shopping_item.dart';

class ShoppingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addItem(String colocationId, ShoppingItem item) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('shopping_list')
        .add(item.toMap());
  }

  Future<void> toggleItem(
      String colocationId, String itemId, bool isChecked) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('shopping_list')
        .doc(itemId)
        .update({'isChecked': isChecked});
  }

  Stream<List<ShoppingItem>> getShoppingList(String colocationId) {
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('shopping_list')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ShoppingItem.fromMap(doc.data(), doc.id))
            .toList());
  }
}
