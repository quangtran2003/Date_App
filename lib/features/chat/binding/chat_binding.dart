import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../repository/chat_repository.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatController(
        chatRepository: Get.find<ChatRepository>(),
      ),
    );
  }
}
