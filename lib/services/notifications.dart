import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:goipvc/providers/data_providers.dart';

class Notifications {
  static int id = 0;

  static final FlutterLocalNotificationsPlugin notifPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> lessonAlertNotification(
      String name, String msg, DateTime startTime, int minsBefore) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("lessons_alerts", "Notificação de Aulas",
            channelDescription:
                "Notifica alguns minutos antes do início de uma aula",
            importance: Importance.high,
            priority: Priority.high);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final DateTime notificationTime =
        startTime.subtract(Duration(minutes: minsBefore));

    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(notificationTime, tz.getLocation("Europe/Lisbon"));

    if (scheduledDate
        .isBefore(tz.TZDateTime.now(tz.getLocation("Europe/Lisbon")))) {
      return;
    }

    id++;
    await notifPlugin.zonedSchedule(
      id,
      name,
      msg,
      scheduledDate,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<List<Map<String, dynamic>>>
      scheduleLessonNotifications() async {
    final lessons = await providerContainer.read(lessonsProvider.future);
    List<Map<String, dynamic>> scheduledLessons = [];

    final now = DateTime.now();
    final endDate = now.add(Duration(days: 3));

    final filteredLessons = lessons.where((lesson) {
      final lessonStart = DateTime.parse(lesson.start);
      return lessonStart.isAfter(now) && lessonStart.isBefore(endDate);
    }).toList();

    for (var lesson in filteredLessons) {
      await lessonAlertNotification(
        "${lesson.shortName} — ${lesson.room}",
        "Daqui a 5 minutos",
        DateTime.parse(lesson.start),
        5,
      );
      scheduledLessons.add({
        'className': lesson.className,
        'startTime': DateTime.parse(lesson.start),
      });
    }

    return scheduledLessons;
  }

  static void callbackDispatcher() {}

  static Future<void> init() async {
    Workmanager().initialize(callbackDispatcher);

    if (kIsWeb) {
      return;
    } else {
      notifPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await notifPlugin.initialize(initializationSettings);

    if (await Permission.notification.isGranted) {
      await scheduleLessonNotifications();
    }
  }
}
