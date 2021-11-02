import 'dart:io';
import 'package:http_parser/http_parser.dart';

enum CallMethod { GET, POST, PUT, PATCH, DELETE, DOWNLOAD, UPLOAD, UPLOAD_UPDATE }

typedef void OnUploadProgressCallback(int sentBytes, int totalBytes);

class Call {
  CallMethod callMethod;
  String endpoint;
  Map<String, String>? params, headers;
  String? body, toLog, token, language, fileName;
  bool isFullUrl, isServerUrl, refreshOn401, printLogs, printResponseBody, shouldCheckCustomErrors;
  File? file;
  MediaType? mediaType;
  OnUploadProgressCallback? onUploadProgress;

  Call.name(
    this.callMethod,
    this.endpoint, {
    this.params,
    this.headers,
    this.body,
    this.toLog,
    this.token,
    this.language,
    this.isFullUrl = false,
    this.isServerUrl = true,
    this.printLogs = true,
    this.printResponseBody = true,
    this.file,
    this.mediaType,
    this.fileName,
    this.refreshOn401 = true,
    this.shouldCheckCustomErrors = true,
    this.onUploadProgress,
  });
}
