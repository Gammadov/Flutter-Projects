import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

class NotofocationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final settings = InitializationSettings(android: android);

    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: (details) async {
      onNotifications.add(details.payload);
    });
  }

  static Future _notificationDetails() async {
    final _sound = 'notification';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id 1',
        'channel name',
        channelDescription: 'channel description',
        // playSound: true,
        sound: RawResourceAndroidNotificationSound(_sound),
        enableVibration: true,
        importance: Importance.max,
      ),
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
}
