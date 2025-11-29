class ScheduleModel {
  final String sessionId;
  final String groupId;
  final String creatorId;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String notes;
  final List<String> members;

  ScheduleModel({
    required this.sessionId,
    required this.groupId,
    required this.creatorId,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.notes,
    required this.members,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> data) {
    return ScheduleModel(
      sessionId: data["sessionId"] ?? "",
      groupId: data["groupId"] ?? "",
      creatorId: data["creatorId"] ?? "",
      startTime: DateTime.tryParse(data["startTime"]?.toString() ?? "") ??
          DateTime.now(),
      endTime:
          DateTime.tryParse(data["endTime"]?.toString() ?? "") ??
              DateTime.now(),
      location: data["location"] ?? "",
      notes: data["notes"] ?? "",
      members: List<String>.from(data["members"] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sessionId": sessionId,
      "groupId": groupId,
      "creatorId": creatorId,
      "startTime": startTime.toIso8601String(),
      "endTime": endTime.toIso8601String(),
      "location": location,
      "notes": notes,
      "members": members,
    };
  }
}
