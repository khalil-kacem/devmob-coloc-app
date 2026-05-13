// lib/main.dart
import 'package:devmob_coloc_flutter_project/services/notification_service.dart';
import 'package:devmob_coloc_flutter_project/views/auth/login_page.dart';
import 'package:devmob_coloc_flutter_project/views/home/Starting_page.dart';
import 'package:devmob_coloc_flutter_project/views/home/colocation_screen.dart';
import 'package:devmob_coloc_flutter_project/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

// Dans main.dart, modifie le main() comme ceci :

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialiser les notifications
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "DEVMOB-Coloc'App",
      theme: ThemeData(primarySwatch: Colors.teal),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const BinomePage(),
        '/colocation': (context) => const ColocationScreen(),
        '/home': (context) => const HomeScreen(), // ← Nouveau dashboard
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
