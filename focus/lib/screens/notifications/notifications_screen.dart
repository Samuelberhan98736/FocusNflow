import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockNotifications = [
      ('Group Study', 'Your group session starts in 30 minutes.'),
      ('Room Update', 'Room A-201 is now available.'),
      ('New Message', 'You have unread messages in CS101 chat.'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: mockNotifications.length,
        itemBuilder: (_, index) {
          final item = mockNotifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(item.$1),
            subtitle: Text(item.$2),
          );
        },
      ),
    );
  }
}
