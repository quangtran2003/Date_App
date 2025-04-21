part of 'chat_page.dart';

extension ChatWidget on ChatPage {
  PreferredSizeWidget _buildAppBar() {
    final receiver = controller.receiverUser;
    return AppBar(
      leadingWidth: 24,
      scrolledUnderElevation: 0,
      shape: const Border(
        bottom: BorderSide(color: AppColors.grayLight6, width: 1),
      ),
      title: InkWell(
        borderRadius: BorderRadius.circular(AppDimens.radius8),
        onTap: () {
          Get.toNamed(
            AppRouteEnum.profile_match.path,
            arguments: receiver.uid,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            buildUserAvatar(
              receiver.avatar,
              receiver.isOnline,
            ),
            AppDimens.hm8,
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UtilWidget.buildText(
                    receiver.name,
                    style: AppTextStyle.font16Bo,
                  ),
                  UtilWidget.buildText(
                    receiver.isOnline.value
                        ? LocaleKeys.chat_online.tr
                        : controller.timeAgoCustom(receiver.lastOnline),
                    textColor: AppColors.dsGray2,
                  ),
                ],
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: AppDimens.paddingSmallest),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.bottomSheet(
              UtilWidget.buildBottomSheetFigma(
                child: Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return UtilWidget.buildBottomSheetItem(
                        title: LocaleKeys.chat_blockUser.tr,
                        svgPath: Assets.ASSETS_ICONS_IC_BLOCK_SVG,
                        onTap: () {
                          Get.back();
                          ShowPopup.showDialogConfirm(
                            LocaleKeys.chat_blockUserConfirmMessage.tr,
                            actionTitle: LocaleKeys.profile_yes.tr,
                            confirm: () {
                              controller.blockUser();
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return UtilWidget.buildDivider(height: 1).paddingOnly(
                        left: AppDimens.paddingHuge,
                      );
                    },
                    itemCount: 1,
                  ),
                ),
              ),
              isScrollControlled: true,
              elevation: 0, // remove shadow
            );
          },
          icon: const Icon(Icons.more_vert),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: HeartOverlay(
        controller: controller.heartOverlayController,
        duration: heartAnimationDuration,
        backgroundColor: Colors.transparent,
        enableGestures: false,
        cacheExtent: 40,
        icon: const Icon(
          Icons.favorite,
          color: Colors.redAccent,
          size: 100,
        ),
        child: Column(
          children: [
            Expanded(child: _buildMessages()),
            _buildInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return Obx(
      () {
        if (controller.isShowLoading.value) {
          return const Center(child: LogoLoading());
        }

        if (controller.oldMessages.isEmpty && controller.newMessages.isEmpty) {
          return Center(
            child: UtilWidget.buildText(
              LocaleKeys.chat_emptyChat.tr,
              style: AppTextStyle.font16Re.copyWith(
                color: AppColors.grayLight6,
              ),
            ),
          );
        }

        final messages = [
          ...controller.newMessages.reversed,
          ...controller.oldMessages
        ];

        return UtilWidget.buildSmartRefresher(
          refreshController: controller.refreshController,
          onRefresh: controller.onRefresh,
          onLoadMore: controller.onLoadMore,
          enablePullUp: true,
          // enablePullDown: true,
          child: ListView.separated(
            controller: controller.chatScrollController,
            reverse: true,
            itemBuilder: (context, index) {
              final chatMessage = messages[index];

              bool showDate = false;
              if (index == messages.length - 1) {
                showDate = true;
              } else {
                final previousMessage = messages[index + 1];
                showDate = chatMessage.createDate != previousMessage.createDate;
              }

              switch (chatMessage.type) {
                case MessageType.text:
                  return TextMessageWidget(
                    showDate: showDate,
                    message: chatMessage,
                  );
                case MessageType.sticker:
                  return StickerMessageWidget(
                    showDate: showDate,
                    message: chatMessage,
                  );
              }
            },
            itemCount: messages.length,
            separatorBuilder: (context, index) {
              return AppDimens.vm16;
            },
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.defaultPadding,
              vertical: AppDimens.defaultPadding,
            ),
          ),
        );
      },
    );
  }

  Widget _buildInput() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.grayLight6,
            width: 1.0,
          ),
        ),
      ),
      child: TextField(
        controller: controller.messageTextCtrl,
        onChanged: (value) {
          if (value.isNotEmpty && controller.showSendButton.value == false) {
            controller.showSendButton.value = true;
          } else if (value.isEmpty) {
            controller.showSendButton.value = false;
          }
        },
        onEditingComplete: () {
          controller.sendMessage();
        },
        textInputAction: TextInputAction.send,
        decoration: InputDecoration(
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          fillColor: Colors.white,
          filled: true,
          hintText: LocaleKeys.chat_textFieldHint.tr,
          hintStyle: AppTextStyle.font16Re.copyWith(
            color: AppColors.grayLight6,
          ),
          prefixIcon: InkWell(
            onTap: () async {
              final sticker = await Get.toNamed(AppRouteEnum.sticker.path);
              if (sticker != null && sticker is Sticker) {
                controller.sendSticker(sticker);
              }
            },
            child: const Icon(
              Icons.sentiment_satisfied_alt,
              size: AppDimens.sizeIconSpinner,
              color: Colors.grey,
            ),
          ),
          suffixIcon: Obx(
            () {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return ScaleTransition(scale: animation, child: child);
                },
                child: !controller.showSendButton.value
                    ? InkWell(
                        key: const ValueKey(0),
                        onTap: () {
                          controller.sendMessage(customMessage: heartText);
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingVerySmall),
                          child: Icon(
                            CupertinoIcons.heart_fill,
                            size: AppDimens.sizeIcon28,
                            color: Colors.red,
                          ),
                        ),
                      )
                    : InkWell(
                        key: const ValueKey(1),
                        onTap: () {
                          controller.sendMessage();
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: AppDimens.paddingVerySmall),
                          child: Icon(
                            Icons.send,
                            size: AppDimens.sizeIcon28,
                            color: AppColors.colorBlueAccent,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
