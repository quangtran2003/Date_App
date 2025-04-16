abstract final class ApiUrl {
  //url dùng để get sticker album
  static String stickerAlbumUrl(String id) =>
      "https://api.imgur.com/3/album/$id/images";

  //url dùng để push noti
  static const String urlPushNoti =
      'https://fcm.googleapis.com/v1/projects/easy-date-dev/messages:send';
}
