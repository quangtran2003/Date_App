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
              onTap: () {
                Get.toNamed(AppRoute.match.path);
              },
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Column(
                    children: [
                      _buildImage(controller),
                      _buildInfoCard(controller),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // _buildCircleChip(isExits: true),
                      AppDimens.hm12,
                      _buildCircleChip(),
                    ],
                  ).paddingOnly(bottom: 60, right: AppDimens.padding24),
                ],
              ),
            ),
    ),
  );
}

Widget _buildCircleChip({bool isExits = false}) {
  return Container(
    width: AppDimens.sizeImageMedium,
    height: AppDimens.sizeImageMedium,
    decoration: BoxDecoration(
        color: AppColors.grayLight7,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ]),
    child: Center(
      child: isExits
          ? UtilWidget.buildText(
              'X',
              style: AppTextStyle.font36Re.copyWith(
                color: AppColors.primaryLight2,
              ),
            )
          : Image.asset(Assets.ASSETS_IMAGES_LOVE__PNG)
              .paddingAll(AppDimens.paddingSmall),
    ),
  );
}

Container _buildInfoCard(UsersSuggestController controller) {
  return Container(
    width: double.infinity,
    height: 90,
    padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.paddingMedium, vertical: AppDimens.paddingSmall),
    decoration: const BoxDecoration(
      color: AppColors.grayLight7,
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
            // Image.asset(
            //   Assets.ASSETS_IMAGES_PLACE_PNG,
            //   height: AppDimens.sizeIcon,
            //   width: AppDimens.sizeIcon,
            // ),
            SvgPicture.asset(
              Assets.ASSETS_ICONS_IC_LOCATION_SVG,
              width: AppDimens.sizeIcon,
              height: AppDimens.sizeIcon,
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
            AppRoute.userList.path,
            arguments: MatchEnum.waiting,
          ),
        ),
        AppDimens.hm8,
        UtilWidget.buildChoiceChip(
          isSelected: true,
          title: LocaleKeys.user_waitingList.tr,
          onChanged: (_) => Get.toNamed(
            AppRoute.userList.path,
            arguments: MatchEnum.request,
          ),
        ),
        AppDimens.hm8,
        UtilWidget.buildChoiceChip(
          isSelected: true,
          title: LocaleKeys.user_blockList.tr,
          onChanged: (_) => Get.toNamed(
            AppRoute.userList.path,
            arguments: MatchEnum.block,
          ),
        ),
      ],
    ),
  ).paddingSymmetric(vertical: AppDimens.paddingSmall);
}

// Widget _buildChoiceChip(String content, Function()? onTap) {
//   return Expanded(
//     child: InkWell(
//       onTap: onTap,
//       child: Container(
//         alignment: Alignment.center,
//         decoration: const BoxDecoration(
//           color: AppColors.grayLight7,
//           borderRadius: BorderRadius.all(
//             Radius.circular(AppDimens.radius16),
//           ),
//         ),
//         child: UtilWidget.buildText(content, fontWeight: FontWeight.bold)
//             .paddingSymmetric(
//                 horizontal: AppDimens.padding10, vertical: AppDimens.padding6),
//       ),
//     ),
//   );
// }

AppBar _buildAppBar() {
  return AppBar(
    centerTitle: false,
    scrolledUnderElevation: 0,
    title: UtilWidget.buildText(
      LocaleKeys.app_appName,
      style: AppTextStyle.font36Bo,
    ),
  );
}
