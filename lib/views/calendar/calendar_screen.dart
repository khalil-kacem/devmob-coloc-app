// lib/views/calendar/calendar_screen.dart
import 'package:devmob_coloc_flutter_project/models/event.dart';
import 'package:devmob_coloc_flutter_project/providers/auth_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/calendar_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/calendar_service.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(eventsProvider);
    final colocationId = ref.watch(userColocationIdProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton.icon(
            onPressed: () => _showAddEventDialog(colocationId),
            icon: const Icon(Icons.add),
            label: Text("Ajouter un événement", style: GoogleFonts.poppins()),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: eventsAsync.when(
              data: (events) => events.isEmpty
                  ? const Center(child: Text("Aucun événement pour le moment"))
                  : ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index] as Event;
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.calendar_today,
                                color: Colors.deepOrange),
                            title: Text(event.title,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(event.description),
                            trailing:
                                Text(DateFormat('dd/MM').format(event.date)),
                          ),
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text("Erreur de chargement")),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(String? colocationId) {
    if (colocationId == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvel événement"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Titre")),
            TextField(
                controller: _descController,
                decoration: const InputDecoration(labelText: "Description")),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) _selectedDate = picked;
              },
              child: const Text("Choisir la date"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              if (_titleController.text.isEmpty) return;

              final user = ref.read(currentUserProvider).value!;
              final event = Event(
                id: '',
                title: _titleController.text.trim(),
                description: _descController.text.trim(),
                date: _selectedDate,
                createdBy: user.uid,
                createdByName: user.displayName,
              );

              CalendarService().addEvent(colocationId, event);

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
