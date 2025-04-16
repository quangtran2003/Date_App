import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/login/login_src.dart';
import 'package:easy_date/features/register/model/register_success_result.dart';
import 'package:easy_date/routes/routers_src.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../../../generated/locales.g.dart';
import '../../../utils/show_snackbar.dart';

class LoginController extends BaseGetxController {
  final LoginRepository loginRepository;

  final formKey = GlobalKey<FormState>();
  final LocalAuthentication auth = LocalAuthentication();
  final emailTextCtrl = TextEditingController();
  final passwordTextCtrl = TextEditingController();
  final passwordBiometricCtrl = TextEditingController();

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  LoginController({
    required this.loginRepository,
  });

  Future<void> goToRegisterPage() async {
    final result = await Get.toNamed(AppRouteEnum.register.path);
    if (result != null && result is RegisterSuccessResult) {
      emailTextCtrl.text = result.email;
      passwordTextCtrl.text = result.password;
    }
  }

  Future<void> biometricAuth({required Function func}) async {
    try {
      bool didAuthenticate = await auth.authenticate(
        localizedReason: LocaleKeys.biometric_confirm.tr,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        await func();
      } else {
        showMessage(LocaleKeys.biometric_confirmFail.tr);
      }
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Error: ${e.message}");
        showMessage(LocaleKeys.biometric_confirmFail.tr + e.toString());
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
        showMessage(LocaleKeys.biometric_confirmFail.tr + e.toString());
      }
    }
  }

  Future<void> goToForgotPassPage() async {
    final result = await Get.toNamed(AppRouteEnum.forgot_pass.path);
    if (result != null && result is RegisterSuccessResult) {
      emailTextCtrl.text = result.email;
      passwordTextCtrl.clear();
    }
  }

  @override
  void onReady() {
    super.onReady();
    _getEmailAndPassword();
  }

  Future<void> _getEmailAndPassword() async {
    final result =
        await Future.wait([SecureStorage.email, SecureStorage.password]);
    final email = result[0];
    final password = result[1];

    if (email != null) {
      emailTextCtrl.text = email;
    }

    if (password != null) {
      passwordTextCtrl.text = password;
    }
  }

  Future<void> _saveEmailAndPassword() async {
    final email = emailTextCtrl.text.trim();
    final password = passwordTextCtrl.text;

    await Future.wait([
      SecureStorage.saveEmail(email),
      SecureStorage.savePassword(password),
    ]);
  }

  @override
  void onClose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    emailTextCtrl.dispose();
    passwordTextCtrl.dispose();
    super.onClose();
  }

  Future<void> login({isBiometric = false}) async {
    final email = emailTextCtrl.text.trim();
    final password =
        isBiometric ? passwordBiometricCtrl.text : passwordTextCtrl.text;
    if (isBiometric) {
      passwordTextCtrl.text = passwordBiometricCtrl.text;
    }
    if (!(formKey.currentState?.validate() ?? false)) return;

    showLoading();

    try {
      await loginRepository.login(
        email: email,
        password: password,
      );
      _saveEmailAndPassword();
      final user = await loginRepository.getUser();
      if (isBiometric) AppStorage.saveBiometric(true);
      if (user.status == StatusEnum.inactive.value) {
        Get.offAllNamed(
          AppRouteEnum.profile_detail.path,
          arguments: {
            "currentUser": user,
          },
        );
        return;
      }
      Get.offAllNamed(AppRouteEnum.home.path);
    } on EmailNotVerifiedException {
      showSnackBar(LocaleKeys.login_pleaseVerifyEmail.tr, isSuccess: false);
    } catch (e) {
      handleException(e);
    } finally {
      hideLoading();
    }
  }
}
