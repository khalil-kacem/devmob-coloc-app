// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError('Web not supported yet');
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError('Platform not supported');
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'AIzaSyAV89uWLaUKkS87jOpZeU9votKFL8iCl2c', // ← Remplace par ta clé API Android Firebase
    appId: '1:787220096123:android:42175ec30d752c5d312ede',
    messagingSenderId: '1234567890',
    projectId: 'devmob-coloc-app',
    storageBucket: 'devmob-coloc-app.appspot.com', // format correct
  );
}
