import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'notifications_priority', // id
  'High Importance Notifications',
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound("mario"),
);

int notificationId = 1;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("Notification ${message.data}");
  List<String> notificationList = [];
  notificationList.add(jsonEncode(message.data));
  if (await Vibration.hasAmplitudeControl() != null) {
    Vibration.vibrate(duration: 10000);
  }
  final player = AudioPlayer();
  player.play(AssetSource('siren_alert.mp3'));
}

class FirebaseService {
  static FirebaseService get instance {
    return FirebaseService();
  }

  initializeService() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher_igl');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {},
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    _isAndroidPermissionGranted();
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: 'AIzaSyA1C5oCjXFfe4__kreZkfwI3ch9PlB5PwI',
      appId: '1:812941224886:android:c8af46dc8b106bc6072f17',
      messagingSenderId: '812941224886',
      projectId: 'igl-cng',
      storageBucket: 'igl-cng.appspot.com',
    ));
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImplementation?.requestPermission();
      if (kDebugMode) {
        print("Notification permission ====== ${granted.toString()}");
      }
    }
    // setupInteractedMessage();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;
    }
  }

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    FirebaseMessaging.onMessage.listen(_inAppNotification);
  }

  void _handleMessage(RemoteMessage message) async {
    log('Message data ---  handleMessage ${message.data}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      // navigatorKey.currentState!.pushNamed('/second');
    }
  }

  void _inAppNotification(RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    log('Message data --- App Open: ${message.toMap()}');
    log('Message data --- App Open: ${message.data}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      notificationId++;
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'notifications_priority', // id
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "id",
            'View',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_igl'),
            contextual: true,
          ),
        ],
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
/*      await flutterLocalNotificationsPlugin.show(
          notificationId,
          notification.title.toString(),
          notification.body.toString(),
          notificationDetails,
          payload: 'item z');*/
    }
  }
}
