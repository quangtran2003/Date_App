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
    decoration: const BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.vertical(
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
              Assets.ASSETS_IMAGES_PLACE_GIF,
              height: AppDimens.sizeIcon,
              width: AppDimens.sizeIcon,
            ),
            AppDimens.hm8,
            UtilWidget.buildText(controller.userSuggest.value?.place ?? '',
                style: AppTextStyle.font16Re.copyWith(),
                fontSize: AppDimens.fontBig(),
                maxLine: 1),
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
                Assets.ASSETS_IMAGES_BG_LOGIN_PNG,
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

Shimmer _buildShimmerCard() {
  return Shimmer.fromColors(
    baseColor: Colors.grey,
    highlightColor: Colors.grey.withOpacity(0.5),
    child: Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(AppDimens.radius20)),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Center(
                    child: Icon(
                      Icons.favorite_outlined,
                      color: Colors.black,
                      size: 120,
                    ),
                  ),
                ),
                Icon(
                  Icons.favorite_outlined,
                  color: Colors.black,
                  size: 70,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildListChoiceChips(UsersSuggestController controller) {
  return SizedBox(
    height: AppDimens.sizeIconLarge,
    child: ListView(
      scrollDirection: Axis.horizontal,
      children: [
        UtilWidget.buildChoiceChip(
          isSelected: true,
          title: LocaleKeys.home_likedYou.tr,
          onChanged: (_) => Get.toNamed(
            AppRouteEnum.user_list.path,
            arguments: MatchEnum.waiting,
          ),
        ),
        AppDimens.hm8,
        UtilWidget.buildChoiceChip(
          isSelected: true,
          title: LocaleKeys.user_waitingList.tr,
          onChanged: (_) => Get.toNamed(
            AppRouteEnum.user_list.path,
            arguments: MatchEnum.request,
          ),
        ),
        AppDimens.hm8,
        UtilWidget.buildChoiceChip(
          isSelected: true,
          title: LocaleKeys.user_blockList.tr,
          onChanged: (_) => Get.toNamed(
            AppRouteEnum.user_list.path,
            arguments: MatchEnum.block,
          ),
        ),
      ],
    ),
  ).paddingSymmetric(vertical: AppDimens.paddingSmall);
}

AppBar _buildAppBar() {
  return AppBar(
    centerTitle: false,
    scrolledUnderElevation: 0,
    title: InkWell(
      onTap: () {
        Get.toNamed(AppRouteEnum.pair.path);
        // /LocalNotif.showNotif(id: 1, body: 'qưqw', title: 'qưeqweq');
      },
      child: UtilWidget.buildText(
        LocaleKeys.app_appName,
        style: AppTextStyle.font36Bo,
      ),
    ),
  );
}
