import '../../../const/const_src.dart';

class BaseRequestListModel {
  BaseRequestListModel({
    required this.key,
    required this.page,
    this.pagesize = AppConst.pageSize,
  });

  String key;
  int page;
  int pagesize = AppConst.pageSize;

  factory BaseRequestListModel.fromJson(Map<String, dynamic> json) =>
      BaseRequestListModel(
        key: json["key"],
        page: json["page"],
        pagesize: json["pagesize"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "page": page,
        "pagesize": pagesize,
      };
}
