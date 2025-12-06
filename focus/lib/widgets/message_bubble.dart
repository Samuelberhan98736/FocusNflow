import 'package:flutter/material.dart';

/// Chat bubble with alignment for sender/receiver.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    this.senderName,
    this.timestamp,
  });

  final String text;
  final bool isMe;
  final String? senderName;
  final DateTime? timestamp;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bubbleColor = isMe
        ? colorScheme.primaryContainer
        : colorScheme.surfaceVariant;
    final textColor =
        isMe ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) const SizedBox(width: 32),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (senderName != null && senderName!.isNotEmpty) ...[
                    Text(
                      senderName!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: textColor.withOpacity(0.8),
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    text,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: textColor),
                  ),
                  if (timestamp != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(timestamp!),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: textColor.withOpacity(0.7),
                            fontSize: 11,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (isMe) const SizedBox(width: 32),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final suffix = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }
}
