import 'dart:convert';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';


class NotificationService {
  static final _local = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _local.initialize(const InitializationSettings(android: android));

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        show(
          message.notification?.title ?? '',
          message.notification?.body ?? '',
        );
      }
    });

    // Request permissions
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  static Future show(String title, String body) async {
    const android = AndroidNotificationDetails(
      'deero_notifications',
      'Deero App Notifications',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    await _local.show(
      DateTime.now().millisecond,
      title,
      body,
      const NotificationDetails(android: android),
    );
  }
}

class NotificationProviders extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  NotificationProviders() {
    // Automatically attempt to save token when the provider is loaded
    saveToken();
    // Check if it's the first launch to send a welcome sample
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() {
    final box = GetStorage();
    bool isFirstLaunch = box.read('isFirstLaunchNotificationSent') ?? false;

    if (!isFirstLaunch) {
      // Send sample notification
      NotificationService.show(
        "Welcome to Deero Enterprise!",
        "Thank you for installing our application. You will receive important updates here.",
      );
      // Mark as sent
      box.write('isFirstLaunchNotificationSent', false);
    }
  }

  Future<void> saveToken() async {
    try {
      _isLoading = true;
      notifyListeners();

      final token = await FirebaseMessaging.instance.getToken();
      
      if (token == null) {
        print("Could not retrieve FCM token");
        return;
      }

      print("FCM Token retrieved: $token");

      final box = GetStorage();
      String? userId;

      // Try to get userId from stored userInfo if logged in
      if (box.hasData("userInfo")) {
        final userData = box.read("userInfo");
        if (userData != null && userData['user'] != null) {
          userId = userData['user']['id'] ?? userData['user']['_id'];
        }
      }

      final response = await http.post(
        Uri.parse(EndPoint + "save-token"),
        body: jsonEncode({
          "userId": userId, // Can be null if not logged in
          "token": token,
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        print("FCM Token saved to backend successfully. UserID: $userId");
      } else {
        print(
          "Failed to save token to backend: ${response.statusCode} - ${response.body}",
        );
      }
    } catch (e) {
      print("Error in NotificationProvider.saveToken: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
