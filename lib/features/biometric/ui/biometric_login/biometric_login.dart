import 'package:easy_date/features/biometric/biometric.src.dart';
import 'package:easy_date/features/feature_src.dart';

class BiometricLogin extends BaseGetWidget<BiometricController> {
  final VoidCallback func;
  const BiometricLogin({required this.func, super.key});

  @override
  BiometricController get controller => Get.put(BiometricController());
  @override
  Widget buildWidgets(BuildContext context) {
    return Obx(
      () {
        return InkWell(
          onTap: () => controller.showPopupBiometricSupport(func: func),
          child: ImageWidgets.imageSvg(
            controller.biometric.value.iconSvg,
            height: AppDimens.sizeIcon28,
            width: AppDimens.sizeIcon28,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
