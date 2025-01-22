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
  forgot_pass,
  profile_match;

  String get path {
    return '/$name';
  }
}
