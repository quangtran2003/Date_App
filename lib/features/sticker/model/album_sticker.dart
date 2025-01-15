import 'package:easy_date/core/const/api_url.dart';
import 'package:hive/hive.dart';

import 'sticker.dart';

part 'album_sticker.g.dart';

@HiveType(typeId: 2)
class AlbumSticker {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final List<Sticker> stickers;
  @HiveField(2)
  final bool isDefault;

  const AlbumSticker({
    required this.id,
    required this.stickers,
    this.isDefault = false,
  });

  String get url => ApiUrl.stickerAlbumUrl(id);

  AlbumSticker copyWith({
    String? id,
    List<Sticker>? stickers,
    bool? isDefault,
  }) {
    return AlbumSticker(
      id: id ?? this.id,
      stickers: stickers ?? this.stickers,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stickers': stickers.map((x) => x.toJson()).toList(),
      'isDefault': isDefault,
    };
  }
}
