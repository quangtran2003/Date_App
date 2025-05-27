import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_date/assets.dart';
import 'package:easy_date/features/chat_bot/chat_bot_src.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/user_list/user_list_src.dart';
import 'package:flutter/cupertino.dart';

part 'chat_bot_widget.dart';

class ChatBotPage extends BaseGetWidget<ChatBotController> {
  const ChatBotPage({super.key});
  @override
  get controller => Get.put(ChatBotController(), permanent: true);
  @override
  buildWidgets(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.scrollToBottom();
    });
    return SDSSafeArea(
      child: Scaffold(
        body: Obx(
          () => SafeArea(
            child: Column(
              children: [
                _buildLablePage(controller),
                Expanded(
                  child: Column(
                    children: [
                      _buildListMessage(controller),
                      AppDimens.vm16,
                      _buildTextFieldAndIconSend(controller),
                      AppDimens.vm16,
                    ],
                  ).paddingSymmetric(horizontal: AppDimens.paddingSmall),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
