// lib/views/home/home_screen.dart
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:devmob_coloc_flutter_project/providers/tasks_provider.dart';
import 'package:devmob_coloc_flutter_project/views/calendar/calendar_screen.dart';
import 'package:devmob_coloc_flutter_project/views/chat/chat_screen.dart';
import 'package:devmob_coloc_flutter_project/views/documents/documents_screen.dart';
import 'package:devmob_coloc_flutter_project/views/expenses/expenses_screen.dart';
import 'package:devmob_coloc_flutter_project/views/shopping/shopping_screen.dart';
import 'package:devmob_coloc_flutter_project/views/tasks/tasks_screen.dart';
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
        child: Text("🏠 Tableau de bord\nRésumé de la colocation",
            style: TextStyle(fontSize: 20))),
    const TasksScreen(), // ← Écran réel des tâches
    const ExpensesScreen(), // ← Écran réel des dépenses
    const ChatScreen(),
    const DocumentsScreen(),
    const CalendarScreen(),
    const ShoppingScreen()
  ];

  @override
  Widget build(BuildContext context) {
    final colocationAsync = ref.watch(currentColocationProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: colocationAsync.when(
          data: (coloc) => Text(coloc?.name ?? "DEVMOB-Coloc'App",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          loading: () => const Text("Chargement..."),
          error: (_, __) => const Text("Ma Colocation"),
        ),
        backgroundColor: const Color(0xFF0A5BE1),
        foregroundColor: Colors.white,
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
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: "Tâches"),
          BottomNavigationBarItem(
              icon: Icon(Icons.attach_money), label: "Dépenses"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: "Chat"),
          BottomNavigationBarItem(icon: Icon(Icons.folder_copy), label: "Docs"),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_copy), label: "Calendrier"),
          BottomNavigationBarItem(
              icon: Icon(Icons.folder_copy), label: "Shopping"),
        ],
      ),
    );
  }
}
