part of 'profile_page.dart';

extension ProfileWidget on ProfilePage {
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
                child: Container(
                  width: AppDimens.sizeImageBig * 2,
                  height: AppDimens.sizeImageBig * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.white,
                    border: Border.all(
                      color: AppColors.primaryLight2.withOpacity(0.1),
                      width: 2,
                    ),
                    image: controller.user.value?.imgAvt != null
                        ? DecorationImage(
                            image: CachedNetworkImageProvider(
                              controller.user.value!.imgAvt,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: controller.isUploading.value
                      ? const CupertinoActivityIndicator()
                      : null,
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

  // Widget _buildLanguage(ProfileController controller) {
  //   return ListTile(
  //     leading: const Icon(
  //       Icons.language,
  //       size: AppDimens.sizeIconSpinner,
  //     ),
  //     title: UtilWidget.buildText(
  //       LocaleKeys.profile_language.tr,
  //       fontSize: AppDimens.fontMedium(),
  //       fontWeight: FontWeight.bold,
  //     ),
  //     contentPadding: EdgeInsets.zero,
  //     trailing: AdvancedSwitch(
  //       activeColor: Colors.red,
  //       inactiveColor: Colors.indigo,
  //       activeChild: UtilWidget.buildText(
  //         "VNI",
  //         textColor: AppColors.white,
  //         fontSize: AppDimens.fontSmallest(),
  //         fontWeight: FontWeight.bold,
  //       ),
  //       inactiveChild: UtilWidget.buildText(
  //         "ENG",
  //         textColor: AppColors.white,
  //         fontSize: AppDimens.fontSmallest(),
  //         fontWeight: FontWeight.bold,
  //       ),
  //       width: 60,
  //       controller: controller.languageController,
  //       thumb: const Icon(
  //         Icons.flag_circle_sharp,
  //         color: AppColors.white,
  //         size: AppDimens.sizeIcon,
  //       ),
  //       initialValue: SettingStorage.language == LanguageEnum.vietnamese,
  //       onChanged: (value) {
  //         if (value) {
  //           controller.changeLanguage(LanguageEnum.vietnamese);
  //         } else {
  //           controller.changeLanguage(LanguageEnum.english);
  //         }
  //       },
  //     ),
  //   );
  // }
}
