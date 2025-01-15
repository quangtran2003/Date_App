import 'package:easy_date/generated/locales.g.dart';
import 'package:get/get.dart';

enum SexEnum {
  /// Nữ
  feMale(0),

  /// Nam
  male(1),

  /// Tất cả
  all(2);

  final int value;
  const SexEnum(this.value);

  String get label {
    return switch (this) {
      SexEnum.feMale => LocaleKeys.profileDetail_female.tr,
      SexEnum.male => LocaleKeys.profileDetail_male.tr,
      SexEnum.all => LocaleKeys.profileDetail_all.tr,
    };
  }

  static SexEnum? fromValue(int? value) {
    if (value == null) return null;
    return SexEnum.values.firstWhereOrNull((element) => element.value == value);
  }
}
