// lib/views/settings/task_rules_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskRulesScreen extends StatelessWidget {
  const TaskRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Règles de la Colocation",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A5BE1),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Règles Générales de la Colocation",
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Définies par le Référent",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Règles des tâches
            _buildSectionTitle("📋 Règles des Tâches Ménagères"),
            _buildRuleItem(
                "Chaque colocataire doit participer équitablement aux tâches."),
            _buildRuleItem("La rotation des tâches se fait chaque semaine."),
            _buildRuleItem(
                "Les tâches doivent être marquées comme terminées avant minuit."),
            _buildRuleItem(
                "Toute tâche non faite entraîne un rappel automatique."),

            const SizedBox(height: 20),

            // Règles des dépenses
            _buildSectionTitle("💰 Règles des Dépenses"),
            _buildRuleItem(
                "Toute dépense supérieure à 50 DT doit être validée par le référent."),
            _buildRuleItem(
                "Les dépenses sont réparties équitablement entre tous les membres."),
            _buildRuleItem(
                "Les remboursements doivent être effectués dans les 7 jours."),

            const SizedBox(height: 20),

            // Règles générales
            _buildSectionTitle("🏠 Règles Générales"),
            _buildRuleItem(
                "Le respect et la propreté des espaces communs sont obligatoires."),
            _buildRuleItem("Les invités doivent être signalés à l'avance."),
            _buildRuleItem("Le calme est respecté après 23h."),
            _buildRuleItem(
                "Les poubelles doivent être sorties selon le planning."),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
      ),
    );
  }

  Widget _buildRuleItem(String rule) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.teal, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              rule,
              style: GoogleFonts.poppins(fontSize: 15, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
