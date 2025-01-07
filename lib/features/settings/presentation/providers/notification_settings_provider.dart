import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:hive/hive.dart';

class NotificationSettingsProvider with ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  final Box _settingsBox = Hive.box('settings');

  bool _isEnabled = false;
  int _daysBeforeExpiry = 3;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 9, minute: 0);

  NotificationSettingsProvider() {
    _loadSettings();
    _initializeNotifications();
  }

  bool get isEnabled => _isEnabled;
  int get daysBeforeExpiry => _daysBeforeExpiry;
  TimeOfDay get notificationTime => _notificationTime;

  Future<void> _loadSettings() async {
    _isEnabled = _settingsBox.get('notifications_enabled', defaultValue: false);
    _daysBeforeExpiry = _settingsBox.get('days_before_expiry', defaultValue: 3);
    final savedHour = _settingsBox.get('notification_hour', defaultValue: 9);
    final savedMinute =
        _settingsBox.get('notification_minute', defaultValue: 0);
    _notificationTime = TimeOfDay(hour: savedHour, minute: savedMinute);
    notifyListeners();
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

  Future<void> setEnabled(bool value) async {
    _isEnabled = value;
    await _settingsBox.put('notifications_enabled', value);
    if (value) {
      await _scheduleNotifications();
    } else {
      await _notifications.cancelAll();
    }
    notifyListeners();
  }

  Future<void> setDaysBeforeExpiry(int days) async {
    _daysBeforeExpiry = days;
    await _settingsBox.put('days_before_expiry', days);
    if (_isEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> setNotificationTime(TimeOfDay time) async {
    _notificationTime = time;
    await _settingsBox.put('notification_hour', time.hour);
    await _settingsBox.put('notification_minute', time.minute);
    if (_isEnabled) {
      await _scheduleNotifications();
    }
    notifyListeners();
  }

  Future<void> _scheduleNotifications() async {
    await _notifications.cancelAll();

    // TODO: 실제 알림 스케줄링 구현
    // 1. 모든 상품의 유통기한 확인
    // 2. 설정된 날짜와 시간에 맞춰 알림 예약
  }
}
