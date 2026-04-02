import 'package:bot_toast/bot_toast.dart';
import 'package:easy_date/core/config_noti/fcm.dart';
import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/ui/ui_src.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class App extends StatefulWidget {
  final AppConfig config;
  final String initialRoute;

  const App({
    super.key,
    required this.config,
    required this.initialRoute,
  });

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> with WidgetsBindingObserver {
  bool isFromNotifTerminate = false;
  @override
  void initState() {
    super.initState();
    isFromNotifTerminate = widget.initialRoute != AppRouteEnum.splash.path;
    if (isFromNotifTerminate) return;
    FCM.initialMessage();
    LocalNotif.initialMessage();
    RendererBinding.instance.deferFirstFrame();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (Get.isRegistered<HomeController>()) {
      final homeCtrl = Get.find<HomeController>();
      final homeRepo = homeCtrl.homeRepository;
      final uid = homeRepo.firebaseAuth.currentUser?.uid;
      if (state == AppLifecycleState.paused && homeCtrl.isOnline) {
        _handleAppLifecycle(
          uid: uid,
          homeCtrl: homeCtrl,
        );
      } else if (state == AppLifecycleState.resumed && !homeCtrl.isOnline) {
        _handleAppLifecycle(
          uid: uid,
          homeCtrl: homeCtrl,
          isOnline: true,
        );
      }
    }
  }

  Future<void> _handleAppLifecycle({
    required String? uid,
    required HomeController homeCtrl,
    bool isOnline = false,
  }) async {
    if (uid == null) return;
    await homeCtrl.homeRepository.updateUserOnlineStatus(
      isOnline: isOnline,
      uid: uid,
    );
    homeCtrl.isOnline = isOnline;
    logger.d('App paused: Đã cập nhật trạng thái online = $isOnline');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isFromNotifTerminate) return;

    _loadApp().whenComplete(
      () {
        if (mounted) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null && user.emailVerified) {
            Get.offAllNamed(AppRouteEnum.home.path);
          } else {
            Get.offAllNamed(AppRouteEnum.login.path);
          }
        }
      },
    );
  }

  Future<void> _loadApp() async {
    // Init Firebase
    await Firebase.initializeApp(options: widget.config.firebaseOptions);

    // NOTE: Consider only enabling Crashlytics in the production environment
    // if (widget.config.env == AppEnv.prod)

    // // Pass all uncaught "fatal" errors from the framework to Crashlytics
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };

    // Init sau Firebase để tránh crash app nếu có lỗi
    await initBeforeFirstFrame().whenComplete(
      () => RendererBinding.instance.allowFirstFrame(),
    );

    // Precache images, load data for app from API, DB, etc.
    await _initAfterFirstFrame();
  }

  Future<void> _initAfterFirstFrame() async {
    await Future.wait([
      precacheImages(context),
      AlbumStickerStorage.init(),
    ]);
    // ApiClient.init(baseUrl: _config.baseUrl);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: KeyBoard.hide,
      child: GetMaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        locale: const Locale('vi', 'VN'),
        translationsKeys: AppTranslation.translations,
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('vi', 'VN'), Locale('en', 'US')],
        title: AppStr.appName.tr,
        getPages: AppRouter.routes,
        initialBinding: GlobalBinding(appConfig: widget.config),
        initialRoute: widget.initialRoute,
        builder: BotToastInit(),
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) => widget.initialRoute == AppRouteEnum.video_call.path
                ? const CallPage()
                : const SplashPage(),
          );
        },
        navigatorObservers: [
          BotToastNavigatorObserver(),
        ],
      ),
    );
  }
}

/// Đảm bảo màn splash có khi được hiển thị sẽ hiển thị đúng theme và ngôn ngữ
Future<void> initBeforeFirstFrame() async {
  await Hive.initFlutter();
  await _initLocalStorages();
  // Load data for splash screen
  // await SplashScreen.precacheAssets(context);
}

Future<void> _initLocalStorages() async {
  await Future.wait([
    AppStorage.init(),
    _initSettingStorage(),
  ]);
}

Future<void> _initSettingStorage() async {
  await SettingStorage.init();
  final language = SettingStorage.language;
  if (language != null) {
    Get.updateLocale(language.locale);
  }
  final theme = SettingStorage.themeMode;
  Get.changeThemeMode(
    theme == null
        ? ThemeMode.system
        : SettingStorage.themeMode == AppTheme.light
            ? ThemeMode.light
            : ThemeMode.dark,
  );
}
