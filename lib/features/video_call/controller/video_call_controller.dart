import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/model/call_info.dart';
import 'package:easy_date/features/video_call/repository/video_call_repository.dart';

class VideoCallController extends BaseGetxController {
  final VideoCallRepository chatRepository;
  VideoCallController(this.chatRepository);
  ChatController? get chatCtrl =>
      Get.isRegistered<ChatController>() ? Get.find<ChatController>() : null;

  final Rxn<CallInfo> callInfo = Rxn<CallInfo>();
  final args = Get.arguments as UserChatArgument;

  @override
  Future<void> onInit() async {
    super.onInit();
    await chatRepository.startCall(
      callId: args.callID ?? '',
      callerId: chatRepository.firebaseAuth.currentUser?.uid ?? '',
      receiverId: args.uid,
    );
    callInfo.bindStream(
      chatRepository.getCallStream(args.callID ?? ''),
    );
    ever(callInfo, (CallInfo? info) {
      if (info != null && info.status == StatusCallEnum.rejected.value) {
        Get.back();
        showSnackBar(
          "Cuộc gọi bị từ chối!",
          isSuccess: false,
        );
      }
    });
  }
}
