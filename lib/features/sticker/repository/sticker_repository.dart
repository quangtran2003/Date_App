import 'package:easy_date/features/sticker/sticker_src.dart';

import '../../../core/core_src.dart';

abstract class StickerRepository extends BaseRepository {
  Future<AlbumSticker> getAlbumSticker({required String id});
}
