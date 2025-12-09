import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/app/constants.dart';
import '/models/group_model.dart';
import '/services/api_client.dart';
import '/services/group_service.dart';
import '/utils/snackbar.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key, this.groupId});

  final String? groupId;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  bool _actionLoading = false;

  String? get _userId => ApiClient.instance.uuid;

  Future<void> _join(GroupService service, String groupId) async {
    setState(() => _actionLoading = true);
    final ok = await service.joinGroup(groupId);
    if (mounted) {
      setState(() => _actionLoading = false);
      if (!ok) showAppSnackBar(context, 'Unable to join group', isError: true);
    }
  }

  Future<void> _leave(GroupService service, String groupId) async {
    setState(() => _actionLoading = true);
    final ok = await service.leaveGroup(groupId);
    if (mounted) {
      setState(() => _actionLoading = false);
      if (!ok) showAppSnackBar(context, 'Unable to leave group', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupId =
        widget.groupId ?? ModalRoute.of(context)?.settings.arguments as String?;
    final groupService = context.read<GroupService>();

    if (groupId == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Group Detail')),
        body: const Center(child: Text('No group specified')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.groupChat,
                arguments: groupId,
              );
            },
          )
        ],
      ),
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: groupService.groupStream(groupId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          if (data == null) {
            return const Center(child: Text('Group not found'));
          }

          final group = GroupModel.fromMap(data);
          final isMember = _userId != null && group.members.contains(_userId);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                group.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                group.course,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              if (group.description.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  group.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${group.members.length} member${group.members.length == 1 ? '' : 's'}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  FilledButton(
                    onPressed: _actionLoading
                        ? null
                        : () => isMember
                            ? _leave(groupService, group.groupId)
                            : _join(groupService, group.groupId),
                    child: _actionLoading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(isMember ? 'Leave' : 'Join'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Members',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: group.members
                    .map(
                      (m) => Chip(
                        label: Text(
                          m,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.event_available),
        label: const Text('Schedule'),
        onPressed: () {
          Navigator.of(context).pushNamed(
            AppRoutes.scheduleSession,
            arguments: groupId,
          );
        },
      ),
    );
  }
}
