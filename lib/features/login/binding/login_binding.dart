import 'package:get/get.dart';

import '../controller/login_controller.dart';
import '../repository/login_repository.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(loginRepository: Get.find<LoginRepository>()),
    );
  }
}
