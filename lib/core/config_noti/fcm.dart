import 'dart:convert';
import 'dart:developer';

import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:googleapis_auth/auth_io.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("background!");
  _showCustomNotif(message);
}

void _handleMessage(RemoteMessage message) {
  Map data = message.data;

  if (data.containsKey('pageName')) {
    logger.d("pageName: ${data['pageName']}");
    Get.toNamed(data['pageName']);
  }
}

void _showCustomNotif(RemoteMessage message) {
  // if (message.notification != null) {
  //   LocalNotif.showNotif(
  //     id: message.hashCode,
  //     title: message.notification!.title,
  //     body: message.notification!.body,
  //     payload: jsonEncode(message.data),
  //   );
  // }

  if (message.data.containsKey('notif_title')) {
    LocalNotif.showNotif(
      id: message.hashCode,
      title: message.data['notif_title'],
      body: message.data['notif_body'],
      payload: jsonEncode(message.data),
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
    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "easy-date-dev",
      "private_key_id": "f442148d838d3d6cfd199376c85b3552d4ec46bc",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC+v0cmDQ9pfmzP\n5PN5eOIHkzg0TbWm1sFFyAvLVLuf4N0POxTOZWNcAKm142Vrl7u6J4KjtwNN31of\n/UWWdUZP13sOILp9nrhdPOjDtrM35uvYbTskP0fuu/X02hiK7a8MzP+XWzsS0Ld/\nfAidMjgIbgtLamr2hSHvdAiU26v47+Q13Wly3H/jT/Podyt8wWZnhMJeTj/vrnsj\nGPit5Ei6P8zGJVnP0HkVIa+wYPPV09qlO+FQ5eWcbAFl73Ot+Ed9zb/lB24a2Uo0\nItSOmcJEQuKcwORbz5IYHlPCcxxj4Gqc4+3lI+/XpwffenQJMZ59GI+h/j8GntyO\nKO4+CIj9AgMBAAECggEAI7AqiexCILECf1AdHLJZCeVJzAFpFf7SuPFhgYjINPTP\nr2CUtzwhf65xEkKqMFv6h+0KBIMCl4CNPnR231xwTBJrJ9zIP6YhZPJ3M1z8wZ4P\nLNZdDR5Y4UoiDc57bozjZk/5lzI+xnmuB2hnvS+O68bZDqJpwlds3r4VN/K0xZWb\n2MDbZJnnofXxcgcAgEVpBN6GD1iuCi3IH3dIZ4wi69CPAqqvJXhpVql9CG1iGCy3\nQyDRX9KjCKIKDC4bTFp5/MoGIUXEGnRTViRuX0v8QtTwiAWiAUUUuJhO+svWfJrI\nkHEpE1rkn5dLNecLOA5RNspvOeITq5brsAmAgdkEGQKBgQDmSPkD1WmdFQu2fMtl\nYsujz96JwghGLoLm1BRD70k4rbDlWzgXxTJEGBtAumz/sPXKQspasfZbVi5fGRvY\ng1MWkKvuvZluUoFHanVfQVtIcmg3afRKM0I501XNflJN7qAygoLP/Lr753HKIL60\nonLxI2YcGeWuCIaTHH0ip8dpCQKBgQDUDA8Fem4lojJm1SRmlZnZcqhuMkVktb+e\nUyzQtCJzl0GHXogbuNaCIXyhOeQ4whUNdazzGtiT0K+frONRNRQZGAPf4JEiU2Ru\nsjHa9kpZVmYVgSPnFySzFtiT+xHTbEXeSrpb85c8B7ffk4VtC9dwHk0tZAs8FXCR\nlALlpqShVQKBgQCIMvacbtdlIXJo/wwpLbJ1c1cSMOFF6PJg5WQK/fZXgFsUe8wE\nOwxMu9k6gkg/PgFRHAmkdIbZZHJOqoIOnzVALlaSAC9D0aZGf89lhDkh8xByXccv\nL3vmyXiA7kptb0nuNcR6kOZiYHOrcYx5N2818ZLN4f823DIDxiC4o3TMSQKBgHbP\nCtuW7YBIkNTtN6gCymD7zUNxB1CWRPcAw2tsgqEhbqXaYYim2AmxmZL8TNNAa2tP\nM8hCkna/xqdAx10I0Gn++qzFtov1DaC4VxbISIAl2KzT3rnsTbPKaS8AzcwYLk2O\nsTw0D9iiunOaxHeE2wEG+VclZuYTXS80LytdY4DBAoGAUCi10qrOFEJWdhn98Cyu\noMoSd3GBqtVZojpASztYhk9eSQ46APnDndUGhmpvYRswsunE79R5mWMf93jy0bYo\nB1sTssbLS9zCPAjDq67JM0kmGrHlMf1h8ROVGW6gFk5Q07uKG3RMgTcaKwqrYC4A\nmQNI8UmOsKS9lOlAMd+ofmE=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-mvrk7@easy-date-dev.iam.gserviceaccount.com",
      "client_id": "110700428732485649716",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-mvrk7%40easy-date-dev.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    });

    final scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ]; // Thay thế bằng danh sách SCOPES của bạn
    final client = await clientViaServiceAccount(credentials, scopes);
    return client.credentials.accessToken.data;
  }
}
