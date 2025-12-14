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
    {
      "roomId": "601",
      "name": "Room 601",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7525,
      "lng": -84.3868,
    },
    {
      "roomId": "602",
      "name": "Room 602",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7526,
      "lng": -84.3866,
    },
    {
      "roomId": "603",
      "name": "Room 603",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7527,
      "lng": -84.3864,
    },
    {
      "roomId": "604",
      "name": "Room 604",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7528,
      "lng": -84.3862,
    },
    {
      "roomId": "605",
      "name": "Room 605",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7529,
      "lng": -84.386,
    },
    {
      "roomId": "606",
      "name": "Room 606",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.753,
      "lng": -84.3858,
    },
    {
      "roomId": "607",
      "name": "Room 607",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7531,
      "lng": -84.3856,
    },
    {
      "roomId": "608",
      "name": "Room 608",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7532,
      "lng": -84.3854,
    },
    {
      "roomId": "609",
      "name": "Room 609",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7533,
      "lng": -84.3852,
    },
    {
      "roomId": "610",
      "name": "Room 610",
      "isAvailable": true,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7534,
      "lng": -84.385,
    },
    {
      "roomId": "611",
      "name": "Room 611",
      "isAvailable": false,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7535,
      "lng": -84.3848,
    },
    {
      "roomId": "612",
      "name": "Room 612",
      "isAvailable": false,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7536,
      "lng": -84.3846,
    },
    {
      "roomId": "613",
      "name": "Room 613",
      "isAvailable": false,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7537,
      "lng": -84.3844,
    },
    {
      "roomId": "614",
      "name": "Room 614",
      "isAvailable": false,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7538,
      "lng": -84.3842,
    },
    {
      "roomId": "615",
      "name": "Room 615",
      "isAvailable": false,
      "reserved_by": null,
      "reserved_at": null,
      "last_updated": null,
      "lat": 33.7539,
      "lng": -84.384,
    },
  ],
);
