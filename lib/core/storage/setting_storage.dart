import 'package:hive/hive.dart';

import '../enum/language_enum.dart';

class SettingStorage {
  static const _boxName = 'settings';
  static const _languageKey = 'language';
  // static const _themeKey = 'theme';

  static late final Box _box;

  static Future<void> init() async {
    Hive.registerAdapter(LanguageEnumAdapter());
    // Hive.registerAdapter(AppThemeAdapter());

    _box = await Hive.openBox(_boxName);
  }

  static Future<void> saveLanguage(LanguageEnum language) async {
    return _box.put(_languageKey, language);
  }

  static LanguageEnum? get language {
    return _box.get(_languageKey);
  }

  // static Future<void> saveThemeMode(AppTheme themeMode) async {
  //   return _box.put(_themeKey, themeMode);
  // }

  // static AppTheme? get themeMode {
  //   return _box.get(_themeKey);
  // }

  static Future<void> deleteAll() async {
    await _box.clear();
  }
}
