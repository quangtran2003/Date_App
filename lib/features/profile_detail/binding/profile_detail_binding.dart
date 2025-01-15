import '../../../utils/utils_src.dart';
import '../profile_detail_src.dart';

class ProfileDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileDetailController(
        profileDetailRepo: Get.find<ProfileDetailRepository>(),
      ),
    );
  }
}
