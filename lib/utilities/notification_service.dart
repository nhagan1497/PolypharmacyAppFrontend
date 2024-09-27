import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'logger.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static int notificationId = 0;

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@drawable/app_notification_icon');
    const iOS = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        logger.d('Notification clicked with payload: ${response.payload}');
      },
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      icon: '@drawable/app_notification_icon',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.show(id, title, body, notificationDetails);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
    // logger.d('All notifications have been cancelled.');
  }

  // Method to schedule a daily notification at a specified time
  static Future<void> scheduleDailyNotification({
    required String title,
    required String body,
    required TimeOfDay time,
  }) async {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    DateTime utcDateTime = dateTime.toUtc();

    final scheduledDate = tz.TZDateTime(
      tz.local,
      utcDateTime.year,
      utcDateTime.month,
      utcDateTime.day,
      utcDateTime.hour,
      utcDateTime.minute,
    );

    // Check if the time for today has already passed; if so, schedule for tomorrow
    final nextScheduledDate = scheduledDate.isBefore(tz.TZDateTime.now(tz.local))
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;

    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Daily notification channel',
      icon: '@drawable/app_notification_icon',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSDetails = DarwinNotificationDetails();

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notifications.zonedSchedule(
      ++notificationId,
      title,
      body,
      nextScheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // Daily trigger based on time
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
