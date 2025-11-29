class UserModel {
  // User fields
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;
  final DateTime lastActive;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
    required this.lastActive,
  });

  // Create UserModel from Firestore data
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data["uid"] ?? "",
      email: data["email"] ?? "",
      name: data["name"] ?? "",
      createdAt: DateTime.tryParse(data["created_at"]?.toString() ?? "") ??
          DateTime.now(),
      lastActive: DateTime.tryParse(data["last_active"]?.toString() ?? "") ??
          DateTime.now(),
    );
  }

  // Convert model back to JSON for Firestore
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "email": email,
      "name": name,
      "created_at": createdAt.toIso8601String(),
      "last_active": lastActive.toIso8601String(),
    };
  }
}
