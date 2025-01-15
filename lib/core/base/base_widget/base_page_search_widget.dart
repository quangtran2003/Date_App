import 'package:flutter/material.dart';
import '../base_controller/base_page_search_controller.dart';
import 'base_refresh_widget.dart';
import '../../const/const_src.dart';
import '../../../utils/utils_src.dart';

abstract class BasePageSearchWidget<T extends BasePageSearchController>
    extends BaseRefreshWidget<T> {
  const BasePageSearchWidget({super.key});

  /// Widget cài đặt appbar có thể scroll.
  ///
  ///  `listSLiverAppBar`, danh sách sliverappbar.
  ///
  ///  `widgetBody` widget chính của page dưới appbar.
  Widget buildAppBarScroll({
    required List<Widget> listSliverAppBar,
    required Widget widgetBody,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        KeyBoard.hide();
      },
      child: NestedScrollView(
        physics: const PageScrollPhysics(),
        controller: controller.scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return listSliverAppBar;
        },
        body: widgetBody,
      ),
    );
  }

  /// list sliver appbar.
  ///
  ///  `titleAppBar` chuỗi tiêu đề trên appbar.
  ///
  ///  `hintTextSearch` chuỗi tiêu đề ẩn trên inputtext.
  List<Widget> listSliverAppBar({
    required String titleAppBar,
    required String hintTextSearch,
    Widget? widgetDesc,
    List<Widget>? actions,
  }) {
    return <Widget>[
      Obx(
        () => SliverAppBar(
          backgroundColor: AppColors.white,
          floating: false,
          pinned: false,
          elevation: 0,
          automaticallyImplyLeading: controller.isScrollToTop(),
          actions: actions,
          flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return FlexibleSpaceBar(
              centerTitle: GetPlatform.isAndroid,
              collapseMode: CollapseMode.parallax,
              title: UtilWidget.buildAppBarTitle(titleAppBar),
            );
          }),
        ),
      ),
      Obx(
        () => SliverAppBar(
          backgroundColor: AppColors.white,
          pinned: true,
          floating: true,
          elevation: 0,
          centerTitle: true,
          expandedHeight: widgetDesc != null
              ? AppDimens.sizeAppBarBig
              : AppDimens.sizeAppBar,
          collapsedHeight: widgetDesc != null
              ? AppDimens.sizeAppBarBig
              : AppDimens.sizeAppBar,
          automaticallyImplyLeading: !controller.isScrollToTop(),
          actions: !controller.isScrollToTop() ? actions : null,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: BuildInputText(
                  InputTextModel(
                    prefixIconColor: AppColors.dsGray3,
                    controller: controller.searchController,
                    focusNode: null,
                    submitFunc: (v) => controller.functionSearch(),
                    iconNextTextInputAction: TextInputAction.search,
                    hintText: hintTextSearch,
                    iconLeading: Icons.search,
                    fillColor: AppColors.white,
                  ),
                ),
              ).paddingOnly(
                  left: !controller.isScrollToTop()
                      ? AppDimens.paddingSearchBarBig
                      : AppDimens.paddingSearchBarSmall,
                  right: !controller.isScrollToTop()
                      ? AppDimens.paddingSearchBarBig
                      : AppDimens.paddingSearchBarSmall,
                  top: AppDimens.paddingVerySmall,
                  bottom: AppDimens.paddingSmall),
              if (widgetDesc != null) widgetDesc
            ],
          ),
        ),
      ),
    ];
  }

  /// widget cấu hình từng item trong listview
  Widget widgetItemList(int index);
}
