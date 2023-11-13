import 'package:flutter/foundation.dart';

import 'platform_stub.dart'
if (dart.library.io) 'platform_app.dart'
if (dart.library.html) 'platform_web.dart';

class Platform {
  static Future<bool> checkInternet() => PlatformInterface.checkInternet();

  static bool get isAndroid => PlatformInterface.isAndroid;

  static bool get isIOS => PlatformInterface.isAndroid;
  static bool get isWindows => PlatformInterface.isWindows;
  static bool get isMacOS => PlatformInterface.isMacOS;
  static bool get isLinux => PlatformInterface.isLinux;

  static bool get isWeb => kIsWeb;
}