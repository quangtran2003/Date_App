import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_date/core/core_src.dart';
import 'package:easy_date/features/video_call/model/call_info.dart';
import 'package:easy_date/features/video_call/repository/video_call_repository.dart';

class VideoCallRepositoryImpl extends VideoCallRepository {
  @override
  Future<void> startCall({
    required String callerId,
    required String receiverId,
    required String callId,
  }) async {
    final callRequest = CallInfo(
      callerId: callerId,
      callId: callId,
      receiverId: receiverId,
      createTime: Timestamp.now(),
      status: StatusCallEnum.init.value,
    );
    await firestore
        .collection(FirebaseCollection.calls)
        .doc(callId)
        .set(callRequest.toJson());
  }

  @override
  Stream<CallInfo?> getCallStream(String callerId) {
    final docRef = firestore.collection(FirebaseCollection.calls).doc(callerId);

    return docRef.snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return (null);
      }
      return CallInfo.fromJson(data);
    });
  }

  @override
  Future<void> acceptCall(String callerId) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollection.calls)
        .doc(callerId)
        .update({
      'status': StatusCallEnum.accepted.value,
    });
  }
}
