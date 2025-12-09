import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const appName = 'FocusNFlow';
}

class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const signup = '/signup';
  static const dashboard = '/dashboard';
  static const studyGroups = '/groups';
  static const createGroup = '/groups/create';
  static const groupDetail = '/groups/detail';
  static const scheduleSession = '/groups/schedule';
  static const groupChat = '/chat';
  static const roomFinder = '/rooms';
  static const roomDetail = '/rooms/detail';
  static const roomMap = '/rooms/map';
  static const notifications = '/notifications';
  static const profile = '/profile';
  static const sharedTimer = '/timer';
}

// Common UI spacing used throughout the app.
const defaultScreenPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 12);
