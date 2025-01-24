import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/register/repository/repository_src.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/show_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/register_success_result.dart';

class RegisterController extends BaseGetxController {
  final RegisterRepository registerRepository;
  final formKey = GlobalKey<FormState>();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  final emailTextCtrl = TextEditingController();
  final passwordTextCtrl = TextEditingController();
  final confirmPasswordTextCtrl = TextEditingController();

  @override
  void onClose() {
    confirmPasswordTextCtrl.dispose();
    emailTextCtrl.dispose();
    passwordTextCtrl.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }

  RegisterController({
    required this.registerRepository,
  });

  Future<void> register() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailTextCtrl.text.trim();
    final password = passwordTextCtrl.text;

    try {
      showLoading();
      await registerRepository.register(email: email, password: password);
      ShowPopup.showDialogNotification(
        LocaleKeys.login_registerSuccess.tr,
        function: () {
          final data = RegisterSuccessResult(email, password);
          Get.back(result: data);
        },
      );
    } catch (e) {
      handleException(e);
    } finally {
      hideLoading();
    }
  }
}
