import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/config_noti/fcm.dart';
import 'package:easy_date/core/config_noti/local_notif.dart';
import 'package:easy_date/features/feature_src.dart';
import 'package:easy_date/features/video_call/model/call_args.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase/firebase_options_dev.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final config = AppConfig(
    env: AppEnv.dev,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  );
  await Firebase.initializeApp(options: config.firebaseOptions);
  await LocalNotif.init();
  await FCM.init();

  // Check if app was launched from notification (terminated state)
  String initialRoute = await checkNotifFromTerminate();
  runApp(
    App(
      config: config,
      initialRoute: initialRoute,
    ),
  );
}

Future<String> checkNotifFromTerminate() async {
  // Check if app was launched from notification (terminated state)
  final notificationAppLaunchDetails =
      await LocalNotif.notifPlugin.getNotificationAppLaunchDetails();

  String initialRoute = AppRouteEnum.splash.path;

  // Handle if launched from notification
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final response = notificationAppLaunchDetails!.notificationResponse;
    if (response != null && response.payload != null) {
      final payload = jsonDecode(response.payload!);
      final dataNoti = PushNotificationData.fromJson(payload);

      if (MessageTypeEnum.isTypeCall(dataNoti.type) &&
          dataNoti.callId != null) {
        // If it's a call notification and user accepted
        if (response.actionId == ACCEPT_CALL) {
          await LocalNotif.notifPlugin.cancel(response.id!);
          initialRoute = AppRouteEnum.video_call.path;
          Get.put<CallArgs>(
            CallArgs(
              typeCall: MessageTypeEnum.fromInt(int.parse(dataNoti.type ?? '')),
              idCurrentUser: dataNoti.idReceiver ?? '',
              nameCurrentUser: dataNoti.nameSender ?? '',
              idOtherUser: dataNoti.idSender ?? '',
              callID: dataNoti.callId,
              statusCall: StatusCallEnum.accepted,
              isFromTerminatedState: true,
            ),
          );
        } else if (response.actionId == DECLINE_CALL) {
          await LocalNotif.notifPlugin.cancel(response.id!);
          await FirebaseFirestore.instance
              .collection(FirebaseCollection.calls)
              .doc(dataNoti.callId)
              .update({
            'status': StatusCallEnum.rejected.value,
          });
        }
      }
    }
  }
  return initialRoute;
}
