// lib/views/tasks/tasks_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmob_coloc_flutter_project/models/colocation.dart';
import 'package:devmob_coloc_flutter_project/models/task.dart';
import 'package:devmob_coloc_flutter_project/providers/auth_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/task_service.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(tasksProvider);
    final colocationId = ref.watch(userColocationIdProvider);
    final colocationAsync = ref.watch(currentColocationProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () =>
                _showAddTaskDialog(colocationId, colocationAsync.value),
            icon: const Icon(Icons.add),
            label: Text("Nouvelle tâche", style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: tasksAsync.when(
              data: (tasks) => tasks.isEmpty
                  ? const Center(child: Text("Aucune tâche pour le moment"))
                  : ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (val) {
                                TaskService()
                                    .toggleTask(colocationId!, task.id, val!);
                              },
                            ),
                            title: Text(task.title,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                              "${task.description}\nAssigné à : ${task.assignedToName}",
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                            trailing: task.isDone
                                ? const Icon(Icons.check_circle,
                                    color: Colors.green)
                                : const Icon(Icons.pending,
                                    color: Colors.orange),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text("Erreur de chargement des tâches")),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(String? colocationId, Colocation? colocation) async {
    if (colocationId == null ||
        colocation == null ||
        colocation.members.isEmpty) return;

    // Charger les vrais noms depuis Firestore
    final Map<String, String> memberNames = {};
    for (String uid in colocation.members) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      memberNames[uid] = doc.data()?['name'] ?? "Colocataire inconnu";
    }

    String? selectedMemberUid = colocation.members.first;
    String selectedMemberName = memberNames[selectedMemberUid] ?? "Moi";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvelle tâche"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration:
                      const InputDecoration(labelText: "Titre de la tâche"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 20),
                const Text("Assigner à :"),
                DropdownButton<String>(
                  value: selectedMemberUid,
                  isExpanded: true,
                  items: colocation.members.map((uid) {
                    final name = memberNames[uid] ?? "Colocataire";
                    return DropdownMenuItem(
                      value: uid,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setStateDialog(() {
                      selectedMemberUid = value;
                      selectedMemberName = memberNames[value] ?? "Colocataire";
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty) return;

              final task = Task(
                id: '',
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                assignedTo: selectedMemberUid!,
                assignedToName: selectedMemberName,
                isDone: false,
                createdAt: DateTime.now(),
              );

              TaskService().addTask(colocationId, task);

              _titleController.clear();
              _descController.clear();
              Navigator.pop(context);
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}
