class AppConst {
  //app
  static const String appName = "Easy Date";
  static const String appStoreId = "6469520457";
  static const String playStoreName = "vn.lochv.hrm";

  //base
  static const int pageSize = 10;
  static const int defaultPage = 1;
  static const Duration requestTimeOut =
      Duration(seconds: 15); //ms  ///giá trị mặc định phần nghìn
  static const bool isDot = false;

  static const int millisecondsDefault = 1000;
  static const int limitPhone = 10;
  static const int responseSuccess = 2;
  static const int codeSuccess = 200;
  static const int statusSuccess = 0;
  static const int currencyUtilsMaxLength = 12;

  //login
  static const int codeBlocked = 400;
  static const int codeAccountNotExist = 401;
  static const int codePasswordNotCorrect = 402;

  //error
  static const int error500 = 500;
  static const int error404 = 404;
  static const int error401 = 401;
  static const int error400 = 400;
  static const int error502 = 502;
  static const int error503 = 503;

  static const String invoiceSeparator = " | ";
  static const String vnd = "VNĐ";
  static const String millionSort = 'tr';
  static const String billion = 'tỷ';
  static const String moneySpaceStr = ",";
  static const int moneySpacePos = 3;
}
