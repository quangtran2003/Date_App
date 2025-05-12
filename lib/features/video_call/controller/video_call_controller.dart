import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/model/call_args.dart';
import 'package:easy_date/features/video_call/model/call_info.dart';
import 'package:easy_date/features/video_call/repository/video_call_repository.dart';

class VideoCallController extends BaseGetxController {
  final VideoCallRepository videoCallRepository;
  VideoCallController(this.videoCallRepository);
  ChatController? get chatCtrl =>
      Get.isRegistered<ChatController>() ? Get.find<ChatController>() : null;

  final Rxn<CallInfo> callInfo = Rxn<CallInfo>();
  final args = Get.arguments as CallArgs;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (args.callID == null) return;
    args.statusCall == StatusCallEnum.init ? initCall() : acceptCall();
    callInfo.bindStream(
      videoCallRepository.getCallStream(args.callID!),
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

  Future<void> initCall() async {
    await videoCallRepository.startCall(
      callId: args.callID ?? '',
      callerId: args.idCurrentUser,
      receiverId: args.idOtherUser ?? '',
    );
    await checkDeclinedCall();
  }

  Future<void> acceptCall() async {
    await videoCallRepository.acceptCall(args.callID ?? '');
    checkDeclinedCall(secondDelay: 5);
  }

  Future<void> checkDeclinedCall({int secondDelay = 10}) async {
    // Đợi 10 giây, sau đó kiểm tra trạng thái
    Future.delayed(
      Duration(seconds: secondDelay),
      () async {
        final doc = await videoCallRepository.firestore
            .collection(FirebaseCollection.calls)
            .doc(args.callID ?? '')
            .get();

        if (doc.exists &&
            doc.data()?['status'] == StatusCallEnum.init.value &&
            videoCallRepository.firebaseAuth.currentUser?.uid !=
                args.idOtherUser) {
          showSnackBar(
            'Người nhận không nhấc máy!',
            isSuccess: false,
          );
          Get.back();
        }
      },
    );
  }
}
