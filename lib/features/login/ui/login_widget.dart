part of 'login_page.dart';

Widget _buildLoginButton(LoginController controller) {
  return Obx(
    () => UtilWidget.buildSolidButton(
      height: AppDimens.btnDefaultFigma,
      title: LocaleKeys.login_login.tr,
      onPressed: controller.login,
      isLoading: controller.isShowLoading.value,
      showShadow: true,
    ),
  );
}

Widget _buildInputEmail(LoginController controller) {
  return BuildInputTextWithLabel(
    label: LocaleKeys.login_email.tr,
    buildInputText: BuildInputText(
      InputTextModel(
        hintText: LocaleKeys.login_emailHint.tr,
        controller: controller.emailTextCtrl,
        isReadOnly: controller.isShowLoading.value,
        focusNode: controller.emailFocusNode,
        nextNode: controller.passwordFocusNode,
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

Widget _buildInputPassword(LoginController controller) {
  return BuildInputTextWithLabel(
    label: LocaleKeys.login_password.tr,
    buildInputText: BuildInputText(
      InputTextModel(
        hintText: LocaleKeys.login_passwordHint.tr,
        controller: controller.passwordTextCtrl,
        focusNode: controller.passwordFocusNode,
        iconNextTextInputAction: TextInputAction.done,
        isReadOnly: controller.isShowLoading.value,
        obscureText: true,
        submitFunc: (_) {
          controller.login();
        },
        validator: (value) {
          if (value != null && (value.length < 6 || value.length > 20)) {
            return LocaleKeys.login_passwordRequired.tr;
          }
          return null;
        },
      ),
    ),
  );
}

Widget _buildRegisterButton(LoginController controller) {
  return TextButton(
    onPressed: controller.goToRegisterPage,
    child: UtilWidget.buildText(
      LocaleKeys.login_register.tr,
      style: AppTextStyle.font16Semi.copyWith(
        color: AppColors.grayLight2,
        decoration: TextDecoration.underline,
      ),
    ),
  );
}

Widget _buildImageBackGroup() {
  return Hero(
    tag: 'bg_login',
    child: SvgPicture.asset(
      Assets.ASSETS_ICONS_APP_ICON2_SVG,
      width: 200,
      height: 200,
    ).paddingOnly(bottom: AppDimens.paddingVerySmall),
  );
}

Widget _buildAppName() {
  return Center(
    child: UtilWidget.buildText(
      LocaleKeys.app_appName.tr,
      style: AppTextStyle.font32Semi,
    ).paddingSymmetric(horizontal: AppDimens.paddingExtra),
  );
}
