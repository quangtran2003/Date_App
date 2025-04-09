class NotificationModel {
  final String token;
  final NotificationContent? notification;
  final Map<String, dynamic>? data;

  NotificationModel({
    required this.token,
    this.notification,
    this.data,
  });

  // Convert từ JSON thành object
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      token: json['token'],
      notification: json['notification'] != null
          ? NotificationContent.fromJson(json['notification'])
          : null,
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
    );
  }

  // Convert object thành JSON
  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "notification": notification?.toJson(),
      "data": data,
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

  // Convert từ JSON thành object
  factory NotificationContent.fromJson(Map<String, dynamic> json) {
    return NotificationContent(
      title: json['title'],
      body: json['body'],
    );
  }

  // Convert object thành JSON
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "body": body,
    };
  }
}
