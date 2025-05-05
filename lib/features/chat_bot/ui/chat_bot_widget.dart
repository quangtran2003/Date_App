part of 'chat_bot_page.dart';

Widget _buildListMessage(ChatBotController controller) {
  return Expanded(
    child: ListView.builder(
      controller: controller.scrollController,
      shrinkWrap: true,
      itemCount: controller.messageList.length,
      itemBuilder: (context, index) {
        final message = controller.messageList[index];
        final isMe = message.isMe;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Obx(
                () => Container(
                  decoration: _buildBoxDecoration(isMe),
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      message.images.isEmpty
                          ? const SizedBox.shrink()
                          : _buildListImageQuestion(
                              message,
                              controller,
                            ),
                      message.isTyping.value
                          ? _buildResponseLoadding()
                          : _buildResponseView(message)
                    ],
                  ).paddingSymmetric(
                    horizontal: AppDimens.paddingDefault,
                    vertical: AppDimens.paddingVerySmall,
                  ),
                ),
              ).paddingOnly(
                top: AppDimens.paddingVerySmall,
                right: message.isMe
                    ? AppDimens.paddingZero
                    : AppDimens.paddingHuge,
                left: message.isMe
                    ? AppDimens.paddingHuge
                    : AppDimens.paddingZero,
              ),
            ),
          ],
        );
      },
    ),
  );
}

BoxDecoration _buildBoxDecoration(bool isMe) {
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      bottomLeft:
          isMe ? const Radius.circular(AppDimens.radius20) : Radius.zero,
      bottomRight:
          isMe ? Radius.zero : const Radius.circular(AppDimens.radius20),
      topLeft: const Radius.circular(AppDimens.radius20),
      topRight: const Radius.circular(AppDimens.radius20),
    ),
    color: isMe
        ? AppColors.isDarkMode
            ? AppColors.darkPrimaryColor
            : AppColors.grayLight7
        : AppColors.isDarkMode
            ? AppColors.darkAccentColor
            : AppColors.bgText,
  );
}

Widget _buildLablePage() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Image.asset(
        Assets.ASSETS_IMAGES_GEMINI_ICON_PNG,
        height: AppDimens.btnLarge,
        width: AppDimens.btnLarge,
        fit: BoxFit.cover,
      ),
      UtilWidget.buildText(
        "Dating AI",
        fontSize: AppDimens.sizeIconDefault,
      ),
      const Spacer(),
    ],
  );
}

Widget _buildListImageQuestion(Message message, ChatBotController controller) {
  return Wrap(
    runSpacing: AppDimens.paddingVerySmall,
    alignment: WrapAlignment.end,
    children: List.generate(
      message.images.length,
      (index) => _buildImageItem(
        controller: controller,
        haveDeleteIcon: false,
        path: message.images[index],
        index: index,
      ),
    ),
  ).paddingSymmetric(vertical: 4);
}

Widget _buildResponseView(Message message) {
  return Visibility(
    visible: message.text.value.isNotEmpty,
    child: message.hasAnimated && message.text.value.length < 100
        ? AnimatedTextKit(
            animatedTexts: [
              TyperAnimatedText(
                message.text.value.tr,
              ),
            ],
            totalRepeatCount: 1,
            displayFullTextOnTap: true,
            onFinished: () => message.hasAnimated = false,
          )
        : UtilWidget.buildText(
            message.text.value.tr,
            maxLine: 20,
            fontSize: AppDimens.fontSmall(),
          ),
  );
}

Widget _buildResponseLoadding() {
  return const SizedBox(
    width: AppDimens.btnDefault,
    child: Center(
      child: CupertinoActivityIndicator(),
    ),
  );
}

Widget _buildTextFieldAndIconSend(ChatBotController controller) {
  return Row(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.radius16),
            border: Border.all(width: 1, color: AppColors.dsGray2),
          ),
          child: Column(
            children: [
              _buildListQuestionImage(controller),
              _buildInputQuestion(controller),
            ],
          ),
        ),
      ),
      AppDimens.hm12,
      _buildIconBotton(controller)
    ],
  );
}

Widget _buildIconBotton(ChatBotController controller) {
  return InkWell(
    onTap: () {
      if (controller.textCtrl.text.isEmpty && controller.imagePaths.isEmpty) {
        return;
      }
      controller.sendQuestion();
    },
    child: const Icon(
      Icons.send,
      size: AppDimens.sizeIconLarge,
    ),
  );
}

Widget _buildInputQuestion(ChatBotController controller) {
  return BuildInputText(
    InputTextModel(
      controller: controller.textCtrl,
      maxLines: null,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      fillColor: AppColors.transparent,
      borderSide: BorderSide.none,
      disabledBorder: InputBorder.none,
      hintText: LocaleKeys.chat_inputQuestionHint.tr,
      border: InputBorder.none,
      borderRadius: AppDimens.radius12,
      suffixIcon: _buildSuffixIcon(controller),
    ),
  );
}

Widget _buildSuffixIcon(ChatBotController controller) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        onTap: () => controller.pickImage(isFromCamera: false),
        child: const Icon(
          Icons.image,
          size: AppDimens.sizeIconMedium,
        ),
      ),
      AppDimens.hm4,
      InkWell(
        onTap: () => controller.pickImage(),
        child: const Icon(
          Icons.camera_alt,
          size: AppDimens.sizeIconMedium,
        ),
      ),
      AppDimens.hm4,
    ],
  );
}

Widget _buildListQuestionImage(ChatBotController controller) {
  return Visibility(
    visible: controller.imagePaths.isNotEmpty,
    child: Container(
      alignment: Alignment.centerLeft,
      height: AppDimens.btnLarge,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.imagePaths.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildImageItem(
            controller: controller,
            path: controller.imagePaths[index],
            index: index,
          ).paddingOnly(right: AppDimens.paddingVerySmall);
        },
      ).paddingAll(AppDimens.paddingVerySmall),
    ),
  );
}

Widget _buildImageItem({
  required ChatBotController controller,
  required String path,
  bool haveDeleteIcon = true,
  int index = 0,
}) {
  return Stack(
    alignment: Alignment.topRight,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radius8),
        child: Image.file(
          File(path),
          width: AppDimens.btnMedium,
          height: AppDimens.btnMedium,
          fit: BoxFit.cover,
        ),
      ),
      Visibility(
        visible: haveDeleteIcon,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.dsGray2,
          ),
          child: InkWell(
            onTap: () => controller.imagePaths.removeAt(index),
            child: const Icon(
              Icons.close,
              size: AppDimens.btnSmall,
              color: AppColors.white,
            ),
          ),
        ),
      )
    ],
  ).paddingSymmetric(horizontal: 4);
}
