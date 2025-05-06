import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/const.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as UserChatArgument;

    return args.callID == null
        ? Center(
            child: UtilWidget.buildText(LocaleKeys.notification_callIdNull.tr),
          )
        : ZegoUIKitPrebuiltCall(
            appID: AppId,
            appSign: AppSign,
            userID: args.uid,
            userName: args.name,
            callID: args.callID!,
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
          );
  }
}
