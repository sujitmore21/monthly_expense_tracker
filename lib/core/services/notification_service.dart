import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../features/budgets/data/models/budget_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Request permissions
    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  static Future<void> showBudgetWarningNotification(BudgetModel budget) async {
    final spentPercentage = budget.spent / budget.amount;
    final isOverBudget = spentPercentage >= 1.0;
    final isNearDanger = spentPercentage >= budget.dangerThreshold;

    String title;
    String body;
    String channelId = 'budget_warnings';
    String channelName = 'Budget Warnings';

    if (isOverBudget) {
      title = 'Budget Exceeded!';
      body =
          'You have exceeded your budget for ${budget.name} by \$${(budget.spent - budget.amount).toStringAsFixed(2)}';
    } else if (isNearDanger) {
      title = 'Budget Danger Zone';
      body =
          'You are at ${(spentPercentage * 100).toStringAsFixed(1)}% of your ${budget.name} budget';
    } else {
      title = 'Budget Warning';
      body =
          'You have reached ${(spentPercentage * 100).toStringAsFixed(1)}% of your ${budget.name} budget';
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'budget_warnings',
          'Budget Warnings',
          channelDescription: 'Notifications for budget warnings and alerts',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      budget.hashCode,
      title,
      body,
      details,
      payload: 'budget_${budget.id}',
    );
  }

  static Future<void> showBillReminderNotification({
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'bill_reminders',
          'Bill Reminders',
          channelDescription: 'Notifications for upcoming bill payments',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      title.hashCode,
      'Bill Reminder: $title',
      'Due: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
      details,
      payload: 'bill_reminder_${title.hashCode}',
    );
  }

  static Future<void> scheduleRecurringBillReminder({
    required String title,
    required String description,
    required DateTime nextDueDate,
    required int reminderDaysBefore,
  }) async {
    final reminderDate = nextDueDate.subtract(
      Duration(days: reminderDaysBefore),
    );

    if (reminderDate.isAfter(DateTime.now())) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            'bill_reminders',
            'Bill Reminders',
            channelDescription: 'Notifications for upcoming bill payments',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.zonedSchedule(
        title.hashCode,
        'Bill Reminder: $title',
        'Due: ${nextDueDate.day}/${nextDueDate.month}/${nextDueDate.year}',
        tz.TZDateTime.from(reminderDate, tz.local),
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: 'bill_reminder_${title.hashCode}',
      );
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
