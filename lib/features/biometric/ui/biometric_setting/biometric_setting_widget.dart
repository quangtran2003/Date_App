part of 'biometric_setting.dart';

extension BiometricWidget on BiometricSetting {
  Widget _buildBiometricSetting() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: UtilWidget.buildText(
        controller.biometric.value.title,
        style: AppTextStyle.font18Bo,
      ),
      leading: ImageWidgets.imageSvg(
        controller.biometric.value.iconSvg,
        height: AppDimens.sizeIcon28,
        width: AppDimens.sizeIcon28,
      ),
      trailing: CupertinoSwitch(
        
        trackColor: AppColors.grayLight5,
        activeColor: AppColors.primaryLight2,
        value: controller.hasBiometric.value,
        onChanged: (_) {
          ShowPopup.showDialogConfirmWidget(
            confirm: controller.checkPassword,
            actionTitle: LocaleKeys.login_continue.tr,
            buildBody: _buildBodyPopup(controller),
          );
        },
      ),
    );
  }

  Widget _buildBodyPopup(BiometricController controller) {
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

  Widget _buildInputPasswordBiometric(BiometricController controller) {
    return BuildInputTextWithLabel(
      buildInputText: BuildInputText(
        InputTextModel(
          hintText: LocaleKeys.login_passwordHint.tr,
          controller: controller.passwordController,
          iconNextTextInputAction: TextInputAction.done,
          isReadOnly: controller.isShowLoading.value,
          obscureText: true,
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
}
