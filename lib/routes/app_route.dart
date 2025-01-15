enum AppRoute {
  splash,
  login,
  register,
  home,
  chat,
  sticker,
  match,
  userList,
  profile_detail,
  pair,
  profile_match;

  String get path {
    return '/$name';
  }
}
