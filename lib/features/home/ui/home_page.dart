import 'package:badges/badges.dart' as badges;
import 'package:easy_date/features/feature_src.dart';
import 'package:flutter_svg/svg.dart';

import '../../../assets.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopScope(
        canPop: controller.canPop.value,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) return;
          final shouldPop = await controller.onWillPop();
          if (!shouldPop) {
            controller.canPop.value = false;
          }
        },
        child: SDSSafeArea(
          child: Scaffold(
            body: _buildBody(),
            bottomNavigationBar: _buildBottomNavigationBar(),
            floatingActionButton: _buildFloatingAction(),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingAction() {
    return InkWell(
      onTap: controller.gotoChatBot,
      child: Container(
        height: AppDimens.sizeImage,
        width: AppDimens.sizeImage,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(Assets.ASSETS_IMAGES_META_AI_GIF),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  //Thêm PageStorageKey vào key của page để lưu trạng thái page hiện tại
  Widget _buildBody() {
    return PageView(
      controller: controller.pageController,
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        controller.currentPageIndex.value = index;
      },
      children: const [
        UsersSuggestPage(key: PageStorageKey("UsersSuggestPage")),
        UserListPage(
          key: PageStorageKey("UserListPage"),
          tagKey: "home",
        ),
        ProfilePage(key: PageStorageKey("ProfilePage")),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius30),
          topRight: Radius.circular(AppDimens.radius30),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius30),
          topRight: Radius.circular(AppDimens.radius30),
        ),
        child: BottomAppBar(
          // With material3, to set color for BottomAppBar,
          // we need to set color with both color and surfaceTintColor attributes
          // color: Colors.white,
          surfaceTintColor: AppColors.grayLight8,
          shape: const CircularNotchedRectangle(),
          padding: EdgeInsets.zero,
          height: AppDimens.bottomAppBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                index: 0,
                unselectedIconPath: Assets.ASSETS_ICONS_IC_HOME_UNSELECTED_SVG,
                selectedIconPath: Assets.ASSETS_ICONS_IC_HOME_SELECTED_SVG,
                title: LocaleKeys.home_home.tr,
                onTap: controller.selectPage,
              ),
              _buildNavItem(
                index: 1,
                unselectedIconPath: Assets.ASSETS_ICONS_IC_CHAT_UNSELECTED_SVG,
                selectedIconPath: Assets.ASSETS_ICONS_IC_CHAT_SELECTED_SVG,
                title: LocaleKeys.home_pairing.tr,
                onTap: controller.selectPage,
              ),
              _buildNavItem(
                index: 2,
                unselectedIconPath:
                    Assets.ASSETS_ICONS_IC_PROFILE_UNSELECTED_SVG,
                selectedIconPath: Assets.ASSETS_ICONS_IC_PROFILE_SELECTED_SVG,
                title: LocaleKeys.home_profile.tr,
                onTap: controller.selectPage,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String unselectedIconPath,
    required String selectedIconPath,
    required int index,
    required String title,
    required void Function(int) onTap,
    int? notificationCount,
  }) {
    final isSelected = controller.currentPageIndex.value == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          onTap(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            notificationCount != null && notificationCount > 0
                ? badges.Badge(
                    badgeContent: UtilWidget.buildText(
                      "$notificationCount",
                      style: AppTextStyle.font12Re.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    child: _buildNavIcon(
                      unselectedIconPath: unselectedIconPath,
                      selectedIconPath: selectedIconPath,
                      isSelected: isSelected,
                    ),
                  )
                : _buildNavIcon(
                    unselectedIconPath: unselectedIconPath,
                    selectedIconPath: selectedIconPath,
                    isSelected: isSelected,
                  ),
            UtilWidget.buildText(
              title,
              style: isSelected
                  ? AppTextStyle.font10Semi
                      .copyWith(color: AppColors.primaryLight2)
                  : AppTextStyle.font10Re.copyWith(
                      color: AppColors.grayLight3,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required String unselectedIconPath,
    required String selectedIconPath,
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: !isSelected
            ? null
            : [
                BoxShadow(
                  color: isSelected
                      ? AppColors.primaryLight2.withValues(alpha: 0.25)
                      : Colors.transparent,
                  blurRadius: 7.7,
                  offset: const Offset(1, 4),
                ),
              ],
      ),
      child: SvgPicture.asset(
        isSelected ? selectedIconPath : unselectedIconPath,
        width: AppDimens.sizeIcon,
        height: AppDimens.sizeIcon,
      ).paddingOnly(
        bottom: AppDimens.paddingSmallest,
      ),
    );
  }
}
