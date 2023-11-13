import 'dart:io';

class PlatformInterface {
  static Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');

      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get isWindows => Platform.isWindows;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isLinux => Platform.isLinux;
}
