class BaseResponse<T> {
  BaseResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.errorCode,
  });

  int status;
  String message;
  T? data;
  int? errorCode;

  factory BaseResponse.fromJson(
    Map<String, dynamic> json, {
    Function(Map<String, dynamic> x)? func,
  }) {
    T? convertObject() => func != null ? func(json["data"]) : json["data"];
    return BaseResponse(
      status: json["status"] ?? 0,
      message: json["message"] ?? "",
      data: json["data"] != null ? convertObject() : null,
      errorCode: json['errorCode'],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
        "errorCode": errorCode,
      };
}
