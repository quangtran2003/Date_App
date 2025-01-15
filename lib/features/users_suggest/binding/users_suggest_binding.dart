import 'package:easy_date/features/feature_src.dart';

class UsersSuggestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UsersSuggestController(
        usersSuggestRepository: Get.find<UsersSuggestRepository>()));
  }
}
