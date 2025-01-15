import 'package:easy_date/features/feature_src.dart';

class AlbumStickerStorage {
  static const _boxName = 'album_sticker';

  static late final Box _box;

  static Future<void> init() async {
    Hive.registerAdapter(StickerAdapter());
    Hive.registerAdapter(AlbumStickerAdapter());
    _box = await Hive.openBox(_boxName);
  }

  static Stream<List<AlbumSticker>> get albumsStream {
    return _box.watch().map((event) {
      return _box.values.map((e) => e as AlbumSticker).toList();
    });
  }

  static Future<void> saveAlbum({
    required String id,
    required AlbumSticker album,
  }) async {
    return _box.put(id, album);
  }

  static List<AlbumSticker> get albums {
    final album = _box.values.map((e) => e as AlbumSticker).toList();
    return album;
  }

  static AlbumSticker getAlbum(String id) {
    return _box.get(id);
  }

  static bool isAlbumExist(String id) {
    return _box.containsKey(id);
  }

  static Future<void> deleteAlbum(String id) async {
    return _box.delete(id);
  }

  static Future<void> deleteAll() async {
    await _box.clear();
  }
}
