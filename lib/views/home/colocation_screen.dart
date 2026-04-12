import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';
import '../../providers/colocation_provider.dart';
import '../../services/colocation_service.dart';

class ColocationScreen extends ConsumerStatefulWidget {
  const ColocationScreen({super.key});

  @override
  ConsumerState<ColocationScreen> createState() => _ColocationScreenState();
}

class _ColocationScreenState extends ConsumerState<ColocationScreen> {
  final _nameController = TextEditingController(); // from first version
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              /// Create colocation button (same design)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D5BE1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _createColocation,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Créer une nouvelle colocation",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 35),

              Text(
                "ou",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 35),

              /// Invite code field (same design)
              TextField(
                controller: _inviteCodeController,
                textCapitalization: TextCapitalization.characters,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Code d'invitation (6 caractères)",
                  hintStyle: GoogleFonts.poppins(
                    color: Colors.black26,
                    fontSize: 14,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0D5BE1)),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              /// Join button (same design)
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D5BE1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isLoading ? null : _joinColocation,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Rejoindre avec un code",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
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

  /// UPDATED LOGIC (from first file)
  Future<void> _createColocation() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) throw Exception("Utilisateur non connecté");

      final service = ColocationService();
      final colocation = await service.createColocation(
        _nameController.text.isEmpty ? "Ma Colocation" : _nameController.text,
        user.uid,
      );

      ref.read(userColocationIdProvider.notifier).state = colocation.id;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "✅ Colocation créée ! Code : ${colocation.inviteCode}",
              style: GoogleFonts.poppins(),
            ),
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur : $e",
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// UPDATED LOGIC (from first file)
  Future<void> _joinColocation() async {
    final code = _inviteCodeController.text.trim().toUpperCase();

    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Code invalide (6 caractères requis)",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) throw Exception("Utilisateur non connecté");

      final service = ColocationService();
      final colocation = await service.joinColocation(code, user.uid);

      if (colocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Code d'invitation invalide",
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      } else {
        ref.read(userColocationIdProvider.notifier).state = colocation.id;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "✅ Bienvenue dans la colocation !",
                style: GoogleFonts.poppins(),
              ),
            ),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Erreur : $e",
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
