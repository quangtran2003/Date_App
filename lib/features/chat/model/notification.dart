class PushNotificationModel {
  final String token;
  final NotificationContent notification;
  final Data data;

  PushNotificationModel({
    required this.token,
    required this.notification,
    required this.data,
  });

  factory PushNotificationModel.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? {};

    return PushNotificationModel(
      token: message['token'],
      notification: NotificationContent.fromJson(message['notification']),
      data: Data.fromJson(message['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': {
        'token': token,
        'notification': notification.toJson(),
        'data': data.toJson(),
      }
    };
  }
}

class NotificationContent {
  final String title;
  final String body;

  NotificationContent({
    required this.title,
    required this.body,
  });

  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    return NotificationContent(
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
    };
  }
}

class Data {
  final String? pageName;
  final String? content;
  final String? uidUser;
  final String? nameUser;
  final String? imgUser;

  Data({
    this.content,
    this.pageName,
    this.uidUser,
    this.nameUser,
    this.imgUser,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      content: json['content'],
      pageName: json['pageName'],
      uidUser: json['uidUser'],
      nameUser: json['nameUser'],
      imgUser: json['imgUser'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'pageName': pageName,
      'uidUser': uidUser,
      'nameUser': nameUser,
      'imgUser': imgUser,
    };
  }
}
