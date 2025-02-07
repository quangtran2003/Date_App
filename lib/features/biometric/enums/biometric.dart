import 'package:easy_date/assets.dart';
import 'package:easy_date/features/feature_src.dart';

enum Biometric { faceId, fingerprint, none }

extension BiometricExt on Biometric {
  String get title {
    switch (this) {
      case Biometric.faceId:
        return LocaleKeys.biometric_faceId.tr;
      case Biometric.fingerprint:
        return LocaleKeys.biometric_finger.tr;
      case Biometric.none:
        return LocaleKeys.biometric_biometricsNotSupported.tr;
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
