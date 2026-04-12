// lib/views/home/home_screen.dart
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const Center(
        child: Text("🏠 Accueil Dashboard\n(Prochainement : résumé global)",
            style: TextStyle(fontSize: 18))),
    const Center(child: Text("📋 Tâches\n(Feature 4 bientôt)")),
    const Center(child: Text("💰 Dépenses\n(Feature 5 bientôt)")),
    const Center(child: Text("💬 Chat\n(Feature 6 bientôt)")),
    const Center(child: Text("📄 Documents\n(Feature 7 bientôt)")),
  ];

  @override
  Widget build(BuildContext context) {
    final colocationAsync = ref.watch(currentColocationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: colocationAsync.when(
          data: (colocation) => Text(
            colocation?.name ?? "DEVMOB-Coloc'App",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          loading: () => const Text("Chargement..."),
          error: (_, __) => const Text("Ma Colocation"),
        ),
        backgroundColor: const Color(0xFF0A5BE1),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {}, // Notifications plus tard
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: const Color(0xFF0A5BE1),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tâches"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Dépenses"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: "Docs"),
        ],
      ),
    );
  }
}
