import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'logger.dart';

class BaseFileUtils {
  static String _localPath;

  ///If directory is null will use base local directory(ApplicationDocumentsDirectory).
  ///If directory does not exist will be created
  ///will return the File which may not exist!
  static Future<File> getLocalFile(String directory, String fileName) async {
    Directory dir = await getLocalDir(directory);
    String fullName = join(dir.path, fileName);
    Log.d(fullName);
    return File('$fullName');
  }

  ///Get or create a local directory , pass recursive as true if directory is recursive
  ///if dirToBeCreated == null will return main local directory
  static Future<Directory> getLocalDir(String dirToBeCreated,
      {bool recursive = false}) async {
    var baseDir = await localPath;
    String finalDir =
        dirToBeCreated == null ? baseDir : join(baseDir, dirToBeCreated);

    var dir = Directory(finalDir);

    if (!await dir.exists()) {
      return dir.create(recursive: recursive);
    }

    return dir;
  }

  static Future<String> get localPath async {
    //get _localPath only once per app's lifetime it will not change
    if (_localPath == null) {
      final directory = await getApplicationDocumentsDirectory();
//      Log.d(directory.path);
      _localPath = directory.path;
    }
    return _localPath;
  }
}
