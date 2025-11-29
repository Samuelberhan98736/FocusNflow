import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'api_client.dart';

class ChatService {
  final _api = ApiClient.instance;
  final _db = FirebaseFirestore.instance;

  
  //create the chat room if it didn't exist
  
  Future<String> createChatRoom({
    required List<String> memberIds,
  }) async {
    try {
      // Sort IDs for predictable unique chat room name
      memberIds.sort();
      final roomId = memberIds.join("_");

      final roomRef = _db.collection("chat_rooms").doc(roomId);

      final exists = await roomRef.get();
      if (!exists.exists) {
        await roomRef.set({
          "roomId": roomId,
          "members": memberIds,
          "created_at": FieldValue.serverTimestamp(),
        });
      }

      return roomId;
    } catch (e) {
      print("Error creating chat room: $e");
      rethrow;
    }
  }

  // send message
  Future<void> sendMessage({
    required String roomId,
    required String text,
  }) async {
    try {
      final userId = _api.uid;
      if (userId == null) return;

      final msgRef = _db
          .collection("chat_rooms")
          .doc(roomId)
          .collection("messages")
          .doc();

      await msgRef.set({
        "messageId": msgRef.id,
        "senderId": userId,
        "text": text,
        "timestamp": FieldValue.serverTimestamp(),
      });

      // update chat room last activity
      await _db.collection("chat_rooms").doc(roomId).update({
        "last_message": text,
        "last_sender": userId,
        "last_timestamp": FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error sending message: $e");
    }
  }

  //live chat
  Stream<List<Map<String, dynamic>>> messageStream(String roomId) {
    return _db
        .collection("chat_rooms")
        .doc(roomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => doc.data()).toList());
  }

  //mesage history
  Future<List<Map<String, dynamic>>> fetchMessages(String roomId) async {
    try {
      final query = await _db
          .collection("chat_rooms")
          .doc(roomId)
          .collection("messages")
          .orderBy("timestamp", descending: true)
          .limit(50)
          .get();

      return query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching messages: $e");
      return [];
    }
  }

  // showing the typing
  Future<void> setTypingStatus(String roomId, bool isTyping) async {
    final userId = _api.uid;
    if (userId == null) return;

    await _db
        .collection("chat_rooms")
        .doc(roomId)
        .collection("typing")
        .doc(userId)
        .set({
      "isTyping": isTyping,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  Stream<Map<String, dynamic>> typingStream(String roomId) {
    return _db
        .collection("chat_rooms")
        .doc(roomId)
        .collection("typing")
        .snapshots()
        .map((snapshot) {
      Map<String, dynamic> result = {};
      for (var doc in snapshot.docs) {
        result[doc.id] = doc.data();
      }
      return result;
    });
  }
}
