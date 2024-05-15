import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_igl_cng/ExportFile/app_export_file.dart';
import 'package:flutter_igl_cng/feature/login/presentations/pages/login_screen_page.dart';
import 'package:flutter_igl_cng/testing_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications',
    importance: Importance.high,
    playSound: true);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Notification ${message.data}");
  List<String> notificationList = [];
  notificationList.add(jsonEncode(message.data));
}

class FirebaseService {
  static FirebaseService get instance {
    return FirebaseService();
  }

  initializeService() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher_igl');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
      },
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
/*    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: notificationTapBackground,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );*/
    setupInteractedMessage();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
          false;
    }
    try {} on PlatformException {}
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
      Navigator.pushNamed(navigatorKey.currentState!.context, '/second');
    }
  }

  void _inAppNotification(RemoteMessage message) async {
    log('Got a message whilst in the foreground!');
    log('Message data --- App Open: ${message.toMap()}');
    log('Message data --- App Open: ${message.data}');
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'your channel id',
        'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            "id_1",
            'Action 1',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_igl'),
            contextual: true,
          ),
          AndroidNotificationAction(
            'id_2',
            'Action 2',
            titleColor: Color.fromARGB(255, 255, 0, 0),
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_igl'),
          ),
          AndroidNotificationAction(
            "id_3",
            'Action 3',
            icon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher_igl'),
            showsUserInterface: true,
            cancelNotification: false,
          ),
        ],
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );
      await flutterLocalNotificationsPlugin.show(
          1, 'plain title', 'plain body', notificationDetails,
          payload: 'item z');
    }
  }
}
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (_) => TestPage())
  );
  if (notificationResponse.actionId != null &&
      notificationResponse.payload != null) {
    Future(() async {

    });
  }
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}
