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
  final String? uidUser;
  final String? nameUser;
  final String? imgUser;
  final String? pageName;
  final String? callId;
  final String? type;

  PushNotificationData(
      {this.notifTitle,
      this.notifBody,
      this.uidUser,
      this.nameUser,
      this.imgUser,
      this.pageName,
      this.type,
      this.callId});

  factory PushNotificationData.fromJson(Map<String, dynamic> json) {
    return PushNotificationData(
      notifTitle: json['notif_title'] as String?,
      notifBody: json['notif_body'] as String?,
      uidUser: json['uidUser'] as String?,
      nameUser: json['nameUser'] as String?,
      imgUser: json['imgUser'] as String?,
      pageName: json['pageName'] as String?,
      type: json['type'] as String?,
      callId: json['callId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notif_title': notifTitle ?? '',
      'notif_body': notifBody ?? '',
      'uidUser': uidUser ?? '',
      'nameUser': nameUser ?? '',
      'imgUser': imgUser ?? '',
      'pageName': pageName ?? '',
      'type': type ?? '',
      'callId': callId ?? ''
    };
  }
}
