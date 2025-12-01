import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/group_service.dart';
import '../services/notification_service.dart';
import '../services/room_service.dart';
import '../services/schedule_service.dart';
import '../services/timer_service.dart';

/// Central registry of all application-level providers.
class AppProviders {
  AppProviders._();

  static final List<SingleChildWidget> providers = [
    ChangeNotifierProvider<AuthService>(
      create: (_) => AuthService(),
    ),
    ChangeNotifierProvider<TimerService>(
      create: (_) => TimerService(),
    ),
    Provider<ChatService>(
      create: (_) => ChatService(),
    ),
    Provider<GroupService>(
      create: (_) => GroupService(),
    ),
    Provider<RoomService>(
      create: (_) => RoomService(),
    ),
    Provider<ScheduleService>(
      create: (_) => ScheduleService(),
    ),
    Provider<NotificationService>(
      create: (_) => NotificationService(),
    ),
  ];
}
