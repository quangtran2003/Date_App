import 'package:easy_date/features/feature_src.dart';

enum MessageTypeEnum {
  text,
  sticker,
  audioCall,
  videoCall;

  static MessageTypeEnum fromInt(int type) {
    switch (type) {
      case 0:
        return MessageTypeEnum.text;
      case 1:
        return MessageTypeEnum.sticker;
      case 2:
        return MessageTypeEnum.audioCall;
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
      case audioCall:
      case videoCall:
        return AppRouteEnum.video_call.path;
    }
  }

  int get value {
    switch (this) {
      case text:
        return 0;
      case sticker:
        return 1;
      case audioCall:
        return 2;
      case videoCall:
        return 3;
    }
  }

  static bool isTypeCall(String? type) {
    MessageTypeEnum messageTypeEnum =
        MessageTypeEnum.fromInt(int.tryParse(type ?? '0') ?? 0);
    switch (messageTypeEnum) {
      case text:
      case sticker:
        return false;
      case audioCall:
      case videoCall:
        return true;
    }
  }
}
