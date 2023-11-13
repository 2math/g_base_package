
class PlatformInterface {

  static Future<bool> checkInternet() => throw UnsupportedError('Check network without dart:html or dart:io');

  static bool get isAndroid => false;
  static bool get isIOS => false;
  static bool get isWindows => false;
  static bool get isMacOS => false;
  static bool get isLinux => false;
}
