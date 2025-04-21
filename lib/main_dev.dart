import 'package:easy_date/core/config_noti/fcm.dart';
import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'core/core_src.dart';
import 'firebase/firebase_options_dev.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(
    env: AppEnv.dev,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp();
  await LocalNotif.init();
  await FCM.init();

  runApp(App(config: config));
}
