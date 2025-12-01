import 'package:flutter/material.dart';

import 'constants.dart';

/// Centralized route generator for the app.
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Splash'));
      case AppRoutes.onboarding:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Onboarding'));
      case AppRoutes.login:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Login'));
      case AppRoutes.dashboard:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Dashboard'));
      case AppRoutes.studyGroups:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Study Groups'));
      case AppRoutes.createGroup:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Create Group'));
      case AppRoutes.groupDetail:
        return _page(
          settings,
          _ScaffoldPlaceholder(
            title: 'Group Detail',
            detail: 'Group: ${args ?? 'unknown'}',
          ),
        );
      case AppRoutes.scheduleSession:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Schedule Session'));
      case AppRoutes.groupChat:
        return _page(
          settings,
          _ScaffoldPlaceholder(
            title: 'Group Chat',
            detail: 'Room: ${args ?? 'unknown'}',
          ),
        );
      case AppRoutes.roomFinder:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Room Finder'));
      case AppRoutes.roomDetail:
        return _page(
          settings,
          _ScaffoldPlaceholder(
            title: 'Room Detail',
            detail: 'Room: ${args ?? 'unknown'}',
          ),
        );
      case AppRoutes.roomMap:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Room Map'));
      case AppRoutes.notifications:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Notifications'));
      case AppRoutes.profile:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Profile'));
      case AppRoutes.sharedTimer:
        return _page(settings, const _ScaffoldPlaceholder(title: 'Shared Timer'));
      default:
        return _page(
          settings,
          _ScaffoldPlaceholder(
            title: 'Route not found',
            detail: 'No route defined for "${settings.name ?? 'unknown'}".',
          ),
        );
    }
  }

  static MaterialPageRoute _page(RouteSettings settings, Widget child) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) => child,
    );
  }
}

/// Simple placeholder screen until dedicated UI is built.
class _ScaffoldPlaceholder extends StatelessWidget {
  final String title;
  final String? detail;

  const _ScaffoldPlaceholder({
    required this.title,
    this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (detail != null) ...[
              const SizedBox(height: 12),
              Text(
                detail!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
