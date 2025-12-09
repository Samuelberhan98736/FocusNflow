import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/onboarding_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/chat/group_chat_screen.dart';
import '../screens/groups/create_group_screen.dart';
import '../screens/groups/group_detail_screen.dart';
import '../screens/groups/schedule_session_screen.dart';
import '../screens/groups/study_group_screen.dart';
import '../screens/home/dashboard_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/rooms/room_detail_screen.dart';
import '../screens/rooms/room_finder_screen.dart';
import '../screens/rooms/room_map_widget.dart';
import '../screens/timer/shared_timer_screen.dart';
import '../services/auth_service.dart';

import 'constants.dart';

/// Centralized route generator for the app.
class AppRouter {
  AppRouter._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _page(settings, const SplashScreen());
      case AppRoutes.onboarding:
        return _page(settings, const OnboardingScreen());
      case AppRoutes.login:
        return _page(settings, const LoginScreen());
      case AppRoutes.signup:
        return _page(settings, const SignupScreen());
      case AppRoutes.dashboard:
        return _page(settings, const DashboardScreen());
      case AppRoutes.studyGroups:
        return _page(settings, const StudyGroupScreen());
      case AppRoutes.createGroup:
        return _page(settings, const CreateGroupScreen());
      case AppRoutes.groupDetail:
        return _page(
          settings,
          GroupDetailScreen(groupId: _stringArg(args)),
        );
      case AppRoutes.scheduleSession:
        return _page(
          settings,
          ScheduleSessionScreen(groupId: _stringArg(args)),
        );
      case AppRoutes.groupChat:
        return _page(
          settings,
          GroupChatScreen(roomId: _stringArg(args)),
        );
      case AppRoutes.roomFinder:
        return _page(settings, const RoomFinderScreen());
      case AppRoutes.roomDetail:
        return _page(
          settings,
          RoomDetailScreen(roomId: _stringArg(args)),
        );
      case AppRoutes.roomMap:
        return _page(settings, const RoomMapWidget());
      case AppRoutes.notifications:
        return _page(settings, const NotificationsScreen());
      case AppRoutes.profile:
        return _page(settings, const ProfileScreen());
      case AppRoutes.sharedTimer:
        return _page(settings, const SharedTimerScreen());
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _routeNext());
  }

  Future<void> _routeNext() async {
    final auth = context.read<AuthService>();
    final nextRoute =
        auth.isLoggedIn ? AppRoutes.dashboard : AppRoutes.onboarding;

    // Small delay to show splash while auth state initializes.
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(nextRoute);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

String? _stringArg(dynamic args) => args is String ? args : null;

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
