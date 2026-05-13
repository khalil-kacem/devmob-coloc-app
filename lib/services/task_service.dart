// lib/services/task_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmob_coloc_flutter_project/services/notification_service.dart';
import '../models/task.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter une tâche
  // Remplace toute la méthode addTask par celle-ci :

  Future<void> addTask(String colocationId, Task task) async {
    await _firestore
        .collection('colocations')
        .doc(colocationId)
        .collection('tasks')
        .add(task.toMap());

    // Notification
    NotificationService.sendNotification(
      colocationId: colocationId,
      title: "Nouvelle tâche ajoutée",
      body: "${task.title} - Assignée à ${task.assignedToName}",
      type: "task",
      userId: task.assignedTo,
    );
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
