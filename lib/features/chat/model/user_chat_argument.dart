import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class UserChatArgument {
  final String idReceiver;
  final String nameReceiver;
  final String imgAvtReceiver;
  final Timestamp? lastOnline;
  final RxBool isOnline = false.obs;

  UserChatArgument({
    required this.idReceiver,
    required this.nameReceiver,
    required this.imgAvtReceiver,
    this.lastOnline,
  });
}
