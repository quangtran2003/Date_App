class AppStr {
  static const String appName = 'Easy Date';
  static const String close = "Đóng";
  static const String rateUs = 'Đánh giá ứng dụng';
  static const String shareApp = 'Chia sẻ ứng dụng';
  static const String hello = 'Xin chào!';
  static const String exitApp = 'Chạm lần nữa để thoát';
  static const String setting = "Cài đặt";
  static const String home = "Trang chủ";
  static const String supportCus = "Hỗ trợ khách hàng";
  static const String notification = "Thông báo";
  static const String cancel = "Huỷ";
  static const String messageUseNoInternet =
      "Bạn đang không kết nối đến hệ thống Easy Date";
  static const String errorNoticeValidateNum = "Không được để trống";
  static const String inputEmpty = ' không được bỏ trống!';
  static String inputValidateLength({int length = 10}) =>
      ' phải lớn hơn $length ký tự!';

  // view match
  static const String address = "Địa chỉ: ";
  static const String sex = "Giới tính: ";

  //error
  static const String errorConnectTimeOut =
      'Không có phản hồi từ hệ thống, Quý khách vui lòng thử lại sau';
  static const String errorInternalServer =
      'Lỗi xử lý hệ thống\nQuý khách vui lòng thử lại sau!!!';
  static const String error502 =
      'Server đang bảo trì. Quý khách vui lòng quay lại sau.';
  static const String error503 =
      'Server đang bảo trì. Quý khách vui lòng quay lại sau một vài phút.';
  static const String error404 =
      'Không tìm thấy đường dẫn này, xin vui lòng liên hệ Admin';
  static const String error401 =
      'Phiên đăng nhập đã hết hạn. Quý khách vui lòng đăng nhập lại';
  static const String error400 = 'Dữ liệu gửi đi không hợp lệ!';
  static const String errorConnectFailedStr =
      'Không thể kết nối tới máy chủ\nQuý khách vui lòng kiểm tra lại kết nối mạng';
}
