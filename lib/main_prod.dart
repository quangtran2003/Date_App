import 'package:flutter/material.dart';

import 'core/core_src.dart';
import 'firebase/firebase_options_prod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(
    env: AppEnv.prod,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App(config: config));
}
