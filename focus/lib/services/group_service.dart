import 'package:cloud_firestore/cloud_firestore.dart';
import 'api_client.dart';

class GroupService {
  final _api = ApiClient.instance;
  final _db = FirebaseFirestore.instance;

  //cretae study group
  Future<String?> createGroup({
    required String name,
    required String course,
    String? description,
  }) async {
    try {
      final userId = _api.uuid;
      if (userId == null) return null;

      final groupRef = _db.collection("groups").doc();

      await groupRef.set({
        "groupId": groupRef.id,
        "name": name,
        "course": course,
        "description": description ?? "",
        "creatorId": userId,
        "members": [userId],
        "created_at": FieldValue.serverTimestamp(),
        "last_updated": FieldValue.serverTimestamp(),
      });

      return groupRef.id;
    } catch (e) {
      print("Error creating group: $e");
      return null;
    }
  }

  //join group
  Future<bool> joinGroup(String groupId) async {
    final userId = _api.uuid;
    if (userId == null) return false;

    try {
      await _db.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayUnion([userId]),
        "last_updated": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error joining group: $e");
      return false;
    }
  }

  //leave group
  Future<bool> leaveGroup(String groupId) async {
    final userId = _api.uuid;
    if (userId == null) return false;

    try {
      await _db.collection("groups").doc(groupId).update({
        "members": FieldValue.arrayRemove([userId]),
        "last_updated": FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print("Error leaving group: $e");
      return false;
    }
  }

  // group data
  Future<Map<String, dynamic>?> getGroup(String groupId) async {
    try {
      final doc = await _db.collection("groups").doc(groupId).get();
      return doc.data();
    } catch (e) {
      print("Error fetching group: $e");
      return null;
    }
  }


//get all the group the user is in
  Future<List<Map<String, dynamic>>> getUserGroups() async {
    final userId = _api.uuid;
    if (userId == null) return [];

    try {
      final snapshot = await _db
          .collection("groups")
          .where("members", arrayContains: userId)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting user groups: $e");
      return [];
    }
  }

  // realtime group updates
  Stream<Map<String, dynamic>?> groupStream(String groupId) {
    return _db.collection("groups").doc(groupId).snapshots().map((doc) {
      return doc.data();
    });
  }

//get all groups
  Future<List<Map<String, dynamic>>> getAllGroups() async {
    try {
      final snapshot = await _db.collection("groups").get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error getting all groups: $e");
      return [];
    }
  }
}
