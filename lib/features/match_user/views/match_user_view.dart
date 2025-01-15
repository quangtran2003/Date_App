part of 'match_user_page.dart';

Widget _body(MatchUserController controller) {
  if (controller.listInfoUserMatchModel.isEmpty) {
    return buildBackButton();
  } else {
    return _buildCardMatch(controller);
  }
}

Widget _buildCardMatch(MatchUserController controller) {
  return Stack(
    children: [
      controller.indexCard < controller.listInfoUserMatchModel.length
          ? Stack(
              children: [
                HeartOverlay(
                  controller: controller.heartOverlayController,
                  duration: const Duration(milliseconds: 1500),
                  backgroundColor: Colors.transparent,
                  // tapDownType: TapDownType.single,
                  // verticalOffset: 20,
                  // horizontalOffset: -100,
                  enableGestures: false,
                  cacheExtent: 30,
                  // splashAnimationDetails: const SplashAnimationDetails(
                  //   enableSplash: true,
                  //   animationDuration: Duration(seconds: 2),
                  // ),
                  icon: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                    size: 100,
                  ),
                  child: _buildInfo(controller),
                ),
              ],
            )
          : buildBackButton(),
      _buildButtonMatch(controller),
    ],
  );
}

Widget buildBackButton() {
  return Center(
    child: InkWell(
      borderRadius: BorderRadius.circular(AppDimens.radius8),
      onTap: () {
        Get.back();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.matchUser_dataIsEmpty.tr,
            style: AppTextStyle.font18Ex,
          ),
          const Icon(
            Icons.arrow_back,
            size: AppDimens.sizeIcon28,
          ).paddingAll(AppDimens.paddingSmall),
        ],
      ).paddingAll(AppDimens.paddingVerySmall),
    ),
  );
}

SizedBox _buildInfo(MatchUserController controller) {
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Obx(
      () => CardSwiper(
          controller: controller.cardSwiperController,
          cardsCount: controller.listInfoUserMatchModel.length,
          onSwipe: controller.onSwipe,
          onSwipeDirectionChange: (horizontalDirection, verticalDirection) {
            controller.setSwipe(horizontalDirection);
          },
          isLoop: false,
          numberOfCardsDisplayed:
              controller.listInfoUserMatchModel.length > 1 ? 2 : 1,
          backCardOffset: const Offset(40, 40),
          padding: const EdgeInsets.all(0.0),
          allowedSwipeDirection:
              const AllowedSwipeDirection.only(left: true, right: true),
          cardBuilder: (
            context,
            index,
            horizontalThresholdPercentage,
            verticalThresholdPercentage,
          ) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (index == controller.indexCard.value &&
                  horizontalThresholdPercentage == 0) {
                controller.setRatioIcon();
              }
            });

            return InfoUserMatchView(controller.listInfoUserMatchModel[index]);
            // return controller.cardsWidget[index];
          }),
    ),
  );
}

Widget _buildButtonMatch(MatchUserController controller) {
  return Visibility(
    visible:
        controller.indexCard.value < controller.listInfoUserMatchModel.length,
    child: Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: !(controller.ratioIconLeft.value == 0.1),
            child: InkWell(
              onTap: () {
                controller.skipUser(controller.userMatchView);
                controller.cardSwiperController.swipe(CardSwiperDirection.left);
              },
              child: SizedBox(
                width: 110 * controller.ratioIconLeft.value,
                height: 110 * controller.ratioIconLeft.value,
                child: SvgPicture.asset(Assets.ASSETS_ICONS_ICON_CLOSE_SVG),
              ),
            ),
          ),
          Visibility(
            visible: !(controller.ratioIconRight.value == 0.1),
            child: InkWell(
              onTap: () {
                controller.heartFly();
                controller.matchUser(controller.userMatchView);
                controller.cardSwiperController
                    .swipe(CardSwiperDirection.right);
              },
              child: SizedBox(
                width: 110 * controller.ratioIconRight.value,
                height: 110 * controller.ratioIconRight.value,
                child: SvgPicture.asset(Assets.ASSETS_ICONS_ICON_TYM_SVG),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
