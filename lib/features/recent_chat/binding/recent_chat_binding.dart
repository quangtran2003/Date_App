import 'package:get/get.dart';

import '../controller/recent_chat_controller.dart';
import '../repository/recent_chat_repository.dart';

class RecentChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RecentChatController(
        recentChatRepository: Get.find<RecentChatRepository>(),
      ),
    );
  }
}
