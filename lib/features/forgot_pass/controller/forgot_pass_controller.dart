import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/forgot_pass/repository/forgot_pass_repository.dart';
import 'package:easy_date/features/register/model/register_success_result.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/show_popup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPassController extends BaseGetxController {
  final ForgotPassRepository forgotPassRepository;
  final formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final emailTextCtrl = TextEditingController();

  @override
  void onClose() {
    emailTextCtrl.dispose();
    emailFocusNode.dispose();
    super.onClose();
  }

  ForgotPassController({
    required this.forgotPassRepository,
  });

  Future<void> forgotPass() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailTextCtrl.text.trim();

    try {
      showLoading();
      await forgotPassRepository.forgotPass(email: email);
      ShowPopup.showDialogNotification(
        LocaleKeys.login_forgotPassSuccess.tr,
        function: () {
          Get.back(result: RegisterSuccessResult(email, ''));
        },
      );
    } catch (e) {
      handleException(e);
    } finally {
      hideLoading();
    }
  }
}
