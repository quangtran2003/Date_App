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

void _handleNotificationResponse(
    NotificationResponse notificationResponse) async {
  final payloadJson = notificationResponse.payload;
  if (payloadJson == null) {
    log('No payload found in notification response');
    return;
  }

  try {
    final Map<String, dynamic> payload = jsonDecode(payloadJson);
    log('Action ID: ${notificationResponse.actionId}, Notification ID: ${notificationResponse.id}');
    final dataNoti = PushNotificationData.fromJson(payload);

    if (notificationResponse.actionId == DECLINE_CALL) {
      if (notificationResponse.id != null) {
        await LocalNotif._notifPlugin.cancel(notificationResponse.id!);
        log('Notification with ID ${notificationResponse.id} canceled');
      } else {
        log('Error: Notification ID is null');
      }

      await FirebaseFirestore.instance
          .collection(FirebaseCollection.calls)
          .doc(dataNoti.callId)
          .update({
        'status': StatusCallEnum.rejected.value,
      });
      log('Firebase updated: call ${dataNoti.callId} status set to rejected');
    } else if (dataNoti.pageName != null && dataNoti.idReceiver != null) {
      final isCall =
          MessageTypeEnum.isTypeCall(dataNoti.type) && dataNoti.callId != null;
      isCall
          ? Get.toNamed(
              dataNoti.pageName!,
              arguments: CallArgs(
                typeCall:
                    MessageTypeEnum.fromInt(int.parse(dataNoti.type ?? '')),
                idCurrentUser: dataNoti.idReceiver ?? '',
                nameCurrentUser: dataNoti.nameSender ?? '',
                idOtherUser: dataNoti.idReceiver ?? '',
                callID: dataNoti.callId,
                statusCall: StatusCallEnum.accepted,
              ),
            )
          : Get.toNamed(
              dataNoti.pageName!,
              arguments: UserChatArgument(
                idReceiver: dataNoti.idSender ?? '',
                nameReceiver: dataNoti.nameSender ?? '',
                imgAvtReceiver: dataNoti.imgAvtSender ?? '',
              ),
            );
    }
  } catch (e) {
    log('Error handling notification response: $e');
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
      onDidReceiveNotificationResponse:
          _onDidReceiveForegroundNotificationResponse,
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
