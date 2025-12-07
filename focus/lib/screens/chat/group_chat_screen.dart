import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/message_model.dart';
import '../../services/api_client.dart';
import '../../services/chat_service.dart';
import '../../utils/snackbar.dart';
import '../../widgets/message_bubble.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key, this.roomId});

  final String? roomId;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _messageController = TextEditingController();
  final _listController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(ChatService chat, String roomId) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    await chat.sendMessage(roomId: roomId, text: text);
    _messageController.clear();
    if (_listController.hasClients) {
      _listController.animateTo(
        _listController.position.maxScrollExtent + 80,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.read<ChatService>();
    final roomId = widget.roomId ?? ModalRoute.of(context)?.settings.arguments as String?;

    if (roomId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Group Chat')),
        body: const Center(child: Text('No room specified')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Group Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chat.messageStream(roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = (snapshot.data ?? [])
                    .map(MessageModel.fromMap)
                    .toList();
                final myId = ApiClient.instance.uid;

                return ListView.builder(
                  controller: _listController,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  itemCount: messages.length,
                  itemBuilder: (_, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == myId;
                    return MessageBubble(
                      text: msg.text,
                      isMe: isMe,
                      timestamp: msg.timestamp,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                    onSubmitted: (_) => _sendMessage(chat, roomId),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(chat, roomId),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.copy),
        onPressed: () {
          showAppSnackBar(context, 'Room ID: $roomId');
        },
      ),
    );
  }
}
