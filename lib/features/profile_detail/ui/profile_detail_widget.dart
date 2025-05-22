part of 'profile_detail_page.dart';

extension ProfileDetailWidget on ProfileDetailPage {
  PreferredSizeWidget _buildAppbar() {
    return AppBar(
      scrolledUnderElevation: 0,
      title: UtilWidget.buildAppBarTitle(
        LocaleKeys.profileDetail_datingProfile.tr,
      ),
      leading: Visibility(
        visible:
            controller.currentUser.value?.status == StatusEnum.active.value,
        child: InkWell(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.chevron_left,
            size: 32,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: controller.onSaveInfo,
          icon: UtilWidget.buildText(
            LocaleKeys.profileDetail_save.tr,
            style: AppTextStyle.font18Semi.copyWith(
              color: AppColors.primaryLight2,
            ),
          ),
        ),
        AppDimens.hm16,
      ],
      centerTitle: true,
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }

  Widget _buildAvatar() {
    return Visibility(
      visible:
          controller.currentUser.value?.status == StatusEnum.inactive.value,
      child: Container(
        margin: const EdgeInsets.only(
          top: AppDimens.paddingVerySmall,
          bottom: AppDimens.paddingVerySmall,
        ),
        alignment: Alignment.center,
        child: Obx(
          () {
            // if (controller.isUploadedAvatar.value) {
            //   return const CircleAvatar(
            //     radius: AppDimens.sizeImageBig,
            //     child: CupertinoActivityIndicator(),
            //   );
            // }

            return InkWell(
              customBorder: const CircleBorder(),
              onTap: controller.isUploadedAvatar.value
                  ? null
                  : controller.selectAvatar,
              child: Container(
                width: AppDimens.sizeImageBig * 2,
                height: AppDimens.sizeImageBig * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.primaryLight2.withValues(alpha: 0.1),
                    width: 2,
                  ),
                  image: !controller.avatarPath.isNullOrEmpty
                      ? DecorationImage(
                          image: FileImage(File(controller.avatarPath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: controller.avatarPath.isNullOrEmpty
                    ? const Icon(
                        Icons.image,
                        size: AppDimens.sizeIcon28,
                      )
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UtilWidget.buildText(
          LocaleKeys.profileDetail_info.tr,
          fontSize: AppDimens.fontBiggest(),
          fontWeight: FontWeight.bold,
        ),
        _buildItemLock(
          title: LocaleKeys.profileDetail_email.tr,
          text: controller.currentUser.value?.email ?? '',
          iconData: Icons.lock,
        ),
        AppDimens.vm12,
        _buildTextFormField(
          label: LocaleKeys.profileDetail_name.tr,
          hintText: LocaleKeys.profileDetail_inputName.tr,
          textController: controller.nameController,
          textValidator: LocaleKeys.profileDetail_nameRequired.tr,
        ),
        AppDimens.vm12,
        _buildTextFormField(
          label: LocaleKeys.profileDetail_yearOfBirth.tr,
          hintText: LocaleKeys.profileDetail_selectBirthday.tr,
          isReadOnly: true,
          textValidator: LocaleKeys.profileDetail_birthdayRequired.tr,
          textController: controller.birthdayController,
          suffixIcon: InkWell(
            onTap: controller.openDatePicker,
            child: const Icon(Icons.calendar_month_outlined),
          ),
        ),
        AppDimens.vm12,
        _buildGender(),
        _buildSexOrientation(),
        AppDimens.vm12,
        _buildTextFormField(
          label: LocaleKeys.profileDetail_placeOfOrigion.tr,
          hintText: LocaleKeys.profileDetail_addPlaceOfOrigion.tr,
          textController: controller.placeController,
          textValidator: LocaleKeys.profileDetail_placeRequired.tr,
        ),
      ],
    );
  }

  Widget _buildItemLock({
    required String text,
    required String title,
    required IconData iconData,
    Function()? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppDimens.vm12,
        UtilWidget.buildText(
          title.tr,
          fontSize: AppDimens.fontMedium(),
          fontWeight: FontWeight.bold,
        ),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppDimens.paddingSmall),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.isDarkMode
                  ? AppColors.darkAccentColor
                  : AppColors.grayLight8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: UtilWidget.buildText(
                    text,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimens.fontMedium(),
                  ),
                ),
                Icon(
                  iconData,
                  size: AppDimens.sizeIcon,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required String label,
    required TextEditingController textController,
    required String hintText,
    bool isReadOnly = false,
    bool isRequired = true,
    String? textValidator,
    bool showIconClear = true,
    bool isShowCounterText = false,
    TextStyle? textStyle,
    int? maxLines,
    int? maxLengthInputForm,
    Widget? suffixIcon,
  }) {
    return BuildInputTextWithLabel(
      label: label,
      isRequired: isRequired,
      textStyle: textStyle,
      buildInputText: BuildInputText(
        InputTextModel(
          hintText: hintText,
          controller: textController,
          maxLines: maxLines,
          isReadOnly: isReadOnly,
          showIconClear: showIconClear,
          maxLengthInputForm: maxLengthInputForm,
          isShowCounterText: isShowCounterText,
          validator: isRequired
              ? (value) {
                  if (value != null && value.isEmpty) {
                    return textValidator;
                  }

                  return null;
                }
              : null,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UtilWidget.buildText(
              LocaleKeys.profileDetail_gender.tr,
              fontSize: AppDimens.fontMedium(),
              fontWeight: FontWeight.bold,
            ),
            UtilWidget.buildText(
              '*',
              fontSize: AppDimens.fontMedium(),
              textColor: AppColors.colorRed,
            ),
          ],
        ),
        Row(
          children: SexEnum.values.take(2).map((item) {
            return Expanded(
              child: RadioListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryLight2,
                value: item.value,
                groupValue: controller.gender.value,
                onChanged: controller.onChangeGender,
                title: UtilWidget.buildText(item.label),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSexOrientation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UtilWidget.buildText(
              LocaleKeys.profileDetail_sexualOrientation.tr,
              fontSize: AppDimens.fontMedium(),
              fontWeight: FontWeight.bold,
            ),
            UtilWidget.buildText(
              '*',
              fontSize: AppDimens.fontMedium(),
              textColor: AppColors.colorRed,
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryLight2,
                value: controller.isSexualFemale.value,
                onChanged: controller.onChangeSexualFemale,
                title: UtilWidget.buildText(LocaleKeys.profileDetail_female.tr),
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                activeColor: AppColors.primaryLight2,
                value: controller.isSexualMale.value,
                onChanged: controller.onChangeSexualMale,
                title: UtilWidget.buildText(LocaleKeys.profileDetail_male.tr),
              ),
            )
          ],
        ),
        Obx(
          () => Visibility(
            visible: controller.isSexualRequired.value,
            child: UtilWidget.buildText(
              LocaleKeys.profileDetail_sexualOrientationRequired.tr,
              textColor: AppColors.primaryLight2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        UtilWidget.buildText(
          LocaleKeys.profileDetail_imageSuggest.tr,
          fontSize: AppDimens.fontBiggest(),
          fontWeight: FontWeight.bold,
        ),
        AppDimens.vm12,
        Obx(
          () {
            return SizedBox(
              height: 150,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.listImgUpload.length + 1,
                itemBuilder: (context, index) {
                  if (index == controller.listImgUpload.length) {
                    return Visibility(
                      visible: controller.listImgUpload.length < 3,
                      child: InkWell(
                        onTap: () => controller
                            .uploadImage(controller.listImgUpload.length),
                        child: Container(
                          height: 150,
                          width: Get.width / 4,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.isDarkMode
                                ? AppColors.darkPrimaryColor
                                : AppColors.dsGray4,
                          ),
                          child: const Icon(
                            Icons.add_a_photo_sharp,
                            size: 28,
                          ),
                        ),
                      ),
                    );
                  }
                  final item = controller.listImgUpload[index];
                  return InkWell(
                    onTap: () =>
                        controller.uploadImage(index, isUpdateImg: true),
                    child: Container(
                      height: 150,
                      width: Get.width / 4,
                      padding: const EdgeInsets.all(AppDimens.padding2),
                      alignment: Alignment.topRight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.dsGray4,
                        image: DecorationImage(
                          image: item.isURL
                              ? NetworkImage(item)
                              : FileImage(File(item)) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () => controller.onDeleteImage(index),
                        style: IconButton.styleFrom(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          backgroundColor:
                              AppColors.black.withValues(alpha: 0.7),
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minHeight: AppDimens.sizeIconSpinner,
                          minWidth: AppDimens.sizeIconSpinner,
                        ),
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => AppDimens.hm12,
              ),
            );
          },
        ),
        AppDimens.vm16,
        _buildTextFormField(
          label: LocaleKeys.profileDetail_introduce.tr,
          hintText: LocaleKeys.profileDetail_description.tr,
          textController: controller.bioController,
          maxLines: 5,
          showIconClear: false,
          isShowCounterText: true,
          maxLengthInputForm: 500,
          isRequired: false,
          textStyle: TextStyle(
            fontSize: AppDimens.fontBiggest(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
