import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/application/model/enum/notification_type.dart';
import 'package:pocketkeeper/application/model/notification.dart';
import 'package:pocketkeeper/application/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  LocalNotificationService() {
    flutterLocalNotificationsPlugin =
        MemberCache.flutterLocalNotificationsPlugin;
    init();
  }

  void init() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    MemberCache.flutterLocalNotificationsPlugin =
        flutterLocalNotificationsPlugin;

    // Schedule daily notification
    // scheduleDailyNotification();
  }

  Future<void> sendNotification({
    required String channelId,
    required String channelName,
    required String description,
  }) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: description,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      channelName,
      description,
      notificationDetails,
    );

    // Add into objectbox
    NotificationService().add(Notifications(
      tmpDescription: description,
      tmpTitle: channelName,
      tmpNotificationType: NotificationType.warning,
    ));
  }

  Future<void> scheduleDailyNotification() async {
    String channelId = 'daily_checkin';
    String channelName = 'Daily Check-In';
    String description = 'Don\'t forget to check in!';

    var androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: description,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    var iOSDetails = const DarwinNotificationDetails();
    var notificationDetails =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      channelName,
      description,
      RepeatInterval.daily,
      notificationDetails,
    );

    // Add into objectbox
    NotificationService().add(Notifications(
      tmpDescription: description,
      tmpTitle: channelName,
      tmpNotificationType: NotificationType.warning,
    ));
  }

  Future<void> cancelNotificationIfCheckedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checkedIn = prefs.getBool('checked_in') ?? false;

    if (checkedIn) {
      await flutterLocalNotificationsPlugin.cancel(0);
    }
  }

  Future<void> checkIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('checked_in', true);
    await cancelNotificationIfCheckedIn();
  }

  void resetCheckInStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    DateTime lastReset =
        DateTime.fromMillisecondsSinceEpoch(prefs.getInt('last_reset') ?? 0);

    if (now.difference(lastReset).inDays >= 1) {
      await prefs.setBool('checked_in', false);
      await prefs.setInt('last_reset', now.millisecondsSinceEpoch);
      scheduleDailyNotification();
    }
  }
}
