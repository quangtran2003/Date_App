class BaseResponseList<T> {
  BaseResponseList({
    required this.status,
    required this.message,
    required this.data,
    required this.errorCode,
  });
  final int status;
  final String message;
  final List<T> data;
  final int? errorCode;

  factory BaseResponseList.fromJson(
    Map<String, dynamic> json,
    Function(dynamic x) func,
  ) {
    return BaseResponseList(
      message: json["message"] ?? "",
      status: json["status"] ?? 0,
      data: json["data"] != null
          ? List<T>.from(json["data"].map((x) => func(x)))
          : [],
      errorCode: json["errorCode"] ?? 0,
    );
  }

  Map<String, dynamic> toJson(Function(dynamic x) func) => {
        "message": message,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => func)),
        "errorCode": errorCode,
      };
}
