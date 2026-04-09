// lib/models/user.dart
class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final String? colocationId; // ← NOUVEAU

  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.colocationId,
  });

  AppUser copyWith({String? colocationId}) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      colocationId: colocationId ?? this.colocationId,
    );
  }
}
