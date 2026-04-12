// lib/services/task_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter une tâche
  Future<void> addTask(String colocationId, Task task) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('tasks')
        .add(task.toMap());
  }

  // Marquer comme terminée
  Future<void> toggleTask(
      String colocationId, String taskId, bool isDone) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('tasks')
        .doc(taskId)
        .update({'isDone': isDone});
  }

  // Stream de toutes les tâches de la colocation
  Stream<List<Task>> getTasks(String colocationId) {
    return _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromMap(doc.data(), doc.id))
            .toList());
  }
}
