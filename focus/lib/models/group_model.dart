class GroupModel {
  final String groupId;
  final String name;
  final String course;
  final String description;
  final String creatorId;
  final List<String> members;
  final DateTime createdAt;
  final DateTime lastUpdated;

  GroupModel({
    required this.groupId,
    required this.name,
    required this.course,
    required this.description,
    required this.creatorId,
    required this.members,
    required this.createdAt,
    required this.lastUpdated,
  });

  factory GroupModel.fromMap(Map<String, dynamic> data) {
    return GroupModel(
      groupId: data["groupId"] ?? "",
      name: data["name"] ?? "",
      course: data["course"] ?? "",
      description: data["description"] ?? "",
      creatorId: data["creatorId"] ?? "",
      members: List<String>.from(data["members"] ?? []),
      createdAt: DateTime.tryParse(data["created_at"]?.toString() ?? "") ??
          DateTime.now(),
      lastUpdated:
          DateTime.tryParse(data["last_updated"]?.toString() ?? "") ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "groupId": groupId,
      "name": name,
      "course": course,
      "description": description,
      "creatorId": creatorId,
      "members": members,
      "created_at": createdAt.toIso8601String(),
      "last_updated": lastUpdated.toIso8601String(),
    };
  }
}
