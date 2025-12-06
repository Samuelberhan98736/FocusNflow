import 'package:flutter/material.dart';

import '../models/room_model.dart';
import 'availability.dart';

/// Card showing a study room with availability state.
class RoomCard extends StatelessWidget {
  const RoomCard({
    super.key,
    required this.room,
    this.onTap,
    this.onAction,
    this.actionLabel,
  });

  final RoomModel room;
  final VoidCallback? onTap;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = room.isAvailable;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    AvailabilityIndicator(isAvailable: isAvailable),
                    if (room.reservedBy != null && !isAvailable) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Reserved',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (onAction != null)
                TextButton(
                  onPressed: onAction,
                  child: Text(actionLabel ?? (isAvailable ? 'Reserve' : 'Release')),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
