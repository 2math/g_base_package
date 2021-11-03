//import 'package:colorize/colorize.dart';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:g_base_package/base/app_exception.dart';

import '../flavor_config.dart';
import '../provider/instance_provider.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:logger/logger.dart';

import 'files.dart';

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

  ///option to print logs in release mode, should be used only for testing releases
  static bool printInRelease = false;

  static final _logger = Logger(
    printer: PrettyPrinter(
      printTime: false,
      methodCount: 0,
    ),
  );

  static Logger? _fileLogger;

  static initFileLogger(
      {File? fileToLog, Future<File> Function(File? currentFile)? getNewFile}) {
    _fileLogger = Logger(
        filter: ProductionFilter(),
        printer: PrettyPrinter(
          printTime: false,
          methodCount: 0,
        ),
        output: CustomFileOutput(file: fileToLog, getNewFile: getNewFile));
  }

  //TODO set live template

  ///This method will print developer's info in logs only if we are in debug
  ///mode
  static d(String log, [String? tag]) {
    printInDebugOnly(
        tag != null ? '$tagDebug $appTag $tag' : '$tagDebug $appTag',
        log,
        Level.debug);
  }

  ///This method will print developer's info in logs only if we are in debug
  ///mode, but will not add to the CrashReporter. This one is save for print passwords or other sensitive information
  /// in the console
  static s(String log, [String? tag]) {
    printInDebugOnly(
        tag != null ? '$tagDebug $appTag $tag' : '$tagDebug $appTag',
        log,
        Level.debug,
        addToCrashReporter: false);
  }

  ///This method will print developer's warning logs only if we are in debug
  ///mode
  static w(String log, [String? tag]) {
    printInDebugOnly(
        tag != null ? '$tagWarning $appTag $tag' : '$tagWarning $appTag',
        log,
        Level.warning);
  }

  static void printInDebugOnly(String tag, String log, Level level,
      {bool addToCrashReporter = true}) {
    if (fromUI && addToCrashReporter) {
      InstanceProvider.getInstance()
          ?.crashReporter
          ?.log(log, tag); //always save in Crash Reporter
    }

    if (printInRelease || !Foundation.kReleaseMode) {
      _print('$tag : $log', level, _logger);
    }

    if (_fileLogger != null && addToCrashReporter) {
      _print('$tag : $log', level, _fileLogger);
    }
  }

  static void _print(String textToLog, Level? level, Logger? logger,
      {dynamic error, StackTrace? stackTrace}) {
    if (logger == null) return;
//    print("${DateTime.now()} $textToLog");

    textToLog = "${DateTime.now()} $textToLog";
    if (level == null) {
      logger.d(textToLog);
      return;
    }
    switch (level) {
      case Level.info:
        logger.i(textToLog);
        break;
      case Level.warning:
        logger.w(textToLog);
        break;
      case Level.error:
        logger.e(textToLog, error, stackTrace);
        break;
      default:
        logger.d(textToLog);
        break;
    }
  }

  ///Use this method to print in logs your error messages.
  static error(String log, {String? tag, dynamic error}) {
    e(log, tag, _fixError(error));
  }

  static _fixError(error) {
    if (error == null) {
      error = AppException(data: "Handled error!");
    } else if (!(error is Error)) {
      error = AppException(data: error);
    }
    return error;
  }

  ///Use this method to print in logs your error messages.
  static e(String log, [String? tag, Error? error]) {
    error = _fixError(error);
    if (fromUI) {
      InstanceProvider.getInstance()?.crashReporter?.logError(log, tag, error);
    }

    if (_fileLogger != null) {
      _printError(tag, error, log, _fileLogger);
    }

    if (printInRelease || !Foundation.kReleaseMode) {
      _printError(tag, error, log, _logger);
      return true;
    }
  }

  static void _printError(
      String? tag, Error? error, String log, Logger? logger) {
    if (logger == null) return;

    String systemTag = '$tagError $appTag';
    if (tag != null && error != null) {
      _print('$systemTag $tag : $log \n $error', Level.error, logger,
          error: error, stackTrace: error.stackTrace);
    } else if (tag != null) {
      _print('$systemTag $tag : $log', Level.error, logger,
          error: error, stackTrace: error?.stackTrace);
    } else if (error != null) {
      _print('$systemTag : $log \n $error', Level.error, logger,
          error: error, stackTrace: error.stackTrace);
    } else {
      _print('$systemTag : $log', Level.error, logger,
          error: error, stackTrace: error?.stackTrace);
    }
  }

  ///Use this method to print in logs user's information messages.
  static i(String log, [String? tag]) {
    printInDebugOnly(tag != null ? '$tagInfo $appTag $tag' : '$tagInfo $appTag',
        log, Level.info);
  }
}

class FileLogs {
  Future init(
      {String dirName = 'logs',
      String? fileName,
      bool deleteOtherLogFiles = true,
      int keepVersionsCount = 5}) async {
    Directory dir = await BaseFileUtils.getLocalDir(dirName);

    var files = dir.listSync();

    int latestVersion = 0;

    if (fileName == null) {
      fileName = generateDefaultFileName(fileName);
    }

    String initialFileName = fileName;

    for (final localFile in files) {
      if (getFileName(localFile.path).startsWith(initialFileName)) {
        // we have file for today
        int version = getFileVersion(localFile.path);

        if (version >= latestVersion) {
          fileName = '${initialFileName}_${version + 1}';
          latestVersion = version;
        }
      } else if (deleteOtherLogFiles) {
        // this is logs from previous day delete it to free space
        localFile.delete();
      }
    }

    _deleteOldLogFile(
        latestVersion, keepVersionsCount, initialFileName, dirName);

    File fileToLog = await BaseFileUtils.getLocalFile(dirName, fileName!);

    fileToLog = await fileToLog.writeAsString(
      "\n\n*******************************************"
      "\nNew Session - ${DateTime.now().toIso8601String()}"
      "\n${FlavorConfig.instance.toString()}"
      "\nis release : $kReleaseMode"
      "\n*******************************************\n\n",
      mode: FileMode.append,
    );

    Log.initFileLogger(
        fileToLog: fileToLog,
        getNewFile: (currentFile) {
          int version =
              currentFile == null ? 0 : getFileVersion(currentFile.path);

          _deleteOldLogFile(
              version, keepVersionsCount, initialFileName, dirName);

          String fileName = '${initialFileName}_${version + 1}';

          return BaseFileUtils.getLocalFile(dirName, fileName);
        });
  }

  String generateDefaultFileName(String? fileName) {
    var now = DateTime.now();

    fileName = '${now.day}-${now.month}-${now.year}';
    return fileName;
  }

  Future _deleteOldLogFile(int latestVersion, int keepVersionsCount,
      String initialFileName, String dirName) async {
    // Log.w('Latest version $latestVersion', '_deleteOldLogFile');
    if (latestVersion >= keepVersionsCount) {
      String fileNameToDelete = latestVersion == keepVersionsCount - 1
          ? initialFileName
          : '${initialFileName}_${latestVersion - (keepVersionsCount - 1)}';

      File fileToDelete =
          await BaseFileUtils.getLocalFile(dirName, fileNameToDelete);

      try {
        fileToDelete.delete();
      } catch (e) {
        Log.error('delete old log file', error: e);
      }
    }
  }

  String getFileName(String path) {
    int position = path.lastIndexOf("/");

    if (position == -1) return path;

    return path.substring(path.lastIndexOf("/") + 1);
  }

  int getFileVersion(String path) {
    int position = path.lastIndexOf("_");

    if (position == -1) return 0;

    String version = path.substring(path.lastIndexOf("_") + 1);

    return int.tryParse(version) ?? 0;
  }

  Future<List<File>> getLogFileVersions(
      {String dirName = 'logs', String? fileName}) async {
    Directory dir = await BaseFileUtils.getLocalDir(dirName);

    var files = dir.listSync();

    if (fileName == null) {
      fileName = generateDefaultFileName(fileName);
    }

    String initialFileName = fileName;

    List<File> fileVersions = [];

    for (final localFile in files) {
      if (getFileName(localFile.path).startsWith(initialFileName)) {
        fileVersions.add(localFile as File);
      }
    }

    return fileVersions;
  }
}

class CustomFileOutput extends LogOutput {
  File? file;
  final bool overrideExisting;
  final Encoding encoding;
  Future<File> Function(File? currentFile)? getNewFile;
  IOSink? _sink;
  int linesCount = 0;
  bool isOpeningNewFile = false;

  CustomFileOutput({
    required this.file,
    this.overrideExisting = false,
    this.encoding = utf8,
    this.getNewFile,
  });

  @override
  void init() {
    linesCount = 0;

    if (file != null) {
      _sink = file!.openWrite(
        mode: overrideExisting ? FileMode.writeOnly : FileMode.writeOnlyAppend,
        encoding: encoding,
      );
    }
  }

  @override
  void output(OutputEvent event) {
    if (isOpeningNewFile) return;

    try {
      if (event.level == Level.error) {
        _sink?.writeln('\n\n*********Error*********');
      }

      _sink?.writeAll(event.lines, '\n');

      if (event.level == Level.error) {
        _sink?.writeln('\n*********Error END*********\n');
      }

      linesCount += event.lines.length;

      //if lines are > X open new file
      if (getNewFile != null && linesCount >= 10000) {
        _openNewFile();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void destroy() async {
    await _sink?.flush();
    await _sink?.close();
  }

  Future _openNewFile() async {
    isOpeningNewFile = true;

    File newFile = await getNewFile!(file);

    if (newFile != null) {
      await _sink?.flush();

      await _sink?.close();

      _sink = null;

      file = newFile;

      init();

      _sink?.writeAll([
        "*******************************************",
        "Continue Session - ${DateTime.now().toIso8601String()}",
        "${FlavorConfig.instance.toString()}",
        "is release : $kReleaseMode",
        "*******************************************\n"
      ], '\n');
    }

    isOpeningNewFile = false;
  }
}

/// Logs simultaneously to multiple [LogOutput] outputs.
class MultiOutput extends LogOutput {
  late List<LogOutput> _outputs;

  MultiOutput(List<LogOutput> outputs) {
    _outputs = _normalizeOutputs(outputs);
  }

  List<LogOutput> _normalizeOutputs(List<LogOutput> outputs) {
    final normalizedOutputs = <LogOutput>[];

    if (outputs != null) {
      for (final output in outputs) {
        if (output != null) {
          normalizedOutputs.add(output);
        }
      }
    }

    return normalizedOutputs;
  }

  @override
  void init() {
    _outputs.forEach((o) => o.init());
  }

  @override
  void output(OutputEvent event) {
    _outputs.forEach((o) => o.output(event));
  }

  @override
  void destroy() {
    _outputs.forEach((o) => o.destroy());
  }
}
