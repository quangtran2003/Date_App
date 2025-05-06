part of 'forgot_pass_page.dart';

Widget _buildResigerButton(ForgotPassController controller) {
  return Obx(
    () => UtilWidget.buildSolidButton(
      height: AppDimens.btnDefaultFigma,
      title: LocaleKeys.login_continue.tr,
      onPressed: controller.forgotPass,
      isLoading: controller.isShowLoading.value,
      showShadow: true,
    ),
  );
}

Widget _buildLoginButton() {
  return TextButton(
    onPressed: Get.back,
    child: UtilWidget.buildText(
      textAlign: TextAlign.end,
      LocaleKeys.login_backToLogin.tr,
      textColor: AppColors.isDarkMode ? AppColors.white : AppColors.black,
    ),
  );
}

Widget _buildInputEmail(ForgotPassController controller) {
  return BuildInputTextWithLabel(
    label: LocaleKeys.login_email.tr,
    buildInputText: BuildInputText(
      InputTextModel(
        hintText: LocaleKeys.login_emailHint.tr,
        controller: controller.emailTextCtrl,
        isReadOnly: controller.isShowLoading.value,
        focusNode: controller.emailFocusNode,
        validator: (value) {
          if (value != null && value.isEmpty) {
            return LocaleKeys.login_emailRequired.tr;
          }
          if (value != null && !GetUtils.isEmail(value)) {
            return LocaleKeys.firebaseAuth_invalidEmail.tr;
          }
          return null;
        },
      ),
    ),
  );
}

Widget _buildImageBackGroud() {
  return Center(
    child: Hero(
      tag: 'bg_login',
      child: SvgPicture.asset(
        Assets.ASSETS_ICONS_APP_ICON2_SVG,
        width: 200,
        height: 200,
      ).paddingOnly(bottom: AppDimens.paddingVerySmall),
    ),
  );
}
