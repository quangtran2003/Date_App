import 'package:easy_date/features/chat_bot/controller/chat_bot_controller.dart';
import 'package:get/get.dart';

class ChatBotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatBotController());
  }
}
