part of 'biometric_setting.dart';

extension BiometricWidget on BiometricSetting {
  Widget _buildBiometricSetting() {
    return Row(
      children: [
        ImageWidgets.imageSvg(
          controller.biometric.value.iconSvg,
          height: AppDimens.sizeIcon28,
          width: AppDimens.sizeIcon28,
          color: Colors.white,
        ),
        Expanded(
          child: Text(
            controller.biometric.value.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppDimens.fontSize24(),
              fontFamily: 'Lora',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        CupertinoSwitch(
          trackColor: AppColors.dsGray1,
          activeColor: AppColors.scaffoldBackground,
          value: controller.haveBiometric.value,
          onChanged: (_) {
            Get.dialog(
              _buildDialogBiometric(),
              barrierColor: AppColors.transparent,
            );
          },
        ),
      ],
    );
  }

  Widget _buildDialogBiometric() {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsetsDirectional.all(AppDimens.paddingMedium),
          padding: const EdgeInsetsDirectional.all(AppDimens.paddingMedium),
          decoration: BoxDecoration(
            color: AppColors.dsGray4,
            borderRadius: BorderRadius.circular(AppDimens.radius16),
          ),
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UtilWidget.buildText(
                  LocaleKeys.biometric_passBiometric.tr,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.start,
                  fontSize: AppDimens.fontMedium(),
                ),
                AppDimens.vm4,
                UtilWidget.buildText(
                  LocaleKeys.biometric_passBiometricHint.tr,
                  textAlign: TextAlign.start,
                  fontSize: AppDimens.fontSmall(),
                ),
                AppDimens.vm4,
                _buildPassword(),
                AppDimens.vm4,
                if (controller.wrongPassword.value) ...[
                  UtilWidget.buildText(
                    LocaleKeys.biometric_passBiometricFail.tr,
                    textAlign: TextAlign.start,
                    fontSize: AppDimens.fontSmall(),
                    textColor: AppColors.colorError,
                  ),
                ],
                AppDimens.vm4,
                Row(
                  children: [
                    _buildBtnConfirm(isConfirm: false),
                    AppDimens.hm12,
                    _buildBtnConfirm(
                      onConfirm: controller.checkPassword,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBtnConfirm({
    VoidCallback? onConfirm,
    bool isConfirm = true,
  }) {
    return Expanded(
      child: UtilWidget.buildSolidButton(
          height: AppDimens.btnDefaultFigma,
          title: isConfirm
              ? LocaleKeys.login_continue.tr
              : LocaleKeys.login_cancel.tr,
          onPressed: onConfirm,
          isLoading: controller.isShowLoading.value,
          showShadow: true,
          backgroundColor:
              isConfirm ? AppColors.scaffoldBackground : AppColors.white),
    );
  }

  Widget _buildPassword() {
    return Material(
      borderRadius: BorderRadius.circular(12),
      child: BuildInputText(
        InputTextModel(
          hintText: LocaleKeys.login_passwordHint.tr,
          controller: controller.passwordController,
          iconNextTextInputAction: TextInputAction.done,
          isReadOnly: controller.isShowLoading.value,
          obscureText: true,
          submitFunc: (_) {
            controller.checkPassword;
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
}
