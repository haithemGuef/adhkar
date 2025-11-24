import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'start.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Duration _delayUntil(int hour, int minute) {
  final now = DateTime.now();
  DateTime target = DateTime(now.year, now.month, now.day, hour, minute);
  if (now.isAfter(target)) {
    target = target.add(const Duration(days: 1));
  }
  return target.difference(now);
}

Future<void> _showNotification(String title, String body) async {
  await flutterLocalNotificationsPlugin.show(
    999, // ID فريد
    title,
    body,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_channel',
        'Instant Notifications',
        channelDescription: 'Notifications shown immediately when app starts',
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
    ),
  );
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    print("✅ تنفيذ المهمة: $task");

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);
    await flutterLocalNotificationsPlugin.initialize(settings);

    final title = inputData?['title'] ?? '🔔 تذكير';
    final body = inputData?['body'] ?? 'لديك تنبيه جديد.';
    final nextHour = inputData?['hour'] ?? 6;
    final nextMinute = inputData?['minute'] ?? 0;
    final nextTask = inputData?['nextTask'] ?? '';

    await flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_channel',
          'Instant Notifications',
          channelDescription: 'Notifications shown immediately when app starts',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          sound: RawResourceAndroidNotificationSound('notification_sound'),
        ),
      ),
    );

    // إعادة جدولة المهمة لليوم التالي
    if (nextTask.isNotEmpty) {
      final delay = _delayUntil(nextHour, nextMinute);
      await Workmanager().registerOneOffTask(
        nextTask,
        nextTask,
        initialDelay: delay,
        inputData: {
          'title': title,
          'body': body,
          'hour': nextHour,
          'minute': nextMinute,
          'nextTask': nextTask,
        },
      );
      print("📅 تمت إعادة جدولة $nextTask بعد $delay");
    }

    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );

  // تهيئة الإشعارات
  const AndroidInitializationSettings androidInitSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidInitSettings);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // تهيئة WorkManager
  await Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // إلغاء أي مهام قديمة (اختياري)
  await Workmanager().cancelAll();

  // تسجيل أول مهمة صباحية
  await Workmanager().registerOneOffTask(
    "morning_once",
    "morning_once",
    initialDelay: _delayUntil(6, 0),
    inputData: {
      'title': "🌅 صباح الخير",
      'body': "لا تنسَ أذكار الصباح الآن!",
      'hour': 6,
      'minute': 0,
      'nextTask': 'morning_once',
    },
  );

  // تسجيل أول مهمة مسائية
  await Workmanager().registerOneOffTask(
    "evening_once",
    "evening_once",
    initialDelay: _delayUntil(18, 0),
    inputData: {
      'title': "🌙 مساء الخير",
      'body': "لا تنسَ أذكار المساء الآن!",
      'hour': 18,
      'minute': 0,
      'nextTask': 'evening_once',
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      onInit: () {
        Future.delayed(const Duration(seconds: 1), () {
          FlutterNativeSplash.remove();
        });
      },
      debugShowCheckedModeBanner: false,
      title: "أذكاري",
      locale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      theme: ThemeData(
        fontFamily: 'Tajawal',
        primarySwatch: Colors.blue,
      ),
      home: const Start(),
    );
  }
}