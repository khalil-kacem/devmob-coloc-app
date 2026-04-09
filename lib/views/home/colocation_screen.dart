// lib/views/home/colocation_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/colocation_provider.dart';
import '../../services/colocation_service.dart';

class ColocationScreen extends ConsumerStatefulWidget {
  const ColocationScreen({super.key});

  @override
  ConsumerState<ColocationScreen> createState() => _ColocationScreenState();
}

class _ColocationScreenState extends ConsumerState<ColocationScreen> {
  final _nameController = TextEditingController();
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ma Colocation")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "DEVMOB-Coloc'App",
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _createColocation(),
              child: const Text("Créer une nouvelle colocation"),
            ),
            const SizedBox(height: 20),
            const Text("ou", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            TextField(
              controller: _inviteCodeController,
              decoration: const InputDecoration(
                labelText: "Code d'invitation (6 caractères)",
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () => _joinColocation(),
              child: const Text("Rejoindre avec un code"),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createColocation() async {
    setState(() => _isLoading = true);
    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) throw Exception("Utilisateur non connecté");

      final service = ColocationService();
      final colocation = await service.createColocation(
        _nameController.text.isEmpty ? "Ma colocation" : _nameController.text,
        user.uid,
      );

      // Mise à jour du provider Riverpod
      ref.read(userColocationIdProvider.notifier).state = colocation.id;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text("✅ Colocation créée ! Code : ${colocation.inviteCode}")),
        );
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur : $e")));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _joinColocation() async {
    final code = _inviteCodeController.text.trim().toUpperCase();
    if (code.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code invalide (6 caractères requis)")),
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Code d'invitation invalide")),
          );
        }
      } else {
        // Mise à jour du provider Riverpod
        ref.read(userColocationIdProvider.notifier).state = colocation.id;

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Bienvenue dans la colocation !")),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Erreur : $e")));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
