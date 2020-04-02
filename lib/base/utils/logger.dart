//import 'package:colorize/colorize.dart';

import '../provider/instance_provider.dart';
import 'package:flutter/foundation.dart' as Foundation;

class Log {
  ///This tags will be set allays in logs as prefix for easy sorting only app
  ///logs
  ///https://plugins.jetbrains.com/plugin/7125-grep-console
  static const String appTag = 'AppLog';
  static const String tagDebug = 'DEBUG'; //''👍';
  static const String tagWarning = 'WARN'; //'🤔';
  static const String tagError = 'ERROR'; //'⚡';
  static const String tagInfo = 'INFO'; //'☘';

  ///This must be set from UI on start
  static bool fromUI = false;

  //TODO set live template

  ///This method will print developer's info in logs only if we are in debug
  ///mode
  static d(String log, [String tag]) {
    printInDebugOnly(
        tag != null ? '$tagDebug $appTag $tag' : '$tagDebug $appTag', log);
  }

  ///This method will print developer's warning logs only if we are in debug
  ///mode
  static w(String log, [String tag]) {
    printInDebugOnly(
        tag != null ? '$tagWarning $appTag $tag' : '$tagWarning $appTag', log);
  }

  static void printInDebugOnly(String tag, String log) {
    if (fromUI) {
      InstanceProvider.getInstance()
          .crashReporter
          .log(log, tag); //always save in Crash Reporter
    }
    if (!Foundation.kReleaseMode) {
      _print('$tag : $log');
    }
  }

  static void _print(String textToLog) {
    print(textToLog);
//    Colorize string = new Colorize(textToLog);
//    string.bgGreen();
//    print(string);
  }

  ///Use this method to print in logs your error messages.
  static e(String log, [String tag, Error error]) {
    if (fromUI) {
      InstanceProvider.getInstance()?.crashReporter?.logError(log, tag, error);
    }

    if (!Foundation.kReleaseMode) {
      String systemTag = '$tagError $appTag';
      if (tag != null && error != null) {
        _print('$systemTag $tag : $log \n $error');
      } else if (tag != null) {
        _print('$systemTag $tag : $log');
      } else if (error != null) {
        _print('$systemTag : $log \n $error');
      } else {
        _print('$systemTag : $log');
      }
      return true;
    }
  }

  ///Use this method to print in logs user's information messages.
  static i(String log, [String tag]) {
    printInDebugOnly(
        tag != null ? '$tagInfo $appTag $tag' : '$tagInfo $appTag', log);
  }
}
