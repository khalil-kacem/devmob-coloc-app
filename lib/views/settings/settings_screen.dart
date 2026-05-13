// lib/views/settings/settings_screen.dart
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:devmob_coloc_flutter_project/views/settings/members_management_screen.dart';
import 'package:devmob_coloc_flutter_project/views/settings/task_rules_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    final colocationAsync = ref.watch(currentColocationProvider);

    final colocation = colocationAsync.value;
    final isAdmin = colocation?.adminId == currentUser?.uid;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info Colocation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, size: 40, color: Colors.teal),
                  title: Text(colocation?.name ?? "Ma Colocation",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      "Code : ${colocation?.inviteCode ?? 'Non disponible'}"),
                ),
                const Divider(),
                ListTile(
                  title: const Text("Nombre de membres"),
                  trailing: Text("${colocation?.members.length ?? 1}"),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Espace Admin - Visible uniquement pour le référent
        if (isAdmin) ...[
          Card(
            color: Colors.orange.shade50,
            child: Column(
              children: [
                const ListTile(
                  leading:
                      Icon(Icons.admin_panel_settings, color: Colors.orange),
                  title: Text("Espace Admin (Référent)",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Gérer les membres"),
                  subtitle: const Text("Ajouter / Supprimer colocataires"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MembersManagementScreen())),
                ),
                ListTile(
                  leading: const Icon(Icons.rule),
                  title: const Text("Règles de répartition des tâches"),
                  subtitle: const Text("Définir les règles automatiques"),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const TaskRulesScreen())),
                ),
              ],
            ),
          ),
        ] else
          Card(
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Vous êtes un colocataire"),
              subtitle: Text("Seul le référent peut accéder à l'espace admin"),
            ),
          ),

        const SizedBox(height: 24),

        // Déconnexion
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text("Déconnexion",
                style: GoogleFonts.poppins(
                    color: Colors.red, fontWeight: FontWeight.w600)),
            onTap: () async {
              await ref.read(authProvider).signOut();
              if (context.mounted) Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ),
      ],
    );
  }
}
