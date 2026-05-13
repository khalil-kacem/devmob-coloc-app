// lib/views/settings/settings_screen.dart
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
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
        // Informations de la colocation
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.home, size: 40, color: Colors.teal),
                  title: Text(
                    colocation?.name ?? "Ma Colocation",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
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

        // Notifications
        Card(
          child: ListTile(
            leading: const Icon(Icons.notifications_active, color: Colors.blue),
            title: const Text("Notifications"),
            subtitle: const Text("Activées"),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
        ),

        const SizedBox(height: 16),

        // Section Admin (visible uniquement par le référent)
        if (isAdmin)
          Card(
            color: Colors.orange.shade50,
            child: Column(
              children: [
                const ListTile(
                  leading:
                      Icon(Icons.admin_panel_settings, color: Colors.orange),
                  title: Text("Vous êtes le Référent",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Vous avez les droits d'administration"),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("Gérer les membres"),
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("Gestion des membres - Bientôt disponible")),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.rule),
                  title: const Text("Règles de la colocation"),
                  onTap: () {},
                ),
              ],
            ),
          )
        else
          Card(
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("Vous êtes un colocataire"),
              subtitle: Text("Seul le référent peut gérer la colocation"),
            ),
          ),

        const SizedBox(height: 24),

        // Déconnexion
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              "Déconnexion",
              style: GoogleFonts.poppins(
                  color: Colors.red, fontWeight: FontWeight.w600),
            ),
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
