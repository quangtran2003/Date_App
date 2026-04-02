import 'package:easy_date/features/chat/repository/chat_repository.dart';
import 'package:easy_date/features/match_user/match_user_src.dart';
import 'package:get/get.dart';

class MatchUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => MatchUserController(
        matchUserRepository: Get.find<MatchUserRepository>(),
        chatRepository: Get.find<ChatRepository>(),
      ),
    );
  }
}
