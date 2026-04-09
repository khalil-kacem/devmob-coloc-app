// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

final authProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  AppUser? _userFromFirebase(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Utilisateur',
      photoUrl: user.photoURL,
    );
  }

  Future<AppUser?> signInWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return _userFromFirebase(result.user);
  }

  Future<AppUser?> registerWithEmail(
      String email, String password, String name) async {
    final result = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await result.user?.updateDisplayName(name);
    return _userFromFirebase(result.user);
  }

  Future<AppUser?> signInWithGoogle() async {
    // On implémentera Google plus tard si tu veux
    throw UnimplementedError('Google à venir');
  }

  Future<void> signOut() async => await _auth.signOut();
}
