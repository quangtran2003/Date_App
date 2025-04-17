import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/forgot_pass/forgot_pass_src.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:easy_date/features/profile_match/profile_match_src.dart';

class GlobalBinding extends Bindings {
  final AppConfig appConfig;

  GlobalBinding({
    required this.appConfig,
  });

  @override
  void dependencies() {
    Get.lazyPut(() => appConfig, fenix: true);
    Get.lazyPut(() => BaseConnectAPI(), fenix: true);

    // Put repositories
    // Note: Mark all fenix: true
    Get.lazyPut<LoginRepository>(
      () => LoginRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<ProfileRepository>(
      () => ProfileRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<RegisterRepository>(
      () => RegisterRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<ChatRepository>(
      () => ChatRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<StickerRepository>(
      () => StickerRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<UsersSuggestRepository>(
      () => UsersSuggestRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<UserListRepository>(
      () => UserListRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<ProfileDetailRepository>(
      () => ProfileDetailRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<MatchUserRepository>(
      () => MatchUserRepositoryImp(),
      fenix: true,
    );
    Get.lazyPut<ProfileMatchRepository>(
      () => ProfileMatchRepositoryImp(),
      fenix: true,
    );
    Get.lazyPut<ForgotPassRepository>(
      () => ForgotPassRepositoryImpl(),
      fenix: true,
    );
  }
}
