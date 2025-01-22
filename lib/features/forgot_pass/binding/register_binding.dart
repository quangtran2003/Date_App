import 'package:easy_date/features/forgot_pass/controller/controller_src.dart';
import 'package:get/get.dart';

import '../repository/repository_src.dart';

class ForgotPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ForgotPassController(
        forgotPassRepository: Get.find<ForgotPassRepository>(),
      ),
    );
  }
}
