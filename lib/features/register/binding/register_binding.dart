import 'package:easy_date/features/register/controller/controller_src.dart';
import 'package:get/get.dart';

import '../repository/repository_src.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => RegisterController(
        registerRepository: Get.find<RegisterRepository>(),
      ),
    );
  }
}
