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

  final Map<String, dynamic> payload = jsonDecode(payloadJson);
  log('Action ID: ${notificationResponse.actionId}');
  final dataNoti = PushNotificationData.fromJson(payload);
  try {
    //nếu có cuộc gọi, cuộc gọi bị từ chối
    if (notificationResponse.actionId == 'DECLINE_CALL') {
      log("User declined the call");
    } else if (dataNoti.pageName != null && dataNoti.uidUser != null) {
      Get.toNamed(
        dataNoti.pageName!,
        arguments:  UserChatArgument(
                uid: dataNoti.uidUser!,
                name: dataNoti.nameUser ?? '',
                avatar: dataNoti.imgUser ?? '',
                callID: dataNoti.callId,
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
    final iosSettings = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'callCategory',
          actions: [
            DarwinNotificationAction.plain('ACCEPT_CALL', 'Chấp nhận'),
            DarwinNotificationAction.plain('DECLINE_CALL', 'Từ chối'),
          ],
        )
      ],
    );

    final initializationSettings = InitializationSettings(
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

  static NotificationDetails incomingCallDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        icon: '@mipmap/ic_launcher',
        sound: RawResourceAndroidNotificationSound('phone_ring'),
        playSound: true,
        autoCancel: false,
        enableVibration: true,
        ongoing: true,
        timeoutAfter: 10000,
        'channelId',
        'Incoming Calls',
        channelDescription: 'Incoming video calls',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true, // Làm thông báo nổi như cuộc gọi thật
        ticker: 'Incoming call',
        category: AndroidNotificationCategory.call, // Android call style
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'ACCEPT_CALL',
            'Chấp nhận',
            showsUserInterface: true,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            'DECLINE_CALL',
            'Từ chối',
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
      ),
      iOS: DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        categoryIdentifier:
            'callCategory', // iOS cần thêm phần định nghĩa category
      ),
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
