enum MessageType {
  text,
  sticker;

  static MessageType fromInt(int type) {
    switch (type) {
      case 0:
        return MessageType.text;
      case 1:
        return MessageType.sticker;
      default:
        return MessageType.text;
    }
  }

  int get firebaseValue {
    switch (this) {
      case text:
        return 0;
      case sticker:
        return 1;
    }
  }
}
