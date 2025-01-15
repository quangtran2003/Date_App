import 'package:bot_toast/bot_toast.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../routes/routers_src.dart';
import '../../utils/utils_src.dart';
import '../core_src.dart';

class App extends StatefulWidget {
  const App({
    Key? key,
    required this.config,
  }) : super(key: key);

  final AppConfig config;

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    RendererBinding.instance.deferFirstFrame();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadApp(context).whenComplete(() {
      if (mounted) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null && user.emailVerified) {
          Get.offAllNamed(AppRoute.home.path);
        } else {
          Get.offAllNamed(AppRoute.login.path);
        }
      }
    });
  }

  Future<void> _loadApp(BuildContext context) async {
    // Init Firebase
    await Firebase.initializeApp(options: widget.config.firebaseOptions);

    // NOTE: Consider only enabling Crashlytics in the production environment
    // if (widget.config.env == AppEnv.prod)

    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Init sau Firebase để tránh crash app nếu có lỗi
    await _initBeforeFirstFrame().whenComplete(
      () => RendererBinding.instance.allowFirstFrame(),
    );

    // Precache images, load data for app from API, DB, etc.
    await _initAfterFirstFrame();
  }

  /// Đảm bảo màn splash có khi được hiển thị sẽ hiển thị đúng theme và ngôn ngữ
  Future<void> _initBeforeFirstFrame() async {
    await Hive.initFlutter();
    await _initLocalStorages();
    // Load data for splash screen
    // await SplashScreen.precacheAssets(context);
  }

  Future<void> _initAfterFirstFrame() async {
    await Future.wait([
      precacheImages(context),
      AlbumStickerStorage.init(),
    ]);
    // ApiClient.init(baseUrl: _config.baseUrl);
  }

  Future<void> _initLocalStorages() async {
    await Future.wait([
      AppStorage.init(),
      _initSettingStorage(),
    ]);
  }

  Future<void> _initSettingStorage() async {
    await SettingStorage.init();
    // Load saved language
    final language = SettingStorage.language;
    if (language != null) {
      Get.updateLocale(language.locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: KeyBoard.hide,
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('vi', 'VN'),
        translationsKeys: AppTranslation.translations,
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate
        ],
        supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
        title: AppStr.appName.tr,
        getPages: AppRouter.routes,
        initialBinding: GlobalBinding(appConfig: widget.config),
        themeMode: ThemeMode.light,
        initialRoute: AppRoute.splash.path,
        builder: BotToastInit(),
        navigatorObservers: [
          BotToastNavigatorObserver(),
        ],
      ),
    );
  }
}
