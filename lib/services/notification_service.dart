// lib/services/notification_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/app_notification.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await FirebaseMessaging.instance.requestPermission();

    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: android);
    await _localNotifications.initialize(settings);
  }

  // Ajouter une notification + l'enregistrer dans Firestore
  static Future<void> sendNotification({
    required String colocationId,
    required String title,
    required String body,
    required String type,
    required String userId,
  }) async {
    // Notification locale
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'coloc_channel',
      'Notifications Coloc',
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
        DateTime.now().millisecond, title, body, details);

    // Sauvegarde dans Firestore
    final notification = AppNotification(
      id: '',
      title: title,
      body: body,
      type: type,
      timestamp: DateTime.now(),
    );

    await FirebaseFirestore.instance
        .collection('colocations')
        .doc(colocationId)
        .collection('notifications')
        .add(notification.toMap()); // On va ajouter toMap dans le modèle
  }
}
