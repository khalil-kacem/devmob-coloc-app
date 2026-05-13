// lib/views/documents/documents_screen.dart
import 'dart:io';
import 'package:devmob_coloc_flutter_project/models/document.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/documents_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../services/file_service.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  final ImagePicker _picker = ImagePicker();
  final _urlController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final documentsAsync = ref.watch(documentsProvider);
    final colocationId = ref.watch(userColocationIdProvider);
    final currentUser = ref.watch(currentUserProvider).value;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickFromGallery(colocationId, currentUser),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Galerie"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUrlDialog(colocationId, currentUser),
                  icon: const Icon(Icons.link),
                  label: const Text("URL"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: documentsAsync.when(
              data: (docs) => docs.isEmpty
                  ? const Center(child: Text("Aucun document pour le moment"))
                  : ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index] as AppDocument;
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.picture_as_pdf,
                                color: Colors.red, size: 40),
                            title: Text(doc.name,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text("Par ${doc.uploadedByName}"),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("📄 ${doc.name}")));
                            },
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

  // Sélection depuis la galerie (images)
  Future<void> _pickFromGallery(
      String? colocationId, dynamic currentUser) async {
    if (colocationId == null || currentUser == null) return;

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final file = File(image.path);
      final success = await FileService().uploadDocument(
        colocationId,
        file,
        image.name,
        currentUser.uid,
        currentUser.displayName,
      );

      if (success != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("✅ Image ajoutée !")));
      }
    }
  }

  // Ajout via URL (pour PDF, contrats...)
  void _showUrlDialog(String? colocationId, dynamic currentUser) {
    if (colocationId == null || currentUser == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter via URL"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nom du document"),
            ),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(labelText: "URL du document"),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () {
              if (_urlController.text.isEmpty || _nameController.text.isEmpty)
                return;
              // Ajout direct via URL
              final doc = AppDocument(
                id: '',
                name: _nameController.text.trim(),
                url: _urlController.text.trim(),
                uploadedBy: currentUser.uid,
                uploadedByName: currentUser.displayName,
                uploadedAt: DateTime.now(),
                type: 'pdf',
              );
              FileService().addDocumentDirectly(colocationId, doc);
              _nameController.clear();
              _urlController.clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("✅ Document ajouté !")));
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }
}
