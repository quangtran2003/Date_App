abstract final class ApiUrl {
  // static const loginUrl = "";

  static String stickerAlbumUrl(String id) =>
      "https://api.imgur.com/3/album/$id/images";
}
