import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserChatArgument {
  final String uid;
  final String name;
  final String avatar;
  final Timestamp? lastOnline;
  final RxBool isOnline = false.obs;

  UserChatArgument({
    required this.uid,
    required this.name,
    required this.avatar,
    this.lastOnline,
  });
}
