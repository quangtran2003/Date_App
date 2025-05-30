import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/model/call_args.dart';
import 'package:easy_date/features/video_call/model/call_info.dart';
import 'package:easy_date/features/video_call/repository/video_call_repository.dart';

class VideoCallController extends BaseGetxController {
  final VideoCallRepository videoCallRepository;
  VideoCallController(this.videoCallRepository);
  final Rxn<CallInfo> callInfo = Rxn<CallInfo>();

  final args = Get.arguments != null
      ? Get.arguments as CallArgs
      : Get.isRegistered<CallArgs>()
          ? Get.find<CallArgs>()
          : null;

  @override
  Future<void> onInit() async {
    super.onInit();
    if (args?.callID == null) return;
    args?.statusCall == StatusCallEnum.init ? initCall() : acceptCall();
    callInfo.bindStream(
      videoCallRepository.getCallStream(args!.callID!),
    );
    ever(callInfo, (CallInfo? info) {
      if (info != null &&
          info.status == StatusCallEnum.rejected.value &&
          info.callerId == videoCallRepository.firebaseAuth.currentUser?.uid) {
        Get.back();
        showSnackBar(
          LocaleKeys.call_callDecline.tr,
          isSuccess: false,
        );
      }
    });
  }

  Future<void> initCall() async {
    await videoCallRepository.startCall(
      callId: args?.callID ?? '',
      callerId: args?.idCurrentUser ?? '',
      receiverId: args?.idOtherUser ?? '',
    );
    await checkDeclinedCall();
  }

  Future<void> acceptCall() async {
    await videoCallRepository.acceptCall(args?.callID ?? '');
    checkDeclinedCall(secondDelay: 5);
  }

  Future<void> checkDeclinedCall({int secondDelay = 30}) async {
    // Đợi 30 giây, sau đó kiểm tra trạng thái
    Future.delayed(
      Duration(seconds: secondDelay),
      () async {
        final doc = await videoCallRepository.firestore
            .collection(FirebaseCollection.calls)
            .doc(args?.callID ?? '')
            .get();

        if (doc.exists &&
            doc.data()?['status'] == StatusCallEnum.init.value &&
            videoCallRepository.firebaseAuth.currentUser?.uid !=
                args?.idOtherUser) {
          showSnackBar(
            LocaleKeys.call_callCancel.tr,
            isSuccess: false,
          );
          if (Get.currentRoute == AppRouteEnum.video_call.path) Get.back();
        }
      },
    );
  }

  Future<void> handleCallEnd() async {
    try {
      // Xóa dữ liệu cuộc gọi
      await videoCallRepository.firestore
          .collection(FirebaseCollection.calls)
          .doc(args?.callID ?? '')
          .delete();

      // Đóng màn hình call và điều hướng về màn hình chính
      if (args?.isFromTerminatedState == true) {
        await Get.offAllNamed(AppRouteEnum.home.path);
      } else {
        if (Get.currentRoute == AppRouteEnum.video_call.path) Get.back();
      }
    } catch (e) {
      logger.e('Error handling call end: $e');
    }
  }
}
