import 'package:badges/badges.dart' as badges;
import 'package:easy_date/features/users_suggest/ui/users_suggest_page.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../assets.dart';
import '../../core/const/const_src.dart';
import '../../utils/utils_src.dart';
import '../profile/profile_src.dart';
import '../user_list/ui/user_list_page.dart';
import 'controller/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => NavigatorPopHandler(
        onPop: () async => await onWillPop(),
        child: Scaffold(
          appBar: AppBar(toolbarHeight: 0),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius30),
          topRight: Radius.circular(AppDimens.radius30),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayLight1.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimens.radius30),
          topRight: Radius.circular(AppDimens.radius30),
        ),
        child: BottomAppBar(
          // With material3, to set color for BottomAppBar,
          // we need to set color with both color and surfaceTintColor attributes
          color: Colors.white,
          surfaceTintColor: Colors.white,
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
                unselectedIconPath:
                    Assets.ASSETS_ICONS_IC_ADD_USER_UNSELECTED_SVG,
                selectedIconPath: Assets.ASSETS_ICONS_IC_ADD_USER_SELECTED_SVG,
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
                      ? AppColors.primaryLight2.withOpacity(0.25)
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
