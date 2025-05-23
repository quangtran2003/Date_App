import 'dart:io';

import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/generated/locales.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../biometric.src.dart';
import '../enums/support_state_enum.dart';

class BiometricController extends BaseGetxController {
  final Rx<SupportState> supportState = Rx(SupportState.unknown);
  final Rxn<List<BiometricType>> availableBiometrics = Rxn();
  var passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final Rx<Biometric> biometric = Rx(Biometric.fingerprint);
  final RxBool hasBiometric = (AppStorage.getBiometric ?? false).obs;
  final RxBool isHidePass = true.obs;

  @override
  void onInit() async {
    await checkBiometricSupport();
    if (supportState.value == SupportState.supported) {
      await checkBiometric();
    }
    super.onInit();
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> checkBiometric() async {
    try {
      List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (Platform.isIOS) {
        if (availableBiometrics.contains(BiometricType.face)) {
          biometric.value = Biometric.faceId;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          biometric.value = Biometric.fingerprint;
        } else {
          biometric.value = Biometric.none;
        }
      } else if (Platform.isAndroid) {
        if (availableBiometrics.contains(BiometricType.strong)) {
          biometric.value = Biometric.fingerprint;
        } else if (availableBiometrics.contains(BiometricType.weak)) {
          biometric.value = Biometric.faceId;
        } else {
          biometric.value = Biometric.none;
        }
      } else {
        biometric.value = Biometric.fingerprint;
      }
    } on PlatformException {
      biometric.value = Biometric.none;
    }
  }

  Future<void> authCheck(Function() func) async {
    showPopupBiometricSupport(
      func: () => startBioMetricAuth(
        LocaleKeys.biometric_confirm.tr,
        func,
      ),
    );
  }

  Future<void> checkBiometricSupport() async {
    try {
      bool isSupported = await auth.isDeviceSupported();
      bool canCheckBiometrics = await auth.canCheckBiometrics;

      if (isSupported) {
        if (canCheckBiometrics) {
          supportState.value = SupportState.supported;
        } else {
          supportState.value = SupportState.notSetUp;
        }
      } else {
        supportState.value = SupportState.unsupported;
      }
    } on PlatformException {
      supportState.value = SupportState.unknown;
    }
  }

  Future<void> startBioMetricAuth(String message, Function() func) async {
    try {
      //xac thực sinh trắc học ở đây
      bool didAuthenticate = await auth.authenticate(
        localizedReason: message,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (didAuthenticate) {
        func.call();
      } else {
        showMessage(
          LocaleKeys.biometric_confirmFail.tr,
          isSuccess: true,
        );
      }
    } on PlatformException {
      if (kDebugMode) {
        showMessage(LocaleKeys.biometric_confirmSuccess.tr);
      }
    }
  }

  Future<void> checkPassword() async {
    final password = await SecureStorage.password;

    if (password == passwordController.text.trim()) {
      hasBiometric.toggle();
      AppStorage.saveBiometric(hasBiometric.value);
      showMessage(
        LocaleKeys.biometric_changeConfigSuccess.tr,
        isSuccess: true,
      );
    } else {
      showMessage(LocaleKeys.login_confirmPasswordWrong.tr);
    }
    passwordController.clear();
  }

  void showPopupBiometricSupport({required VoidCallback func}) {
    switch (supportState.value) {
      case SupportState.supported:
        return func();
      case SupportState.notSetUp:
        showMessage(LocaleKeys.biometric_confirmFail.tr);
        break;
      case SupportState.unsupported:
        showMessage(LocaleKeys.biometric_biometricsNotSupported.tr);
        break;
      default:
        showMessage(LocaleKeys.biometric_confirmFail.tr);
        break;
    }
  }
}
