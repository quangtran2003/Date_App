import 'dart:convert';
import 'dart:developer';

import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("background!");
  _showCustomNotif(message);
}

void _handleMessage(RemoteMessage message) {
  Map data = message.data;

  if (data.containsKey('navigate_to')) {
  }
}

void _showCustomNotif(RemoteMessage message) {
  if (message.notification != null) {
    LocalNotif.showNotif(
      id: message.hashCode,
      title: message.notification!.title,
      body: message.notification!.body,
      payload: jsonEncode(message.data),
    );
  }

//   if (message.data.containsKey('notif_title')) {
//     LocalNotif.showNotif(
//       id: message.hashCode,
//       title: message.data['notif_title'],
//       body: message.data['notif_body'],
//       payload: jsonEncode(message.data),
//     );
//   }
 }

class FCM {
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
}
