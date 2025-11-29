class MessageModel {
  final String messageId;
  final String senderId;
  final String text;
  final DateTime timestamp;

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> data) {
    return MessageModel(
      messageId: data["messageId"] ?? "",
      senderId: data["senderId"] ?? "",
      text: data["text"] ?? "",
      timestamp: DateTime.tryParse(data["timestamp"]?.toString() ?? "") ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "messageId": messageId,
      "senderId": senderId,
      "text": text,
      "timestamp": timestamp.toIso8601String(),
    };
  }
}
