import 'package:easy_date/features/feature_src.dart';

enum MatchEnum {
  /// Gửi yêu cầu ghép đôi.
  request(0),
  /// Ghép đôi thành công.
  accept(1),
  /// Chờ phản hồi.
  waiting(2),
  /// Bỏ qua.
  skip(3),
  /// Chặn.
  block(4),
  /// Bị chặn.
  blocked(5);

  final int value;
  const MatchEnum(this.value);

  String get title {
    return switch (this) {
      MatchEnum.request => LocaleKeys.user_waitingList.tr,
      MatchEnum.accept => LocaleKeys.user_acceptList.tr,
      MatchEnum.block => LocaleKeys.user_blockList.tr,
      MatchEnum.waiting => LocaleKeys.home_likedYou.tr,
      _ => '',
    };
  }
}
