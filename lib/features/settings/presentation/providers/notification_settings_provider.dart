import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:hive/hive.dart';
import '../../../home/domain/models/product.dart';

class NotificationSettingsProvider extends ChangeNotifier {
  final Box _box;
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final Box<Product> _productBox = Hive.box<Product>('products');

  NotificationSettingsProvider(this._box);

  bool get isEnabled => _box.get('notifications_enabled', defaultValue: false);
  TimeOfDay get notificationTime =>
      _parseTimeOfDay(_box.get('notification_time', defaultValue: '09:00'));
  int get daysBeforeExpiry => _box.get('days_before_expiry', defaultValue: 3);

  Future<void> initialize() async {
    final isEnabled = _box.get('notifications_enabled', defaultValue: false);
    if (isEnabled) {
      await _initializeNotifications();
      await _scheduleNotifications();
    }
  }

  Future<void> setEnabled(bool value) async {
    await _box.put('notifications_enabled', value);
    if (value) {
      await _initializeNotifications();
      await _scheduleNotifications();
    } else {
      await _notifications.cancelAll();
    }
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    await _box.put('notification_time', '${time.hour}:${time.minute}');
    if (isEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> setDaysBeforeExpiry(int days) async {
    await _box.put('days_before_expiry', days);
    if (isEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  TimeOfDay _parseTimeOfDay(String value) {
    final parts = value.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _initializeNotifications() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  Future<void> _scheduleNotifications() async {
    await _notifications.cancelAll();

    final now = DateTime.now();
    final products = _productBox.values.toList();
    var notificationDate = DateTime(
      now.year,
      now.month,
      now.day,
      notificationTime.hour,
      notificationTime.minute,
    );

    // 오늘의 알림 시간이 이미 지났다면 다음 날로 설정
    if (notificationDate.isBefore(now)) {
      notificationDate = notificationDate.add(const Duration(days: 1));
    }

    for (final product in products) {
      final daysUntilExpiry = product.expiryDate.difference(now).inDays;

      // 유통기한까지 남은 일수가 설정된 알림 일수와 같으면 알림 예약
      if (daysUntilExpiry == daysBeforeExpiry) {
        final scheduledDate = tz.TZDateTime.from(notificationDate, tz.local);

        await _notifications.zonedSchedule(
          product.key as int, // 상품의 key를 알림 ID로 사용
          '유통기한 임박 알림',
          '${product.name}의 유통기한이 ${daysBeforeExpiry}일 남았습니다',
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'expiry_notification',
              '유통기한 알림',
              channelDescription: '유통기한 임박 상품 알림',
              importance: Importance.high,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    }
  }
}
