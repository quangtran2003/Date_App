import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:get/get.dart';

class MatchUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MatchUserController(
        matchUserRepository: Get.find<MatchUserRepository>(),
      ),
    );
  }
}
