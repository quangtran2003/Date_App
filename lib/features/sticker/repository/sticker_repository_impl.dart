import 'package:easy_date/core/core_src.dart';

import '../sticker_src.dart';

const clientId = "66850c248e91c93";

class StickerRepositoryImpl extends StickerRepository {
  @override
  Future<AlbumSticker> getAlbumSticker({required String id}) async {
    await checkNetwork();

    final response = await baseSendRequest(
      "",
      RequestMethod.GET,
      urlOther: ApiUrl.stickerAlbumUrl(id),
      headersUrlOther: {
        "authorization": "Client-ID $clientId",
      },
    );

    return AlbumSticker(
      id: id,
      stickers:
          List<Sticker>.from(response["data"].map((x) => Sticker.fromJson(x))),
    );
  }
}
