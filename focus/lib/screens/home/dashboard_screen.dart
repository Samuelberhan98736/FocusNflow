import 'package:flutter/material.dart';

import '../../app/constants.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _navigate(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final cards = [
      _DashCard(
        title: 'Study Groups',
        subtitle: 'Join or create a study group',
        icon: Icons.groups_2_outlined,
        onTap: () => _navigate(context, AppRoutes.studyGroups),
      ),
      _DashCard(
        title: 'Shared Timer',
        subtitle: 'Stay on track with Pomodoro',
        icon: Icons.timer_outlined,
        onTap: () => _navigate(context, AppRoutes.sharedTimer),
      ),
      _DashCard(
        title: 'Rooms',
        subtitle: 'Find available study rooms',
        icon: Icons.meeting_room_outlined,
        onTap: () => _navigate(context, AppRoutes.roomFinder),
      ),
      _DashCard(
        title: 'Notifications',
        subtitle: 'Recent updates',
        icon: Icons.notifications_outlined,
        onTap: () => _navigate(context, AppRoutes.notifications),
      ),
      _DashCard(
        title: 'Profile',
        subtitle: 'Account settings',
        icon: Icons.person_outline,
        onTap: () => _navigate(context, AppRoutes.profile),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusNFlow Dashboard'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cards.length,
        itemBuilder: (_, index) => cards[index],
      ),
    );
  }
}

class _DashCard extends StatelessWidget {
  const _DashCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 28, color: theme.colorScheme.primary),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
