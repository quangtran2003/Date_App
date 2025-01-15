import 'package:get/get.dart';

import '../controller/profile_controller.dart';
import '../repository/profile_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileController(profileRepository: Get.find<ProfileRepository>()),
    );
  }
}
