import 'package:easy_date/core/base/base_controller/base_refresh_controller.dart';
import 'package:easy_date/core/enum/match_enum.dart';
import 'package:easy_date/features/home/controller/home_controller.dart';
import 'package:easy_date/utils/utils_src.dart';

import '../../../core/models/info_user_match_model.dart';
import '../repository/users_suggest_repository.dart';

class UsersSuggestController extends BaseRefreshGetxController {
  final UsersSuggestRepository usersSuggestRepository;

  UsersSuggestController({
    required this.usersSuggestRepository,
  });

  final userSuggest = Rxn<InfoUserMatchModel>();
  final userCurrent = Get.find<HomeController>().currentUser;
  final countWaiting = 0.obs;
  final countBlock = 0.obs;
  final countRequest = 0.obs;

  @override
  void onReady() async {
    super.onReady();
    await getUserSuggest();
    getDataCountBadge();
  }

  void getDataCountBadge() {
    countWaiting.value = userCurrent.value?.users.entries
            .where((user) => user.value.status == MatchEnum.waiting.value)
            .length ??
        0;
    countBlock.value = userCurrent.value?.users.entries
            .where((user) => user.value.status == MatchEnum.block.value)
            .length ??
        0;
    countRequest.value = userCurrent.value?.users.entries
            .where((user) => user.value.status == MatchEnum.request.value)
            .length ??
        0;
  }

  Future<void> getUserSuggest() async {
    try {
      isShowLoading.value = true;
      final data = await usersSuggestRepository.getUserSuggest();
      userSuggest.value = data;
    } catch (e) {
      handleException(e);
    } finally {
      isShowLoading.value = false;
    }
  }

  @override
  Future<void> onLoadMore() async {
    // Do nothing
  }

  @override
  Future<void> onRefresh() async {
    await getUserSuggest();
    refreshController.refreshCompleted();
  }
}
