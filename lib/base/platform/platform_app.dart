import 'dart:io';

import 'package:g_base_package/base/utils/network.dart';


class PlatformInterface {
  static Future<bool> checkInternet() async {
    return NetUtil().checkInternet();
  }

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get isWindows => Platform.isWindows;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isLinux => Platform.isLinux;
}
