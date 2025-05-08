enum StatusCallEnum {
  init,
  rejected,
  accepted,
  endCall;

  int get value {
    switch (this) {
      case StatusCallEnum.init:
        return 0;
      case StatusCallEnum.rejected:
        return 1;
      case StatusCallEnum.accepted:
        return 2;
      case StatusCallEnum.endCall:
        return 3;
    }
  }
}
