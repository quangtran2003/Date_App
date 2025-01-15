import 'package:flutter/material.dart';
import '../base_src.dart';
import '../../const/const_src.dart';

import '../../../utils/utils_src.dart';

abstract class BaseRefreshWidget<T extends BaseRefreshGetxController>
    extends BaseGetWidget<T> {
  const BaseRefreshWidget({super.key});

  Widget buildPage(
      {PreferredSizeWidget? appBar,
      required Widget body,
      double miniumBottom = 0,
      RxBool? isShowSupportCus,
      Color? statusBarColor,
      bool isNeedUpToPage = false}) {
    // Rx<Offset> position = Offset(Get.width - 50, Get.height / 2 + 100).obs;
    // RxBool? isDraging = false.obs;

    return UtilWidget.buildSafeArea(
      Obx(
        () => Stack(
          alignment: Alignment.bottomRight,
          children: [
            Scaffold(
              appBar: appBar,
              body: body,
              extendBody: true,
              floatingActionButton:
                  isNeedUpToPage && controller.showBackToTopButton.value
                      ? InkWell(
                          onTap: () {
                            controller.scrollControllerUpToTop.animateTo(0,
                                duration: const Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn);
                          },
                          child: const CircleAvatar(
                            backgroundColor: AppColors.lightPrimaryColor,
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              size: AppDimens.sizeIconSpinner,
                              color: AppColors.white,
                            ),
                          ),
                        )
                      : null,
            ),
          ],
        ),
      ),
      color: statusBarColor,
      miniumBottom: 0,
    );
  }
}
