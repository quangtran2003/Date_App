enum AppRoute {
  splash,
  login,
  register,
  home,
  chat,
  sticker,
  match,
  user_list,
  profile_detail,
  pair,
  forgot_pass,
  profile_match;

  String get path {
    return '/$name';
  }
}
