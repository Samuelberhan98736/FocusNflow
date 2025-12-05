import 'package:flutter/foundation.dart';

import '../models/message_model.dart';
import '../services/chat_service.dart';

/// Handles chat room lifecycle and messaging streams.
class ChatProvider extends ChangeNotifier {
  ChatProvider({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

  final ChatService _chatService;

  bool _isSending = false;
  String? _errorMessage;

  bool get isSending => _isSending;
  String? get errorMessage => _errorMessage;

  Future<String?> ensureRoom(List<String> memberIds) async {
    try {
      return await _chatService.createChatRoom(memberIds: memberIds);
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> sendMessage({
    required String roomId,
    required String text,
  }) async {
    _isSending = true;
    notifyListeners();
    await _chatService.sendMessage(roomId: roomId, text: text);
    _isSending = false;
    notifyListeners();
  }

  Stream<List<MessageModel>> watchMessages(String roomId) {
    return _chatService.messageStream(roomId).map((messages) {
      return messages.map(MessageModel.fromMap).toList();
    });
  }

  Future<List<MessageModel>> fetchRecentMessages(String roomId) async {
    final data = await _chatService.fetchMessages(roomId);
    return data.map(MessageModel.fromMap).toList();
  }

  Future<void> setTyping(String roomId, bool isTyping) =>
      _chatService.setTypingStatus(roomId, isTyping);

  Stream<Map<String, dynamic>> typingStatus(String roomId) =>
      _chatService.typingStream(roomId);
}
