import 'package:easy_date/core/enum/enum_src.dart';
import 'package:easy_date/core/enum/message_type.dart';

class CallArgs {
  final String idCurrentUser;
  final String nameCurrentUser;
  final String? idOtherUser;
  final String? callID;
  final StatusCallEnum statusCall;
  final MessageTypeEnum typeCall;
  final bool isFromTerminatedState;

  CallArgs({
    required this.idCurrentUser,
    required this.nameCurrentUser,
    this.idOtherUser,
    this.callID,
    this.statusCall = StatusCallEnum.init,
    this.typeCall = MessageTypeEnum.audioCall,
    this.isFromTerminatedState = false,
  });
}
