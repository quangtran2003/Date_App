import 'dart:convert';
import 'dart:developer';

import 'package:easy_date/assets.dart';
import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:googleapis_auth/auth_io.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  _showCustomNotif(message);
}

void _handleMessage(RemoteMessage message) {
}

void _showCustomNotif(RemoteMessage message) {
  final dataNoti = PushNotificationData.fromJson(message.data);

  final isTypeCall = MessageTypeEnum.isTypeCall(dataNoti.type ?? '');

  //nếu ở màn chat, có thông báo tin nhắn sẽ không hiển thị
  if (Get.currentRoute == AppRouteEnum.chat.path && !isTypeCall) return;

  if (dataNoti.notifTitle != null) {
    LocalNotif.showNotif(
      id: dataNoti.hashCode,
      title: dataNoti.notifTitle,
      body: dataNoti.notifBody,
      payload: jsonEncode(message.data),
      notificationDetails: isTypeCall ? LocalNotif.incomingCallDetails() : null,
    );
  }
}

class FCM extends BaseFirebaseRepository {
  static Future<void> init() async {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final settings = await FirebaseMessaging.instance.requestPermission();
    log('User granted permission: ${settings.authorizationStatus}');
    _foregroundHandler();
    _backgroundHandler();
    _listenOpenNotif();
  }

  static _foregroundHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('foreground!');
      _showCustomNotif(message);
    });
  }

  static _backgroundHandler() {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // for terminate state
  static initialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  static _listenOpenNotif() {
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static Future<String> getToken() async {
    final jsonStr =
        await rootBundle.loadString(Assets.ASSETS_KEYS_SERVICE_ACCOUNT_JSON);
    final credentials = ServiceAccountCredentials.fromJson(jsonDecode(jsonStr));
    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ]; // Thay thế bằng danh sách SCOPES của bạn
    final client = await clientViaServiceAccount(credentials, scopes);
    return client.credentials.accessToken.data;
  }
}
