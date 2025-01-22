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

Widget _buildInputEmail(ForgotPassController controller) {
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

Widget _buildInputPassword(ForgotPassController controller) {
  return BuildInputTextWithLabel(
    label: LocaleKeys.login_newPassword.tr,
    buildInputText: BuildInputText(
      InputTextModel(
        hintText: LocaleKeys.login_passwordHint.tr,
        controller: controller.passwordTextCtrl,
        focusNode: controller.passwordFocusNode,
        iconNextTextInputAction: TextInputAction.done,
        isReadOnly: controller.isShowLoading.value,
        obscureText: true,
        submitFunc: (_) {
          controller.forgotPass();
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

Widget _buildInputConfirmPassword(ForgotPassController controller) {
  return BuildInputTextWithLabel(
    label: LocaleKeys.login_confirmPassword.tr,
    buildInputText: BuildInputText(
      InputTextModel(
        hintText: LocaleKeys.login_confirmPasswordHint.tr,
        controller: controller.confirmPasswordTextCtrl,
        focusNode: controller.confirmPasswordFocusNode,
        iconNextTextInputAction: TextInputAction.done,
        isReadOnly: controller.isShowLoading.value,
        obscureText: true,
        submitFunc: (_) {
          controller.forgotPass();
        },
        validator: (value) {
          if (value != controller.passwordTextCtrl.text) {
            return LocaleKeys.login_confirmPasswordWrong.tr;
          }
          return null;
        },
      ),
    ),
  );
}

Widget _buildImageBackGroud() {
  return Hero(
    tag: 'bg_login',
    child: SvgPicture.asset(
      Assets.ASSETS_ICONS_APP_ICON2_SVG,
      width: 200,
      height: 200,
    ).paddingOnly(bottom: AppDimens.paddingVerySmall),
  );
}
