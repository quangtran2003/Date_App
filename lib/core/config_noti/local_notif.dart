import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/model/call_args.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const String DECLINE_CALL = "DECLINE_CALL";
const String ACCEPT_CALL = "ACCEPT_CALL";
const String CHANNEL_ID = 'channelId';

void _onDidReceiveBackgroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  log('background: ${notificationResponse.id}');
  _handleNotificationResponse(notificationResponse);
}

void _onDidReceiveForegroundNotificationResponse(
  NotificationResponse notificationResponse,
) {
  log('foreground: ${notificationResponse.id}');
  _handleNotificationResponse(notificationResponse);
}

Future<void> _handleNotificationResponse(
  NotificationResponse notificationResponse, {
  bool isTerminateApp = false,
}) async {
  final payloadJson = notificationResponse.payload;
  if (payloadJson == null) return;

  try {
    final Map<String, dynamic> payload = jsonDecode(payloadJson);
    final dataNoti = PushNotificationData.fromJson(payload);

    if (notificationResponse.actionId == DECLINE_CALL) {
      await LocalNotif.notifPlugin.cancel(notificationResponse.id!);
      await FirebaseFirestore.instance
          .collection(FirebaseCollection.calls)
          .doc(dataNoti.callId)
          .update({
        'status': StatusCallEnum.rejected.value,
      });
    } else if (notificationResponse.actionId == ACCEPT_CALL) {
      // For terminated state, the main.dart will handle the navigation
      if (!isTerminateApp) {
        Get.toNamed(
          AppRouteEnum.video_call.path,
          arguments: CallArgs(
            typeCall: MessageTypeEnum.fromInt(int.parse(dataNoti.type ?? '')),
            idCurrentUser: dataNoti.idReceiver ?? '',
            nameCurrentUser: dataNoti.nameSender ?? '',
            idOtherUser: dataNoti.idSender ?? '',
            callID: dataNoti.callId,
            statusCall: StatusCallEnum.accepted,
          ),
        );
      }
    }
  } catch (e) {
    logger.e('Error handling notification response: $e');
  }
}

class LocalNotif {
  static final notifPlugin = FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    final iosSettings = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'callCategory',
          actions: [
            DarwinNotificationAction.plain(ACCEPT_CALL, 'Chấp nhận'),
            DarwinNotificationAction.plain(DECLINE_CALL, 'Từ chối'),
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
      CHANNEL_ID, // Đảm bảo giống với ID bạn dùng trong NotificationDetails
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 👉 Request permission
    await notifPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await notifPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          _onDidReceiveBackgroundNotificationResponse,
      onDidReceiveNotificationResponse:
          _onDidReceiveForegroundNotificationResponse,
    );
  }

  // handle notif from terminate state
  static Future<void> initialMessage() async {
    final notifAppLaunchDetails =
        await notifPlugin.getNotificationAppLaunchDetails();
    if (notifAppLaunchDetails == null) return;

    final appOpenViaNotif = notifAppLaunchDetails.didNotificationLaunchApp;
    if (appOpenViaNotif) {
      final notifResponse = notifAppLaunchDetails.notificationResponse;
      if (notifResponse == null) return;
      await _handleNotificationResponse(notifResponse, isTerminateApp: true);
    }
    return;
  }

  static NotificationDetails _defaultNotifDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        CHANNEL_ID,
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
        CHANNEL_ID,
        'Incoming Calls',
        icon: '@mipmap/ic_launcher',
        sound: RawResourceAndroidNotificationSound('phone_ring'),
        playSound: true,
        autoCancel: false,
        enableVibration: true,
        ongoing: true,
        timeoutAfter: 10000,
        channelDescription: 'Incoming video calls',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true, // Làm thông báo nổi như cuộc gọi thật
        ticker: 'Incoming call',
        category: AndroidNotificationCategory.call, // Android call style
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            ACCEPT_CALL,
            'Chấp nhận',
            showsUserInterface: true,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            DECLINE_CALL,
            'Từ chối',
            showsUserInterface: true,
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
    await notifPlugin.show(
      id,
      title,
      body,
      notificationDetails ?? _defaultNotifDetails(),
      payload: payload,
    );
  }

  static cancelNotif() async {
    await notifPlugin.cancelAll();
  }
}
