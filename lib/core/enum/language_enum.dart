import 'dart:ui';

import 'package:hive/hive.dart';

part 'language_enum.g.dart';

const viLocale = Locale('vi', 'VN');
const enLocale = Locale('en', 'US');

@HiveType(typeId: 0)
enum LanguageEnum {
  @HiveField(0)
  vietnamese,
  @HiveField(1)
  english;

  Locale get locale {
    switch (this) {
      case LanguageEnum.vietnamese:
        return viLocale;
      case LanguageEnum.english:
        return enLocale;
    }
  }

  static LanguageEnum fromLocale(Locale locale) {
    if (locale == viLocale) {
      return LanguageEnum.vietnamese;
    } else {
      return LanguageEnum.english;
    }
  }
}
