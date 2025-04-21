import 'package:easy_date/features/forgot_pass/forgot_pass_src.dart';
import 'package:easy_date/features/match_user/binding/match_user_binding.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:easy_date/features/profile_match/profile_match_src.dart';
import 'package:easy_date/features/sticker/binding/sticker_binding.dart';

import '../features/feature_src.dart';

class AppRouter {
  static final routes = [
    GetPage(
      name: AppRouteEnum.login.path,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRouteEnum.register.path,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRouteEnum.forgot_pass.path,
      page: () => const ForgotPassPage(),
      binding: ForgotPassBinding(),
    ),
    GetPage(
      name: AppRouteEnum.chat.path,
      page: () => const ChatPage(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: AppRouteEnum.home.path,
      page: () => const HomePage(),
      bindings: [
        HomeBinding(),
        ProfileBinding(),
        UserListBinding(tag: "home"),
        UsersSuggestBinding(),
      ],
    ),
    GetPage(
      name: AppRouteEnum.sticker.path,
      page: () => const StickerPage(),
      binding: StickerBinding(),
    ),
    GetPage(
      name: AppRouteEnum.user_list.path,
      page: () => const UserListPage(),
      binding: UserListBinding(),
    ),
    GetPage(
      name: AppRouteEnum.profile_detail.path,
      page: () => const ProfileDetailPage(),
      binding: ProfileDetailBinding(),
    ),
    GetPage(
      name: AppRouteEnum.match.path,
      page: () => const MatchUserPage(),
      binding: MatchUserBinding(),
    ),
    GetPage(
      name: AppRouteEnum.profile_match.path,
      page: () => const ProfileMatchPage(),
      binding: ProfileMatchBinding(),
    ),
    GetPage(
      name: AppRouteEnum.splash.path,
      page: () => const SplashPage(),
    ),
  ];
}
