import 'package:easy_date/features/feature_src.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        homeRepository: HomeRepositoryImpl(),
      ),
    );
  }
}
