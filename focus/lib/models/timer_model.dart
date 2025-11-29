class TimerModel {
  final String sessionId;
  final bool isFocusTime;
  final int remainingSeconds;
  final DateTime lastUpdated;

  TimerModel({
    required this.sessionId,
    required this.isFocusTime,
    required this.remainingSeconds,
    required this.lastUpdated,
  });

  factory TimerModel.fromMap(Map<String, dynamic> data) {
    return TimerModel(
      sessionId: data["sessionId"] ?? "",
      isFocusTime: data["isFocusTime"] ?? true,
      remainingSeconds: data["remainingSeconds"] ?? 0,
      lastUpdated:
          DateTime.tryParse(data["lastUpdated"]?.toString() ?? "") ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "sessionId": sessionId,
      "isFocusTime": isFocusTime,
      "remainingSeconds": remainingSeconds,
      "lastUpdated": lastUpdated.toIso8601String(),
    };
  }
}
