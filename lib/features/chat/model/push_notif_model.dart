class PushNotificationMessage {
  final String? token;
  final PushNotificationData? data;

  PushNotificationMessage({
    this.token,
    this.data,
  });

  factory PushNotificationMessage.fromJson(Map<String, dynamic> json) {
    return PushNotificationMessage(
      token: json['token'] as String?,
      data: json['data'] != null
          ? PushNotificationData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": {
        'token': token,
        'data': data?.toJson(),
      },
    };
  }
}

class PushNotificationData {
  final String? notifTitle;
  final String? notifBody;
  final String? idReceiver;
  final String? nameSender;
  final String? imgAvtSender;
  final String? idSender;
  final String? pageName;
  final String? callId;
  final String? type;

  PushNotificationData({
    this.notifTitle,
    this.notifBody,
    this.idReceiver,
    this.nameSender,
    this.imgAvtSender,
    this.pageName,
    this.type,
    this.callId,
    this.idSender,
  });

  factory PushNotificationData.fromJson(Map<String, dynamic> json) {
    return PushNotificationData(
      notifTitle: json['notif_title'] as String?,
      notifBody: json['notif_body'] as String?,
      idReceiver: json['idReceiver'] as String?,
      nameSender: json['nameSender'] as String?,
      imgAvtSender: json['imgAvtSender'] as String?,
      pageName: json['pageName'] as String?,
      type: json['type'] as String?,
      callId: json['callId'] as String?,
      idSender: json['idSender'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notif_title': notifTitle ?? '',
      'notif_body': notifBody ?? '',
      'idReceiver': idReceiver ?? '',
      'nameSender': nameSender ?? '',
      'imgAvtSender': imgAvtSender ?? '',
      'pageName': pageName ?? '',
      'type': type ?? '',
      'callId': callId ?? '',
      'idSender': idSender ?? '',
    };
  }
}
