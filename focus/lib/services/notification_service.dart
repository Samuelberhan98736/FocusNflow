import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Initialize Firebase Cloud Messaging
  Future<void> initialize() async {
    // Request notification permissions
    await _requestPermissions();

    // Get and print the device token
    await _printFcmToken();

    // Listen for messages in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleForegroundMessage(message);
    });

    // Listen for when the user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageTap(message);
    });
  }

  // Ask for notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Notification permission: ${settings.authorizationStatus}");
  }

  // Print the FCM token for testing
  Future<void> _printFcmToken() async {
    String? token = await _messaging.getToken();
    print("FCM Token: $token");
  }

  // Handle incoming messages in the foreground
  void _handleForegroundMessage(RemoteMessage message) {
    print("Foreground message received:");
    print("Title: ${message.notification?.title}");
    print("Body: ${message.notification?.body}");
    print("Data: ${message.data}");
  }

  // Handle notification taps
  void _handleMessageTap(RemoteMessage message) {
    print("User tapped the notification");
    print("Data: ${message.data}");
  }

  // Subscribe to a topic (optional)
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  // Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
