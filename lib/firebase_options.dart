import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAV89uWLaUKkS87jOpZeU9votKFL8iCl2c',
    appId: '1:787220096123:android:42175ec30d752c5d312ede',
    messagingSenderId: '787220096123',
    projectId: 'devmob-coloc-app',
    storageBucket: 'devmob-coloc-app.firebasestorage.app',
  );
}
