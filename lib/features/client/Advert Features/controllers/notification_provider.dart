import 'dart:convert';
import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/active_notification_model.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/models/notification_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

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
    final android = AndroidNotificationDetails(
      'deero_notifications',
      'Deero App Notifications',
      channelDescription: 'Deero App Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      color: const Color(0xffEF7044),
      styleInformation: BigTextStyleInformation(
        body,
        contentTitle: '<b>$title</b>',
        htmlFormatContentTitle: true,
        htmlFormatBigText: true,
      ),
      ticker: 'ticker',
      category: AndroidNotificationCategory.reminder,
    );

    await _local.show(
      DateTime.now().millisecond,
      title,
      body,
      NotificationDetails(android: android),
    );
  }
}

class NotificationProvider extends ChangeNotifier {
  ActiveNotificationModel? activeNotificationModel;
  NotificationModel? notificationModel;
  bool isLoading = false;
  String? error;

  NotificationProvider() {
    // Automatically attempt to save token when the provider is loaded
    saveToken();
    // Check if it's the first launch to send a welcome sample
    _checkFirstLaunch();
  }

  void _checkFirstLaunch() {
    final box = GetStorage();
    bool isFirstLaunch = box.read('isFirstLaunchNotificationSent') ?? false;

    if (!isFirstLaunch) {
      NotificationService.show(
        "Welcome to Deero Enterprise!",
        "Thank you for installing our application. You will receive important updates here.",
      );
      box.write('isFirstLaunchNotificationSent', true);
    }
  }

  Future<void> saveToken() async {
    try {
      isLoading = true;
      notifyListeners();

      final token = await FirebaseMessaging.instance.getToken();
      if (token == null) return;
      print("FCM Token retrieved: $token");

      final box = GetStorage();
      String? userId;
      if (box.hasData("userInfo")) {
        final userData = box.read("userInfo");
        if (userData != null && userData['user'] != null) {
          userId = userData['user']['id'] ?? userData['user']['_id'];
        }
      }

      final response = await http.post(
        Uri.parse("${EndPoint}announcements/save-token"),
        body: jsonEncode({"userId": userId, "token": token}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Done: Token saved successfully.");
      } else {
        print("Failed to save token. Status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saving token: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllNotifications() async {
    try {
      isLoading = true;
      notifyListeners();

      final box = GetStorage();
      final userInfo = box.read("userInfo");
      final token = userInfo != null ? userInfo['token'] : null;
      final response = await http.get(
        Uri.parse("${EndPoint}announcements"),
        headers: {
          "Content-Type": "application/json",
          if (token != null) "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        notificationModel = NotificationModel.fromJson(decodeData);
      } else {
        error =
            "Failed to load notifications. Status code: ${response.statusCode}";
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> activeNotification() async {
    try {
      isLoading = true;
      notifyListeners();
      final response = await http.get(
        Uri.parse("${EndPoint}announcements/active"),
        headers: {
          "Content-Type": "application/json",
          "header": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final decodeData = jsonDecode(response.body);
        activeNotificationModel = ActiveNotificationModel.fromJson(decodeData);

        // Show firebase local notification for active announcement only if it's new
        if (activeNotificationModel?.data != null &&
            activeNotificationModel!.data!.isNotEmpty) {
          final activeItem = activeNotificationModel!.data!.first;

          final box = GetStorage();
          final lastId = box.read('lastActiveNotificationId');

          if (activeItem.sId != lastId) {
            NotificationService.show(
              activeItem.title ?? "Active Update",
              activeItem.message ?? "New announcement is active.",
            );
            // Save this ID so we don't show it again until a new one comes
            box.write('lastActiveNotificationId', activeItem.sId);
          }
        }
      } else {
        error =
            "Failed to load notifications. Status code: ${response.statusCode}";
      }
      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }
}
