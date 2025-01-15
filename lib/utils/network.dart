import 'package:connectivity_plus/connectivity_plus.dart';

class NoNetworkException implements Exception {
  const NoNetworkException();
}

abstract final class NetworkUtil {
  static Future<void> checkNetwork() async {
    final results = await Connectivity().checkConnectivity();
    final networkAvailable = results.any(
      (result) {
        return result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet;
      },
    );

    if (!networkAvailable) {
      throw const NoNetworkException();
    }
  }
}
