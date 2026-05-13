// lib/views/settings/members_management_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MembersManagementScreen extends ConsumerStatefulWidget {
  const MembersManagementScreen({super.key});

  @override
  ConsumerState<MembersManagementScreen> createState() =>
      _MembersManagementScreenState();
}

class _MembersManagementScreenState
    extends ConsumerState<MembersManagementScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final colocationAsync = ref.watch(currentColocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Gérer les membres",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A5BE1),
      ),
      body: colocationAsync.when(
        data: (colocation) {
          if (colocation == null)
            return const Center(child: Text("Aucune colocation"));

          return Column(
            children: [
              // Ajouter par email
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  onPressed: () => _showAddByEmailDialog(colocation.id),
                  icon: const Icon(Icons.person_add),
                  label:
                      Text("Ajouter par email", style: GoogleFonts.poppins()),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ),

              // Liste des membres
              Expanded(
                child: ListView.builder(
                  itemCount: colocation.members.length,
                  itemBuilder: (context, index) {
                    final uid = colocation.members[index];
                    final isAdmin = uid == colocation.adminId;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get(),
                      builder: (context, snapshot) {
                        String memberName = "Utilisateur inconnu";
                        if (snapshot.hasData && snapshot.data!.exists) {
                          memberName = snapshot.data!['name'] ?? "Colocataire";
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  isAdmin ? Colors.orange : Colors.teal,
                              child: Text(memberName[0].toUpperCase()),
                            ),
                            title: Text(memberName,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600)),
                            subtitle: Text(
                                isAdmin ? "Référent (Admin)" : "Colocataire"),
                            trailing: isAdmin
                                ? const Chip(
                                    label: Text("Admin"),
                                    backgroundColor: Colors.orange,
                                    labelStyle: TextStyle(color: Colors.white))
                                : IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () => _kickMember(
                                        colocation.id, uid, memberName),
                                  ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Erreur de chargement")),
      ),
    );
  }

  // ==================== AJOUTER PAR EMAIL ====================
  void _showAddByEmailDialog(String colocationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un membre"),
        content: TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: "exemple@email.com",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () => _addMemberByEmail(colocationId),
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  Future<void> _addMemberByEmail(String colocationId) async {
    final email = _emailController.text.trim().toLowerCase();
    if (email.isEmpty) return;

    Navigator.pop(context);

    try {
      final query = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("❌ Aucun utilisateur trouvé avec cet email")));
        return;
      }

      final userId = query.docs.first.id;

      await FirebaseFirestore.instance
          .collection('colocations')
          .doc(colocationId)
          .update({
        'members': FieldValue.arrayUnion([userId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Membre ajouté avec succès !")));
      _emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }

  // ==================== SUPPRIMER (KICK) MEMBRE ====================
  Future<void> _kickMember(
      String colocationId, String userId, String memberName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Expulser le membre ?"),
        content: Text(
            "Voulez-vous vraiment expulser $memberName de la colocation ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Annuler")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Expulser", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('colocations')
          .doc(colocationId)
          .update({
        'members': FieldValue.arrayRemove([userId]),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("$memberName a été expulsé")));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erreur : $e")));
    }
  }
}
