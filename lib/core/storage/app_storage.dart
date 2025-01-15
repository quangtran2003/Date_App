import 'package:hive/hive.dart';

abstract final class AppStorage {
  static const _boxName = 'app';
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _lastUsedAlbumStickerIdKey = 'last_used_album_sticker_id';

  static late final Box _box;

  static Future<void> init() async {
    // Hive.registerAdapter(LanguageEnumAdapter());
    _box = await Hive.openBox(_boxName);
  }

  static Future<void> saveAccessToken(String accessToken) async {
    return _box.put(_accessTokenKey, accessToken);
  }

  static String? get accessToken {
    return _box.get(_accessTokenKey);
  }

  static Stream<BoxEvent> get accessTokenStream {
    return _box.watch(key: _accessTokenKey);
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    return _box.put(_refreshTokenKey, refreshToken);
  }

  static String? get refreshToken {
    return _box.get(_refreshTokenKey);
  }

  static Future<void> saveLastUsedAlbumStickerId(String stickerId) async {
    return _box.put(_lastUsedAlbumStickerIdKey, stickerId);
  }

  static String? get lastUsedAlbumStickerId {
    return _box.get(_lastUsedAlbumStickerIdKey);
  }

  static Future<void> deleteAll() async {
    await _box.clear();
  }
}
