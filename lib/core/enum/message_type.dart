import 'package:easy_date/features/feature_src.dart';

enum MessageTypeEnum {
  text,
  sticker,
  call,
  videoCall;

  static MessageTypeEnum fromInt(int type) {
    switch (type) {
      case 0:
        return MessageTypeEnum.text;
      case 1:
        return MessageTypeEnum.sticker;
      case 2:
        return MessageTypeEnum.call;
      case 3:
        return MessageTypeEnum.videoCall;
      default:
        return MessageTypeEnum.text;
    }
  }

  String get getPageName {
    switch (this) {
      case text:
      case sticker:
        return AppRouteEnum.chat.path;
      case call:
      case videoCall:
        return AppRouteEnum.home.path;
    }
  }

  int get firebaseValue {
    switch (this) {
      case text:
        return 0;
      case sticker:
        return 1;
      case call:
        return 2;
      case videoCall:
        return 3;
    }
  }
}
