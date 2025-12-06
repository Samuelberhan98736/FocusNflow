import 'package:flutter/material.dart';

import '../models/group_model.dart';
import 'availability.dart';

/// Card summarizing a study group.
class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.onJoin,
    this.isMember = false,
  });

  final GroupModel group;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final bool isMember;

  @override
  Widget build(BuildContext context) {
    final membersCount = group.members.length;
    final theme = Theme.of(context);

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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          group.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          group.course,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onJoin != null && !isMember)
                    OutlinedButton(
                      onPressed: onJoin,
                      child: const Text('Join'),
                    )
                  else
                    const AvailabilityIndicator(
                      isAvailable: true,
                      label: 'Member',
                    ),
                ],
              ),
              if (group.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  group.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$membersCount member${membersCount == 1 ? '' : 's'}',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
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
