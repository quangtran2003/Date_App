import 'package:easy_date/utils/widgets/logo_loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay_pro/loading_overlay_pro.dart';
import '../../../utils/utils_src.dart';

import '../base_controller/base_controller.dart';

abstract class BaseGetWidget<T extends BaseGetxController> extends GetView<T> {
  const BaseGetWidget({super.key});

  Widget buildWidgets(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return buildWidgets(context);
  }

  Widget baseShowLoading(WidgetCallback child) {
    return Obx(
      () => controller.isShowLoading.value
          ? const Center(child: LogoLoading())
          : child(),
    );
  }

  /// Widget cài đặt phần widget chính của page gồm cả phần shimmer loading và phần body.
  Widget baseShimmerLoading(WidgetCallback child, {Widget? shimmer}) {
    return Obx(
      () => controller.isShowLoading.value
          ? shimmer ?? UtilWidget.buildShimmerLoading()
          : child(),
    );
  }

  Widget buildLoadingOverlay(WidgetCallback child) {
    return Obx(
      () => Stack(
        children: [
          LoadingOverlayPro(
            isLoading: controller.isLoadingOverlay.value,
            overLoading: const LogoLoading(),
            progressIndicator: const SizedBox.shrink(),
            child: child(),
          ),
        ],
      ),
    );
  }
}
