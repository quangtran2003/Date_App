import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/profile_match/profile_match_src.dart';

class ProfileMatchController extends BaseGetxController {
  ProfileMatchRepository profileMatchRepository;

  ProfileMatchController({required this.profileMatchRepository});

  InfoUserMatchModel? infoUserMatchModel;

  @override
  Future<void> onInit() async {
    String uid = Get.arguments;
    showLoading();
    try {
      infoUserMatchModel = await profileMatchRepository.getUserMatch(uid);
    } catch (e, s) {
      handleException(e, stackTrace: s);
    } finally {
      hideLoading();
    }
    super.onInit();
  }
}
