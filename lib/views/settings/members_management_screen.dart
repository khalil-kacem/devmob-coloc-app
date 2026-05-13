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
      backgroundColor: const Color(0xffF5F7FB),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(
          "Gestion des membres",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ================= BODY =================
      body: colocationAsync.when(
        data: (colocation) {
          if (colocation == null) {
            return Center(
              child: Text(
                "Aucune colocation",
                style: GoogleFonts.poppins(),
              ),
            );
          }

          return Column(
            children: [
              const SizedBox(height: 16),

              // ADD BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddByEmailDialog(colocation.id),
                    icon: const Icon(Icons.person_add),
                    label: Text(
                      "Ajouter un membre",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // MEMBERS LIST
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: colocation.members.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final uid = colocation.members[index];
                    final isAdmin = uid == colocation.adminId;

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .get(),
                      builder: (context, snapshot) {
                        String name = "Utilisateur";
                        if (snapshot.hasData && snapshot.data!.exists) {
                          name = snapshot.data!['name'] ?? "Colocataire";
                        }

                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              // AVATAR
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: isAdmin
                                    ? Colors.orange.withOpacity(0.2)
                                    : Colors.teal.withOpacity(0.2),
                                child: Text(
                                  name.isNotEmpty ? name[0].toUpperCase() : "?",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color:
                                        isAdmin ? Colors.orange : Colors.teal,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              // NAME + ROLE
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isAdmin
                                          ? "Référent (Admin)"
                                          : "Colocataire",
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // ACTION
                              isAdmin
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "Admin",
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _kickMember(
                                        colocation.id,
                                        uid,
                                        name,
                                      ),
                                    ),
                            ],
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
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.teal,
          ),
        ),
        error: (_, __) => Center(
          child: Text(
            "Erreur de chargement",
            style: GoogleFonts.poppins(color: Colors.red),
          ),
        ),
      ),
    );
  }

  // ================= ADD MEMBER =================
  void _showAddByEmailDialog(String colocationId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          "Ajouter un membre",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: _emailController,
          style: GoogleFonts.poppins(),
          decoration: InputDecoration(
            hintText: "email@example.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Annuler",
              style: GoogleFonts.poppins(),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            onPressed: () => _addMemberByEmail(colocationId),
            child: Text(
              "Ajouter",
              style: GoogleFonts.poppins(
                color: Colors.white,
              ),
            ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Aucun utilisateur trouvé"),
          ),
        );
        return;
      }

      final userId = query.docs.first.id;

      await FirebaseFirestore.instance
          .collection('colocations')
          .doc(colocationId)
          .update({
        'members': FieldValue.arrayUnion([userId]),
      });

      _emailController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Membre ajouté avec succès"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }

  // ================= REMOVE MEMBER =================
  Future<void> _kickMember(
    String colocationId,
    String userId,
    String memberName,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirmer",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Expulser $memberName ?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Annuler",
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Expulser",
              style: GoogleFonts.poppins(
                color: Colors.red,
              ),
            ),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("$memberName expulsé"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur: $e")),
      );
    }
  }
}
