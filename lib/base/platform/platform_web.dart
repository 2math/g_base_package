// ignore: unused_import
import 'dart:html' as html;

class PlatformInterface {

  static Future<bool> checkInternet() async {
    return true;
    // String? type = html.window.navigator.connection?.type;
    // return type != 'none' && type != null;
  }

  static bool get isAndroid => false;
  static bool get isIOS => false;

  static bool get isWindows => false;
  static bool get isMacOS => false;
  static bool get isLinux => false;
}