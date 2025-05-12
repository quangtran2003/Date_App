import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/const.dart';
import 'package:easy_date/features/video_call/controller/video_call_controller.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends BaseGetWidget<VideoCallController> {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget buildWidgets(BuildContext context) {
    final args = controller.args;
    return args.callID.isNullOrEmpty
        ? Scaffold(
            body: Center(
              child: UtilWidget.buildText(LocaleKeys.call_callIdNull.tr),
            ),
          )
        : ZegoUIKitPrebuiltCall(
          appID: AppId,
          appSign: AppSign,
          userID: args.idCurrentUser,
          userName: args.nameCurrentUser,
          callID: args.callID!,
          onDispose: () => FirebaseFirestore.instance
              .collection(FirebaseCollection.calls)
              .doc(args.callID!)
              .delete(),
          config: args.typeCall == MessageTypeEnum.audioCall
              ? ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
              : ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
        );
  }
}
