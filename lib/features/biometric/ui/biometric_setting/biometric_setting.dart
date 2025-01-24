import 'package:easy_date/features/feature_src.dart';
import 'package:flutter/cupertino.dart';

import '../../biometric.src.dart';

part 'biometric_setting_widget.dart';

class BiometricSetting extends BaseGetWidget<BiometricController> {
  const BiometricSetting({super.key});

  @override
  BiometricController get controller => Get.put(BiometricController());

  @override
  Widget buildWidgets(BuildContext context) {
    return Obx(() => _buildBiometricSetting());
  }
}
