import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/forgot_pass/repository/forgot_pass_repository.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:easy_date/utils/show_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/register_success_result.dart';

class ForgotPassController extends BaseGetxController {
  final ForgotPassRepository forgotPassRepository;
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

  ForgotPassController({
    required this.forgotPassRepository,
  });

  Future<void> forgotPass() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    final email = emailTextCtrl.text.trim();
    final password = passwordTextCtrl.text;

    try {
      showLoading();
      await forgotPassRepository.forgotPass(email: email, password: password);
      ShowPopup.showDialogNotification(LocaleKeys.login_registerSuccess.tr,
          function: () {
        final data = RegisterSuccessResult(email, password);
        Get.back(result: data);
      });
      
    }
    on FirebaseAuthException catch (e) {
 if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
     catch (e) {
      e.code == 'email-already-in-use'?
      handleException(e);
    } finally {
      hideLoading();
    }
  }
}
