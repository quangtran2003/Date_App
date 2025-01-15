import 'package:flutter/cupertino.dart';
import '../base_src.dart';

import '../../../utils/utils_src.dart';

abstract class BaseRefreshGetxController extends BaseGetxController {
  /// Controller của smart refresh.
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  ScrollController scrollControllerUpToTop = ScrollController();
  RxBool showBackToTopButton = false.obs;
  int pageNumber = 0;

  /// Hàm load more.
  Future<void> onLoadMore();

  /// Hàm refresh page.
  Future<void> onRefresh();

  @override
  void onInit() {
    super.onInit();
    scrollControllerUpToTop.addListener(() {
      showBackToTopButton.value = scrollControllerUpToTop.offset >= 100;
    });
  }
}
