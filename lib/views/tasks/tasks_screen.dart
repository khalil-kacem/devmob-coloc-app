// lib/views/tasks/tasks_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmob_coloc_flutter_project/models/colocation.dart';
import 'package:devmob_coloc_flutter_project/models/task.dart';
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

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          child: Column(
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Mes tâches",
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xff1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Organisez vos tâches facilement",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      onPressed: () => _showAddTaskDialog(
                        colocationId,
                        colocationAsync.value,
                      ),
                      icon: const Icon(
                        Icons.add_task_rounded,
                        color: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ADD TASK BUTTON
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddTaskDialog(
                    colocationId,
                    colocationAsync.value,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    "Nouvelle tâche",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // TASKS
              Expanded(
                child: tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt_rounded,
                              size: 90,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 18),
                            Text(
                              "Aucune tâche",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Ajoutez votre première tâche",
                              style: GoogleFonts.poppins(
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final task = tasks[index];

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.scale(
                                scale: 1.15,
                                child: Checkbox(
                                  activeColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  value: task.isDone,
                                  onChanged: (val) {
                                    TaskService().toggleTask(
                                      colocationId!,
                                      task.id,
                                      val!,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            task.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w600,
                                              decoration: task.isDone
                                                  ? TextDecoration.lineThrough
                                                  : null,
                                              color: task.isDone
                                                  ? Colors.grey
                                                  : const Color(0xff1E293B),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: task.isDone
                                                ? Colors.green.withOpacity(0.12)
                                                : Colors.orange.withOpacity(
                                                    0.12,
                                                  ),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Text(
                                            task.isDone
                                                ? "Terminée"
                                                : "En cours",
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w600,
                                              color: task.isDone
                                                  ? Colors.green
                                                  : Colors.orange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      task.description.isEmpty
                                          ? "Aucune description"
                                          : task.description,
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        height: 1.5,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 16,
                                          backgroundColor:
                                              Colors.teal.withOpacity(0.15),
                                          child: Text(
                                            task.assignedToName[0]
                                                .toUpperCase(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.teal,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            "Assigné à ${task.assignedToName}",
                                            style: GoogleFonts.poppins(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.teal,
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      "Erreur de chargement des tâches",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog(
    String? colocationId,
    Colocation? colocation,
  ) async {
    if (colocationId == null ||
        colocation == null ||
        colocation.members.isEmpty) {
      return;
    }

    final Map<String, String> memberNames = {};

    for (String uid in colocation.members) {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      memberNames[uid] = doc.data()?['name'] ?? "Colocataire";
    }

    String? selectedMemberUid = colocation.members.first;
    String selectedMemberName = memberNames[selectedMemberUid] ?? "Colocataire";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.assignment_add,
                      size: 60,
                      color: Colors.teal,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Nouvelle tâche",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        labelText: "Titre",
                        labelStyle: GoogleFonts.poppins(),
                        prefixIcon: const Icon(Icons.title_rounded),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: _descController,
                      maxLines: 3,
                      style: GoogleFonts.poppins(),
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: GoogleFonts.poppins(),
                        prefixIcon: const Icon(Icons.description_rounded),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Assigner à",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: DropdownButton<String>(
                        value: selectedMemberUid,
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                        ),
                        items: colocation.members.map((uid) {
                          final name = memberNames[uid] ?? "Colocataire";

                          return DropdownMenuItem(
                            value: uid,
                            child: Text(
                              name,
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedMemberUid = value;
                            selectedMemberName =
                                memberNames[value] ?? "Colocataire";
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(52),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Annuler",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton(
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              minimumSize: const Size.fromHeight(52),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              "Ajouter",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
