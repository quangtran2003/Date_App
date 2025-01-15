import '../base_src.dart';

import '../../../utils/utils_src.dart';

class BaseRepository {
  final BaseConnectAPI _baseRequest = Get.find<BaseConnectAPI>();

  /// [isQueryParametersPost]: `true`: phương thức post gửi params, mặc định = `false`
  ///
  /// [dioOptions]: option của Dio() sử dụng khi gọi api có option riêng
  ///
  /// [functionError]: chạy function riêng khi request xảy ra Exception (mặc định sử dụng [showDialogError])
  Future<dynamic> baseSendRequest(
    String action,
    RequestMethod requestMethod, {
    dynamic jsonMap,
    bool isDownload = false,
    String? urlOther,
    Map<String, String>? headersUrlOther,
    bool isQueryParametersPost = false,
    CancelToken? cancelToken,
    BaseOptions? dioOptions,
    Function(Object error)? functionError,
  }) {
    return _baseRequest.sendRequest(
      action,
      requestMethod,
      jsonMap: jsonMap,
      isDownload: isDownload,
      urlOther: urlOther,
      headersUrlOther: headersUrlOther,
      isQueryParametersPost: isQueryParametersPost,
      cancelToken: cancelToken,
      dioOptions: dioOptions,
      functionError: functionError,
    );
  }

  Future<void> checkNetwork() async {
    return NetworkUtil.checkNetwork();
  }
}
