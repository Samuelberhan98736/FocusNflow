import 'package:cloud_firestore/cloud_firestore.dart';
import 'api_client.dart';

class ScheduleService {
  final _api = ApiClient.instance;
  final _db = FirebaseFirestore.instance;

  // Create a scheduled study session
  Future<String?> createSession({
    required String groupId,
    required DateTime startTime,
    required DateTime endTime,
    String? location,
    String? notes,
  }) async {
    final userId = _api.uid;
    if (userId == null) return null;

    try {
      final sessionRef = _db.collection("study_sessions").doc();

      await sessionRef.set({
        "sessionId": sessionRef.id,
        "groupId": groupId,
        "creatorId": userId,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "location": location ?? "",
        "notes": notes ?? "",
        "members": [userId],
        "created_at": FieldValue.serverTimestamp(),
        "last_updated": FieldValue.serverTimestamp(),
      });

      return sessionRef.id;
    } catch (e) {
      print("Error creating session: $e");
      return null;
    }
  }

  // Join a scheduled session
  Future<bool> joinSession(String sessionId) async {
    final userId = _api.uid;
    if (userId == null) return false;

    try {
      await _db.collection("study_sessions").doc(sessionId).update({
        "members": FieldValue.arrayUnion([userId]),
        "last_updated": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error joining session: $e");
      return false;
    }
  }

  // Leave a scheduled session
  Future<bool> leaveSession(String sessionId) async {
    final userId = _api.uid;
    if (userId == null) return false;

    try {
      await _db.collection("study_sessions").doc(sessionId).update({
        "members": FieldValue.arrayRemove([userId]),
        "last_updated": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error leaving session: $e");
      return false;
    }
  }

  // Update session details
  Future<bool> updateSession(
    String sessionId,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates["last_updated"] = FieldValue.serverTimestamp();

      await _db.collection("study_sessions").doc(sessionId).update(updates);
      return true;
    } catch (e) {
      print("Error updating session: $e");
      return false;
    }
  }

  // Get a session's details once
  Future<Map<String, dynamic>?> getSession(String sessionId) async {
    try {
      final doc =
          await _db.collection("study_sessions").doc(sessionId).get();
      return doc.data();
    } catch (e) {
      print("Error getting session: $e");
      return null;
    }
  }

  // Live updates for a session (real-time)
  Stream<Map<String, dynamic>?> sessionStream(String sessionId) {
    return _db
        .collection("study_sessions")
        .doc(sessionId)
        .snapshots()
        .map((doc) => doc.data());
  }

  // Get all sessions for a specific group
  Future<List<Map<String, dynamic>>> getGroupSessions(String groupId) async {
    try {
      final snapshot = await _db
          .collection("study_sessions")
          .where("groupId", isEqualTo: groupId)
          .orderBy("startTime")
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting group sessions: $e");
      return [];
    }
  }

  // Get all sessions that the current user is attending
  Future<List<Map<String, dynamic>>> getUserSessions() async {
    final userId = _api.uid;
    if (userId == null) return [];

    try {
      final snapshot = await _db
          .collection("study_sessions")
          .where("members", arrayContains: userId)
          .orderBy("startTime")
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting user sessions: $e");
      return [];
    }
  }
}
