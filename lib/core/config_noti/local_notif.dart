import 'dart:convert';
import 'dart:developer';

import 'package:easy_date/features/feature_src.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  log('background: ${notificationResponse.id}');
  _handleNotificationResponse(notificationResponse);
}

void _handleNotificationResponse(NotificationResponse notificationResponse) {
  final payloadJson = notificationResponse.payload;
  if (payloadJson == null) return;

  final payload = jsonDecode(payloadJson) as Map;
  try {
    if (payload.containsKey('pageName') && payload.containsKey('uidUser')) {
      Get.toNamed(
        payload['pageName'],
        arguments: UserChatArgument(
          uid: payload['uidUser'],
          name: payload['nameUser'] ?? '',
          avatar: payload['imgUser'] ?? '',
        ),
      );
    }
  } catch (e) {
    log(e.toString());
  }
}

class LocalNotif {
  static final _notifPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const iosSettings = DarwinInitializationSettings();

    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // 👉 Tạo channel trước
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channelId', // Đảm bảo giống với ID bạn dùng trong NotificationDetails
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 👉 Request permission
    await _notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _notifPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse: (notificationResponse) {
        log('foreground: ${notificationResponse.id}');
        _handleNotificationResponse(notificationResponse);
      },
    );

    // await _notifPlugin
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestNotificationsPermission();

    // const androidSettings =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // const iosSettings = DarwinInitializationSettings();

    // const initializationSettings = InitializationSettings(
    //   android: androidSettings,
    //   iOS: iosSettings,
    // );

    // await _notifPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveBackgroundNotificationResponse:
    //       _onDidReceiveBackgroundNotificationResponse,
    //   onDidReceiveNotificationResponse: (notificationResponse) {
    //     log('foreground: ${notificationResponse.id}');
    //     _handleNotificationResponse(notificationResponse);
    //   },
    // );
  }

  // handle notif from terminate state
  static initialMessage() async {
    final notifAppLaunchDetails =
        await _notifPlugin.getNotificationAppLaunchDetails();
    if (notifAppLaunchDetails == null) return;

    final appOpenViaNotif = notifAppLaunchDetails.didNotificationLaunchApp;
    if (appOpenViaNotif) {
      final notifResponse = notifAppLaunchDetails.notificationResponse;
      if (notifResponse == null) return;
      _handleNotificationResponse(notifResponse);
    }
  }

  static NotificationDetails _defaultNotifDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        channelDescription: '',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  static void showNotif({
    int id = 0,
    String? title,
    String? body,
    NotificationDetails? notificationDetails,
    String? payload,
  }) async {
    await _notifPlugin.show(
      id,
      title,
      body,
      notificationDetails ?? _defaultNotifDetails(),
      payload: payload,
    );
  }

  static cancelNotif() async {
    await _notifPlugin.cancelAll();
  }
}
