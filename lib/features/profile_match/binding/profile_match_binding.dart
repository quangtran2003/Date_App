import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/profile_match/profile_match_src.dart';

class ProfileMatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileMatchController(
        profileMatchRepository: Get.find<ProfileMatchRepository>(),
      ),
    );
  }
}
