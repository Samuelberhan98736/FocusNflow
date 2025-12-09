import 'package:cloud_firestore/cloud_firestore.dart';
import 'api_client.dart';

class RoomService {
  final _api = ApiClient.instance;
  final _db = FirebaseFirestore.instance;
  bool _seedAttempted = false;

  // Seed default rooms if Firestore is empty (helps first-time setup/dev).
  Future<void> seedDefaultRoomsIfEmpty() async {
    if (_seedAttempted) return;
    _seedAttempted = true;

    try {
      final existing = await _db.collection("study_rooms").limit(1).get();
      if (existing.docs.isNotEmpty) return;

      final batch = _db.batch();
      for (final room in _defaultRooms) {
        final ref = _db.collection("study_rooms").doc(room["roomId"] as String);
        batch.set(ref, room);
      }
      await batch.commit();
    } catch (e) {
      print("Error seeding rooms: $e");
      _seedAttempted = false; // allow retry later
    }
  }

  // Get all study rooms once
  Future<List<Map<String, dynamic>>> getAllRooms() async {
    try {
      final snapshot = await _db.collection("study_rooms").get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting rooms: $e");
      return [];
    }
  }

  // Stream of all rooms for real-time updates
  Stream<List<Map<String, dynamic>>> roomStream() {
    return _db.collection("study_rooms").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // Get a single room's details
  Future<Map<String, dynamic>?> getRoom(String roomId) async {
    try {
      final doc = await _db.collection("study_rooms").doc(roomId).get();
      return doc.data();
    } catch (e) {
      print("Error fetching room $roomId: $e");
      return null;
    }
  }

  // Update room availability (true = free, false = occupied)
  Future<bool> updateRoomAvailability({
    required String roomId,
    required bool isAvailable,
  }) async {
    try {
      await _db.collection("study_rooms").doc(roomId).update({
        "isAvailable": isAvailable,
        "last_updated": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error updating availability: $e");
      return false;
    }
  }

  // Reserve a room for the current user
  Future<bool> reserveRoom(String roomId) async {
    final userId = _api.uid;
    if (userId == null) return false;

    try {
      await _db.collection("study_rooms").doc(roomId).update({
        "isAvailable": false,
        "reserved_by": userId,
        "reserved_at": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error reserving room: $e");
      return false;
    }
  }

  // Release a room
  Future<bool> releaseRoom(String roomId) async {
    try {
      await _db.collection("study_rooms").doc(roomId).update({
        "isAvailable": true,
        "reserved_by": null,
        "reserved_at": null,
        "last_updated": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error releasing room: $e");
      return false;
    }
  }
}

final List<Map<String, dynamic>> _defaultRooms = List.unmodifiable(
  [
    for (var i = 601; i <= 610; i++)
      {
        "roomId": "$i",
        "name": "Room $i",
        "isAvailable": true,
        "reserved_by": null,
        "reserved_at": null,
        "last_updated": null,
      },
    for (var i = 611; i <= 615; i++)
      {
        "roomId": "$i",
        "name": "Room $i",
        "isAvailable": false,
        "reserved_by": null,
        "reserved_at": null,
        "last_updated": null,
      },
  ],
);
