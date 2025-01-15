import 'package:flutter_local_notifications/flutter_local_notifications.dart';

void initServices() async {
  // await Get.put(ConnectivityService(), permanent: true);
}

Future<void> initLocal() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings("@mipmap/ic_launcher");

  InitializationSettings initializationSettings = const InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
