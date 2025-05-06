enum AppRouteEnum {
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
  video_call,
  profile_match;

  String get path {
    return '/$name';
  }
}
