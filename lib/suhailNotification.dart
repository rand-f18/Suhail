import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

class SuhailNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

// instant notification
  Future<void> showNotification(String t, String? d) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      playSound: true,
      importance: Importance.high,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    final String notificationTitle = t;
    final String? notificationBody = d;
    await flutterLocalNotificationsPlugin.show(
      0,
      notificationTitle,
      notificationBody,
      platformChannelSpecifics,
    );
  }

//scheduled notification, userType: user=0 content provider=1
  Future<void> scheduleNotification(DateTime notificationTime, String title,
      String description, int? reminderTime, int notificationID) async {
    const String channelName = 'Scheduled Notifications';
    const String channelDescription = 'Scheduled notification channel';

    String notificationTitle = '';
    String notificationMsg = '';

// suhail's user event notification msg
    // suhail's content provider event notification msg
    if (notificationID == -2) {
      notificationTitle = ' !حدث فلكي مترقب اليوم';
      notificationMsg = ' $title لا تفوّت';
    } else {
      switch (reminderTime) {
        case (0):
          notificationTitle = '! حدث مترقب اليوم';
          notificationMsg = '$title موعده اليوم';
          break;
        case (1):
          notificationTitle = '! حدث مترقب غدًا';
          break;
        case (7):
          notificationTitle = '! حدث مترقب بعد أسبوع';
          break;
      }
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    initializetimezone();
    await AndroidAlarmManager.initialize();

    //testing purposes
    /*
    final tz.TZDateTime scheduledDate = tz.TZDateTime.now(tz.local).add(
      const Duration(seconds: 1),
    );
    */

    tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(notificationTime, tz.local);

    print(scheduledDate);
    print(tz.local);
    print(notificationTime);

    if (notificationTime.isAfter(scheduledDate)) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationID,
        notificationTitle,
        notificationMsg,
        scheduledDate,
        platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        //androidAllowWhileIdle: true,
      );
    } else {
      //err msg
    }
  }

  Future initializetimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
  }
}
