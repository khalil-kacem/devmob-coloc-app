// lib/views/notifications/notifications_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devmob_coloc_flutter_project/models/app_notification.dart';
import 'package:devmob_coloc_flutter_project/providers/colocation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colocationId = ref.watch(userColocationIdProvider);

    if (colocationId == null) {
      return const Center(child: Text("Aucune colocation active"));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A5BE1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('colocations')
            .doc(colocationId)
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("Aucune notification pour le moment"),
                ],
              ),
            );
          }

          final notifications = snapshot.data!.docs.map((doc) {
            return AppNotification.fromMap(
                doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notif = notifications[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.blue),
                  title: Text(notif.title,
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  subtitle: Text(notif.body),
                  trailing: Text(
                    DateFormat('HH:mm').format(notif.timestamp),
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
