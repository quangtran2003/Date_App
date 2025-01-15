import 'package:flutter/material.dart';

import '../../../utils/utils_src.dart';
import 'base_refresh_controller.dart';

abstract class BasePageSearchController<T> extends BaseRefreshGetxController {
  /// List kiểu Rx: list item trong page.
  RxList<T> rxList = RxList<T>();

  /// Controller của NestscrollView.
  late ScrollController scrollController;

  /// `scrollOffset`: biến trạng thái vị trí scroll.
  RxDouble scrollOffset = 0.0.obs;

  double appBarHeight = 70.0;

  /// Controller của input search.
  TextEditingController searchController = TextEditingController();

  @override
  // ignore: overridden_fields
  int pageNumber = 1;
  int totalRecords = 0;

  /// Hàm search
  Future<void> functionSearch();

  /// Kiểm tra vị trí scroll ở vị trí đầu.
  bool isScrollToTop() {
    return scrollOffset <= (appBarHeight - kToolbarHeight / 2);
  }
}
