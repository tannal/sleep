// lib/services/notification_service.dart
// Web-compatible stub — notifications only work on mobile

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  Future<void> initialize() async {}
  Future<bool> requestPermission() async => false;

  Future<void> scheduleBedtimeReminder({
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
  }) async {}

  Future<void> cancelBedtimeReminder() async {}

  Future<void> scheduleWakeAlarm({
    required int hour,
    required int minute,
    required List<int> daysOfWeek,
  }) async {}

  Future<void> cancelWakeAlarm() async {}

  Future<void> scheduleWindDownReminder({
    required int bedtimeHour,
    required int bedtimeMinute,
    required List<int> daysOfWeek,
  }) async {}

  Future<void> showSleepSummary({
    required int score,
    required double hours,
  }) async {}

  Future<void> cancelAll() async {}
}
