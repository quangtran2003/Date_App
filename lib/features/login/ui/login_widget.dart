part of 'login_page.dart';

Widget _buildLoginButton(LoginController controller) {
  return Obx(
    () => Row(
      children: [
        Expanded(
          child: UtilWidget.buildSolidButton(
            height: AppDimens.btnDefaultFigma,
            title: LocaleKeys.login_login.tr,
            onPressed: controller.login,
            isLoading: controller.isShowLoading.value,
            showShadow: true,
          ),
        ),
        _buildButtonBiometric(controller),
        AppDimens.hm8,
      ],
    ),
  );
}

Widget _buildButtonBiometric(LoginController controller) {
  return Container(
    height: AppDimens.btnDefaultFigma,
    width: AppDimens.btnDefaultFigma,
    decoration: const BoxDecoration(
      color: AppColors.primaryLight2,
      borderRadius: BorderRadius.all(Radius.circular(AppDimens.radius8)),
    ),
    child: Center(
      child: BiometricLogin(
        func: () async {
          if (AppStorage.getBiometric == true) {
            controller.biometricAuth(func: () async {
              controller.passwordTextCtrl.text =
                  await SecureStorage.password ?? '';
              Get.toNamed(AppRouteEnum.home.path);
            });
          } else {
            _promptBiometricSetup(controller);
          }
        },
      ),
    ),
  ).paddingOnly(
    left: AppDimens.paddingSmallest,
  );
}

void _formSettingBio(LoginController controller) {
  ShowPopup.showDialogConfirmWidget(
    confirm: () async {
      await controller.login(isBiometric: true);
    },
    actionTitle: LocaleKeys.login_continue.tr,
    buildBody: _buildBodyPopup(controller),
  );
  controller.passwordTextCtrl.clear();
}

Widget _buildBodyPopup(LoginController controller) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      UtilWidget.buildText(
        LocaleKeys.biometric_inputPassToVerify.tr,
        style: Get.textTheme.bodyLarge?.copyWith(color: AppColors.dsGray1),
        textAlign: TextAlign.center,
      ),
      _buildInputPasswordBiometric(controller),
      AppDimens.vm12,
    ],
  ).paddingSymmetric(
    horizontal: AppDimens.paddingVerySmall,
  );
}

void _promptBiometricSetup(LoginController controller) {
  ShowPopup.showDialogConfirm(LocaleKeys.biometric_suggestBiometric.tr,
      confirm: () => controller.biometricAuth(
            func: () => _formSettingBio(controller),
          ),
      actionTitle: LocaleKeys.login_continue.tr);
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

Widget _buildInputPasswordBiometric(LoginController controller) {
  return BuildInputTextWithLabel(
    buildInputText: BuildInputText(
      InputTextModel(
        hintText: LocaleKeys.login_passwordHint.tr,
        controller: controller.passwordBiometricCtrl,
        iconNextTextInputAction: TextInputAction.done,
        isReadOnly: controller.isShowLoading.value,
        obscureText: true,
        submitFunc: (_) {
          controller.login(isBiometric: true);
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
  return Center(
    child: TextButton(
      onPressed: controller.goToRegisterPage,
      child: UtilWidget.buildText(
        LocaleKeys.login_register.tr,
        style: AppTextStyle.font16Semi.copyWith(
          color: AppColors.grayLight2,
          decoration: TextDecoration.underline,
        ),
      ),
    ),
  );
}

Widget _buildForgotpassBtn(LoginController controller) {
  return InkWell(
      onTap: controller.goToForgotPassPage,
      child: UtilWidget.buildText(LocaleKeys.login_forgotPassword.tr));
}

Widget _buildImageBackGroup() {
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

Widget _buildAppName() {
  return Center(
    child: UtilWidget.buildText(
      LocaleKeys.app_appName.tr,
      style: AppTextStyle.font32Semi,
    ).paddingSymmetric(horizontal: AppDimens.paddingExtra),
  );
}
