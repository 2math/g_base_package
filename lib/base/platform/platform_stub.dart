import 'package:g_base_package/base/net/call.dart';
import 'package:http/http.dart' as http;

class PlatformInterface {

  static Future<bool> checkInternet() => throw UnsupportedError('Check network without dart:html or dart:io');

  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isWindows => false;
  static bool get isMacOS => false;
  static bool get isLinux => false;

  static Future<http.Response> doUploadFileMultipart(String url, Call call) => throw UnsupportedError('Multipart on '
      'dart:io only, not supported for html');
}
