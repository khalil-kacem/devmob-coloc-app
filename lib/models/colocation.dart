// lib/models/colocation.dart
class Colocation {
  final String id;
  final String name;
  final String inviteCode;
  final String adminId;
  final List<String> members;

  Colocation({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.adminId,
    required this.members,
  });

  factory Colocation.fromMap(Map<String, dynamic> map, String id) {
    return Colocation(
      id: id,
      name: map['name'] ?? '',
      inviteCode: map['inviteCode'] ?? '',
      adminId: map['adminId'] ?? '',
      members: List<String>.from(map['members'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'inviteCode': inviteCode,
      'adminId': adminId,
      'members': members,
    };
  }
}
