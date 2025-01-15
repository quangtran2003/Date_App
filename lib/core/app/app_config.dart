import 'package:firebase_core/firebase_core.dart';

enum AppEnv {
  dev,
  prod;
}

class AppConfig {
  final AppEnv env;
  final FirebaseOptions firebaseOptions;
  // final String baseUrl;

  const AppConfig({
    required this.env,
    required this.firebaseOptions,
  });
}
