
import 'package:easy_date/assets.dart';

enum Biometric { faceId, fingerprint, none }

extension BiometricExt on Biometric {
  String get title {
    switch (this) {
      case Biometric.faceId:
        return 'Bảo mật khuôn mặt';
      case Biometric.fingerprint:
        return 'Bảo mật vân tay';
      case Biometric.none:
        return 'Không hỗ trợ snh trắc học';
    }
  }

  String get iconSvg {
    switch (this) {
      case Biometric.faceId:
        return Assets.ASSETS_ICONS_IC_BIOMETRIC_SVG;
      case Biometric.fingerprint:
        return Assets.ASSETS_ICONS_IC_FINGERPRINT_SVG;
      case Biometric.none:
        return Assets.ASSETS_ICONS_IC_FINGERPRINT_SVG;
    }
  }
}
