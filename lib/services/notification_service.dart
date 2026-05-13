// lib/services/notification_service.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Demander la permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("✅ Notifications autorisées");
    }

    // Gérer les notifications en foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Notification reçue : ${message.notification?.title}");
      // Tu peux afficher un SnackBar ou une dialog ici
    });
  }

  Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
