// lib/providers/colocation_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/colocation_service.dart';
import '../models/colocation.dart';
import '../models/user.dart';
import 'auth_provider.dart';

/// Service Colocation (toujours disponible)
final colocationServiceProvider = Provider<ColocationService>(
  (ref) => ColocationService(),
);

/// Utilisateur actuel (mis à jour en temps réel via Firebase Auth)
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authProvider).authStateChanges.map((user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? 'Utilisateur',
      photoUrl: user.photoURL,
      colocationId:
          null, // on le mettra à jour quand l'utilisateur rejoint/crée une colocation
    );
  });
});

/// ID de la colocation de l'utilisateur actuel (mis à jour manuellement après création/rejoindre)
final userColocationIdProvider = StateProvider<String?>((ref) => null);

/// Colocation actuelle de l'utilisateur (stream Firestore)
final currentColocationProvider =
    StreamProvider.autoDispose<Colocation?>((ref) {
  final colocationId = ref.watch(userColocationIdProvider);

  if (colocationId == null || colocationId.isEmpty) {
    return Stream.value(null);
  }

  final service = ref.watch(colocationServiceProvider);
  return service.getColocationStream(colocationId);
});
