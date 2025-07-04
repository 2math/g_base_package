import 'package:flutter/foundation.dart';
import 'package:g_base_package/base/net/call.dart';
import 'package:http/http.dart' as http;

import 'platform_stub.dart'
    if (dart.library.io) 'platform_app.dart'
    if (dart.library.html) 'platform_web.dart';

class Platform {
  static Future<bool> checkInternet() => PlatformInterface.checkInternet();

  static bool get isAndroid => PlatformInterface.isAndroid;

  static bool get isIOS => PlatformInterface.isIOS;

  static bool get isWindows => PlatformInterface.isWindows;

  static bool get isMacOS => PlatformInterface.isMacOS;

  static bool get isLinux => PlatformInterface.isLinux;

  static bool get isWeb => kIsWeb;

  static Future<http.Response> doUploadFileMultipart(String url, Call call) =>
      PlatformInterface.doUploadFileMultipart(url, call);
}
