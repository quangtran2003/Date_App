import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/const.dart';
import 'package:easy_date/features/video_call/controller/video_call_controller.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends BaseGetWidget<VideoCallController> {
  const CallPage({Key? key}) : super(key: key);

  @override
  Widget buildWidgets(BuildContext context) {
    return controller.args.callID == null
        ? Center(
            child: UtilWidget.buildText(LocaleKeys.notification_callIdNull.tr),
          )
        : Stack(
            children: [
              ZegoUIKitPrebuiltCall(
                appID: AppId,
                appSign: AppSign,
                userID: controller.args.uid,
                userName: controller.args.name,
                callID: controller.args.callID!,
                onDispose: () => FirebaseFirestore.instance
                    .collection(FirebaseCollection.calls)
                    .doc(controller.args.callID!)
                    .delete(),
                config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
              ),
            ],
          );
  }
}