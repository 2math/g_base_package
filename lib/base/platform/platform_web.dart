import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:g_base_package/base/net/call.dart';
import 'package:http/http.dart' as http;

class PlatformInterface {

  static Future<bool> checkInternet() async {
    return (await Connectivity().checkConnectivity())[0] != ConnectivityResult.none;
    // String? type = html.window.navigator.connection?.type;
    // return type != 'none' && type != null;
  }

  static bool get isAndroid => false;
  static bool get isIOS => false;

  static bool get isWindows => false;
  static bool get isMacOS => false;
  static bool get isLinux => false;

  static Future<http.Response> doUploadFileMultipart(String url, Call call) => throw UnsupportedError('Multipart on '
      'dart:io only, not supported for html');
}