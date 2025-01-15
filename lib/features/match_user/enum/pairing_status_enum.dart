class PairingStatusEnum {
  // 0 - REQUEST: Gửi yêu cầu ghép đôi
  // 1 - ACCEPT: Ghép đôi thành công
  // 2 - WAITING: Chờ phản hồi
  // 3 - SKIP: Bỏ qua
  // 4 - BLOCK: Chặn
  // 5 - BLOCKED: Bị chặn

  /// 0 - REQUEST: Gửi yêu cầu ghép đôi
  static const int request = 0;

  /// 1 - ACCEPT: Ghép đôi thành công
  static const int accept = 1;

  /// 2 - WAITING: Chờ phản hồi
  static const int waiting = 2;

  /// 3 - SKIP: Bỏ qua
  static const int skip = 3;

  /// 4 - BLOCK: Chặn
  static const int block = 4;

  /// 5 - BLOCKED: Bị chặn
  static const int blocked = 5;
}
