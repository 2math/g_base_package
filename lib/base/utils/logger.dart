//import 'package:colorize/colorize.dart';

import '../provider/instance_provider.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:logger/logger.dart';

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

  static var _logger = Logger(
    printer: PrettyPrinter(
      printTime: false,
      methodCount: 0,
    ),
  );

  //TODO set live template

  ///This method will print developer's info in logs only if we are in debug
  ///mode
  static d(String log, [String tag]) {
    printInDebugOnly(tag != null ? '$tagDebug $appTag $tag' : '$tagDebug $appTag', log, Level.debug);
  }

  ///This method will print developer's warning logs only if we are in debug
  ///mode
  static w(String log, [String tag]) {
    printInDebugOnly(tag != null ? '$tagWarning $appTag $tag' : '$tagWarning $appTag', log, Level.warning);
  }

  static void printInDebugOnly(String tag, String log, Level level) {
    if (fromUI) {
      InstanceProvider.getInstance().crashReporter.log(log, tag); //always save in Crash Reporter
    }
    if (!Foundation.kReleaseMode) {
      _print('$tag : $log', level);
    }
  }

  static void _print(String textToLog, Level level, {dynamic error, StackTrace stackTrace}) {
//    print("${DateTime.now()} $textToLog");
    textToLog = "${DateTime.now()} $textToLog";
    if (level == null) {
      _logger.d(textToLog);
      return;
    }
    switch (level) {
      case Level.info:
        _logger.i(textToLog);
        break;
      case Level.warning:
        _logger.w(textToLog);
        break;
      case Level.error:
        _logger.e(textToLog, error, stackTrace);
        break;
      default:
        _logger.d(textToLog);
        break;
    }
  }

  ///Use this method to print in logs your error messages.
  static e(String log, [String tag, Error error]) {
    if (fromUI) {
      InstanceProvider.getInstance()?.crashReporter?.logError(log, tag, error);
    }

    if (!Foundation.kReleaseMode) {
      String systemTag = '$tagError $appTag';
      if (tag != null && error != null) {
        _print('$systemTag $tag : $log \n $error', Level.info, error: error, stackTrace: error?.stackTrace);
      } else if (tag != null) {
        _print('$systemTag $tag : $log', Level.info, error: error, stackTrace: error?.stackTrace);
      } else if (error != null) {
        _print('$systemTag : $log \n $error', Level.info, error: error, stackTrace: error?.stackTrace);
      } else {
        _print('$systemTag : $log', Level.info, error: error, stackTrace: error?.stackTrace);
      }
      return true;
    }
  }

  ///Use this method to print in logs user's information messages.
  static i(String log, [String tag]) {
    printInDebugOnly(tag != null ? '$tagInfo $appTag $tag' : '$tagInfo $appTag', log, Level.info);
  }
}
