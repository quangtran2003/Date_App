import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/video_call/model/call_info.dart';

abstract class VideoCallRepository extends BaseFirebaseRepository {
  Future<void> startCall({
    required String callerId,
    required String receiverId,
    required String callId,
  });

  Future<void> acceptCall(String callerId);

  Stream<CallInfo?> getCallStream(String callerId);
}
