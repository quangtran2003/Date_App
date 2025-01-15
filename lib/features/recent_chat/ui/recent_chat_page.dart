import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/recent_chat/controller/recent_chat_controller.dart';
import 'package:easy_date/routes/app_route.dart';
import 'package:easy_date/utils/widgets/utils_widgets.src.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/model_src.dart';

part 'recent_chat_widget.dart';

class RecentChatPage extends BaseGetWidget<RecentChatController> {
  const RecentChatPage({super.key});

  @override
  Widget buildWidgets(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () {
                  if (controller.isShowLoading.value) {
                    return const Center(child: UtilWidget.buildLoading);
                  }

                  if (controller.users.isEmpty) {
                    return const Center(
                      child: Text("Empty"),
                    );
                  }

                  return UtilWidget.buildSmartRefresher(
                    refreshController: controller.refreshController,
                    onRefresh: controller.onRefresh,
                    onLoadMore: controller.onLoadMore,
                    enablePullUp: true,
                    enablePullDown: true,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        final user = controller.users[index];
                        return InkWell(
                          onTap: () {
                            Get.toNamed(
                              AppRoute.chat.path,
                              arguments: UserChatArgument(
                                name: "${user.email} [FAKE]",
                                uid: user.uid,
                                avatar: "https://i.imgur.com/QRuNxz7.png",
                              ),
                            );
                          },
                          child: Text(user.email).paddingSymmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        );
                      },
                      itemCount: controller.users.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    ),
                  );
                },
              ),
            ),
            AppDimens.vm24,
          ],
        ),
      ),
    );
  }
}
