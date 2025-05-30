part of 'users_suggest_page.dart';

Widget _buildCardInfo(UsersSuggestController controller) {
  return Obx(() {
    return Expanded(
      child: controller.isShowLoading.value
          ? _buildShimmerCard()
          : _buildCard(controller),
    );
  });
}

Widget _buildCard(UsersSuggestController controller) {
  final rxnUserSuggest = controller.userSuggest;
  return UtilWidget.buildSmartRefresher(
    refreshController: controller.refreshController,
    onRefresh: controller.onRefresh,
    enablePullDown: true,
    child: Obx(
      () => rxnUserSuggest.value == null
          ? Center(
              child: UtilWidget.buildText(LocaleKeys.home_notData.tr),
            )
          : InkWell(
              onTap: () => Get.toNamed(AppRouteEnum.match.path),
              child: Column(
                children: [
                  _buildImage(controller),
                  _buildInfoCard(controller),
                ],
              ),
            ),
    ),
  );
}

Widget _buildInfoCard(UsersSuggestController controller) {
  return Container(
    width: double.infinity,
    height: 90,
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimens.paddingMedium,
      vertical: AppDimens.paddingSmall,
    ),
    decoration: BoxDecoration(
      color: AppColors.isDarkMode
          ? AppColors.darkAccentColor
          : AppColors.grayLight8,
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(AppDimens.radius20),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        UtilWidget.buildText(
            '${controller.userSuggest.value?.name.toString()}, ${controller.userSuggest.value?.birthday.toString()}',
            fontSize: AppDimens.fontBiggest(),
            fontWeight: FontWeight.bold,
            style: AppTextStyle.font24Bo.copyWith(
              color: AppColors.primaryLight2,
            ),
            maxLine: 1),
        Row(
          children: [
            Image.asset(
              Assets.ASSETS_IMAGES_GIF_PLACE_GIF,
              height: AppDimens.sizeIcon,
              width: AppDimens.sizeIcon,
            ),
            AppDimens.hm8,
            UtilWidget.buildText(
              controller.userSuggest.value?.place ?? '',
              style: AppTextStyle.font16Re.copyWith(),
              fontSize: AppDimens.fontBig(),
              maxLine: 1,
            ),
          ],
        ),
      ],
    ),
  );
}

_buildImage(UsersSuggestController controller) {
  return Expanded(
    child: SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimens.radius20),
        ),
        child: controller.userSuggest.value?.imgAvt == null
            ? Image.asset(
                Assets.ASSETS_IMAGES_PNG_BG_LOGIN_PNG,
                color: AppColors.grayLight5,
                fit: BoxFit.cover,
              )
            : CachedNetworkImage(
                imageUrl: controller.userSuggest.value!.imgAvt,
                fit: BoxFit.cover,
                placeholder: (context, url) => const SizedBox.shrink(),
                errorWidget: (context, url, error) {
                  return const Center(child: LogoLoading());
                },
              ),
      ),
    ),
  );
}

Widget _buildShimmerCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey,
    highlightColor: Colors.grey.withValues(alpha: 0.5),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppDimens.radius20)),
      child: Center(
        child: SizedBox(
          height: AppDimens.btnLarge,
          width: AppDimens.btnLarge,
          child: Image.asset(Assets.ASSETS_IMAGES_PNG_APP_ICON_PNG),
        ),
      ),
    ),
  );
}

Widget _buildListChoiceChips(UsersSuggestController controller) {
  return SizedBox(
    height: AppDimens.sizeIconLarge,
    child: Row(
      spacing: AppDimens.paddingVerySmall,
      children: [
        _buildChoiceChip(
          text: LocaleKeys.home_likedYou.tr,
          onTap: () => Get.toNamed(
            AppRouteEnum.user_list.path,
            arguments: MatchEnum.waiting,
          ),
          noti: controller.countWaiting,
        ),
        _buildChoiceChip(
          text: LocaleKeys.user_waitingList.tr,
          onTap: () => Get.toNamed(
            AppRouteEnum.user_list.path,
            arguments: MatchEnum.request,
          ),
          noti: controller.countRequest,
        ),
        _buildChoiceChip(
          text: LocaleKeys.user_blockList.tr,
          onTap: () => Get.toNamed(
            AppRouteEnum.user_list.path,
            arguments: MatchEnum.block,
          ),
          noti: controller.countBlock,
        ),
      ],
    ),
  ).paddingSymmetric(vertical: AppDimens.paddingSmall);
}

Widget _buildChoiceChip({
  required String text,
  required Function()? onTap,
  required RxInt noti,
}) {
  return Expanded(
    child: InkWell(
      onTap: onTap,
      child: Obx(
        () => Badge.count(
          textColor: AppColors.white,
          backgroundColor: AppColors.colorRed,
          isLabelVisible: noti > 0,
          count: noti.value,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.isDarkMode
                  ? AppColors.darkAccentColor
                  : AppColors.grayLight8,
              borderRadius: BorderRadius.circular(AppDimens.radius12),
            ),
            child: Center(
              child: UtilWidget.buildText(
                text,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

AppBar _buildAppBar() {
  return AppBar(
    centerTitle: false,
    scrolledUnderElevation: 0,
    title: UtilWidget.buildText(
      LocaleKeys.app_appName.tr,
      style: AppTextStyle.font36Bo,
    ),
  );
}
