import 'package:flutter/material.dart';

import 'core/core_src.dart';
import 'firebase/firebase_options_dev.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(
    env: AppEnv.dev,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App(config: config));
}
