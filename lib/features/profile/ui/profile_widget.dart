part of 'profile_page.dart';

extension ProfileWidget on ProfilePage {
  /// To Do: chưa biết fix
  Widget _buildProfile() {
    return Container(
      margin: const EdgeInsets.only(
        top: AppDimens.paddingHuge,
        bottom: AppDimens.paddingVerySmall,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () {
              return InkWell(
                onTap: controller.selectAvatar,
                customBorder: const CircleBorder(),
                child: SDSImageNetwork(
                  SDSImageNetworkModel(
                    borderRadius: BorderRadius.circular(AppDimens.radius90),
                    width: AppDimens.sizeImageBig * 2,
                    height: AppDimens.sizeImageBig * 2,
                    imgUrl: controller.user.value?.imgAvt,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          AppDimens.vm8,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              UtilWidget.buildText(
                controller.user.value?.name ?? "",
                fontSize: AppDimens.fontSize24(),
                fontWeight: FontWeight.bold,
                textColor: AppColors.dsGray1,
              ),
              AppDimens.hm4,
              const Icon(
                Icons.check_circle,
                color: Colors.blue,
                size: 18,
              ),
            ],
          ),
          AppDimens.vm4,
          UtilWidget.buildText(
            controller.user.value?.email ?? "",
            style: AppTextStyle.font16Semi.copyWith(
              color: AppColors.dsGray2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData iconData,
    required String title,
    Function()? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        iconData,
        size: AppDimens.sizeIconSpinner,
      ),
      title: UtilWidget.buildText(
        title.tr,
        style: AppTextStyle.font18Bo,
      ),
      contentPadding: EdgeInsets.zero,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.dsGray3,
        size: AppDimens.sizeIconSpinner,
      ),
    );
  }

  Widget _buildLanguage(ProfileController controller) {
    return ListTile(
      leading: const Icon(
        Icons.language,
        size: AppDimens.sizeIconSpinner,
      ),
      title: UtilWidget.buildText(
        LocaleKeys.profile_language.tr,
        style: AppTextStyle.font18Bo,
      ),
      contentPadding: EdgeInsets.zero,
      trailing: AdvancedSwitch(
        activeColor: Colors.red,
        inactiveColor: Colors.indigo,
        activeChild: UtilWidget.buildText(
          "VN",
          textColor: AppColors.white,
          fontSize: AppDimens.fontSmallest(),
          fontWeight: FontWeight.bold,
        ),
        inactiveChild: UtilWidget.buildText(
          "US",
          textColor: AppColors.white,
          fontSize: AppDimens.fontSmallest(),
          fontWeight: FontWeight.bold,
        ),
        height: 32,
        width: 52,
        controller: controller.languageController,
        thumb: const Icon(
          Icons.flag_circle_sharp,
          color: AppColors.white,
          size: AppDimens.sizeIcon,
        ),
        initialValue: SettingStorage.language == LanguageEnum.vietnamese,
        onChanged: (value) {
          if (value) {
            controller.changeLanguage(LanguageEnum.vietnamese);
          } else {
            controller.changeLanguage(LanguageEnum.english);
          }
        },
      ).paddingAll(AppDimens.paddingSmallest),
    );
  }
}
