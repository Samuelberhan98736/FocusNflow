import 'package:flutter/material.dart';

import '../models/schedule_model.dart';
import '../utils/time_formattor.dart';

/// Displays a scheduled study session summary.
class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.session,
    this.groupName,
    this.onTap,
    this.onAction,
    this.actionLabel,
  });

  final ScheduleModel session;
  final String? groupName;
  final VoidCallback? onTap;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final timeRange =
        '${formatTimeOfDay(session.startTime)} - ${formatTimeOfDay(session.endTime)}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupName ?? 'Study Session',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                formatShortDate(session.startTime),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 6),
                  Text(timeRange, style: theme.textTheme.bodyMedium),
                ],
              ),
              if (session.location.isNotEmpty) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        session.location,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
              if (session.notes.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  session.notes,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${session.members.length} attendee${session.members.length == 1 ? '' : 's'}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (onAction != null)
                    TextButton(
                      onPressed: onAction,
                      child: Text(actionLabel ?? 'Join'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
