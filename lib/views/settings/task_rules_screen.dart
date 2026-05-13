// lib/views/settings/task_rules_screen.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskRulesScreen extends StatelessWidget {
  const TaskRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      // ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(
          "Règles de la colocation",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Règles générales",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Définies par le référent",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // SECTIONS
            _buildSection(
              title: "Tâches ménagères",
              color: Colors.teal,
              icon: Icons.cleaning_services_rounded,
              rules: const [
                "Chaque colocataire doit participer équitablement aux tâches.",
                "La rotation des tâches se fait chaque semaine.",
                "Les tâches doivent être validées une fois terminées.",
                "Les tâches non faites entraînent un rappel automatique.",
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              title: "Dépenses",
              color: Colors.orange,
              icon: Icons.attach_money_rounded,
              rules: const [
                "Toute dépense importante doit être validée par le référent.",
                "Les dépenses sont réparties équitablement entre les membres.",
                "Les remboursements doivent être effectués dans les délais.",
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              title: "Vie commune",
              color: Colors.blue,
              icon: Icons.home_rounded,
              rules: const [
                "Respect et propreté des espaces communs obligatoires.",
                "Les invités doivent être signalés à l'avance.",
                "Le calme est respecté après 23h.",
                "Les poubelles doivent être sorties régulièrement.",
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required Color color,
    required IconData icon,
    required List<String> rules,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER SECTION
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff1E293B),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // RULES LIST
          ...rules.map(
            (rule) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: color,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rule,
                      style: GoogleFonts.poppins(
                        fontSize: 13.5,
                        height: 1.4,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
