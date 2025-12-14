class RoomModel {
  final String roomId;
  final String name;
  final bool isAvailable;
  final String? reservedBy;
  final DateTime? reservedAt;
  final double? latitude;
  final double? longitude;

  RoomModel({
    required this.roomId,
    required this.name,
    required this.isAvailable,
    this.reservedBy,
    this.reservedAt,
    this.latitude,
    this.longitude,
  });

  factory RoomModel.fromMap(Map<String, dynamic> data) {
    double? _parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    return RoomModel(
      roomId: data["roomId"] ?? "",
      name: data["name"] ?? "",
      isAvailable: data["isAvailable"] ?? true,
      reservedBy: data["reserved_by"],
      reservedAt: data["reserved_at"] != null
          ? DateTime.tryParse(data["reserved_at"].toString())
          : null,
      latitude: _parseDouble(data["lat"]),
      longitude: _parseDouble(data["lng"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "roomId": roomId,
      "name": name,
      "isAvailable": isAvailable,
      "reserved_by": reservedBy,
      "reserved_at": reservedAt?.toIso8601String(),
      "lat": latitude,
      "lng": longitude,
    };
  }
}
