import 'package:easy_date/core/base/base_controller/base_refresh_controller.dart';
import 'package:easy_date/utils/utils_src.dart';

import '../../../core/models/info_user_match_model.dart';
import '../repository/users_suggest_repository.dart';

class UsersSuggestController extends BaseRefreshGetxController {
  final UsersSuggestRepository usersSuggestRepository;

  UsersSuggestController({
    required this.usersSuggestRepository,
  });

  final userSuggest = Rxn<InfoUserMatchModel>();

  @override
  void onReady() {
    super.onReady();
    _getUserSuggest();
  }

  Future<void> _getUserSuggest() async {
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
    await _getUserSuggest();
    refreshController.refreshCompleted();
  }
}
