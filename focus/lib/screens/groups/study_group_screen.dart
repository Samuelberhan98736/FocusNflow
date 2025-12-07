import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/constants.dart';
import '../../models/group_model.dart';
import '../../services/group_service.dart';
import '../../widgets/group_card.dart';

class StudyGroupScreen extends StatelessWidget {
  const StudyGroupScreen({super.key});

  Future<List<GroupModel>> _loadGroups(GroupService groupService) async {
    final data = await groupService.getAllGroups();
    return data.map(GroupModel.fromMap).toList();
  }

  @override
  Widget build(BuildContext context) {
    final groupService = context.read<GroupService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Groups'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.createGroup),
          )
        ],
      ),
      body: FutureBuilder<List<GroupModel>>(
        future: _loadGroups(groupService),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final groups = snapshot.data ?? [];
          if (groups.isEmpty) {
            return const Center(child: Text('No groups yet. Create one!'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: groups.length,
            itemBuilder: (_, index) {
              final group = groups[index];
              return GroupCard(
                group: group,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.groupDetail,
                    arguments: group.groupId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
