class RoomModel {
  final String roomId;
  final String name;
  final bool isAvailable;
  final String? reservedBy;
  final DateTime? reservedAt;

  RoomModel({
    required this.roomId,
    required this.name,
    required this.isAvailable,
    this.reservedBy,
    this.reservedAt,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data) {
    return RoomModel(
      roomId: data["roomId"] ?? "",
      name: data["name"] ?? "",
      isAvailable: data["isAvailable"] ?? true,
      reservedBy: data["reserved_by"],
      reservedAt: data["reserved_at"] != null
          ? DateTime.tryParse(data["reserved_at"].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "roomId": roomId,
      "name": name,
      "isAvailable": isAvailable,
      "reserved_by": reservedBy,
      "reserved_at": reservedAt?.toIso8601String(),
    };
  }
}
