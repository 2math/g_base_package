import 'dart:io';
import 'package:g_base_package/base/net/base_network_manager.dart';
import 'package:g_base_package/base/flavor_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';

enum CallMethod { GET, POST, PUT, PATCH, DELETE, DOWNLOAD, UPLOAD, UPLOAD_UPDATE, MULTIPART }

typedef OnUploadProgressCallback = void Function(int sentBytes, int totalBytes);

///Holds information for 1 network call.
///[BaseNetworkManager] needs this object to make the actual call and respond.
class Call {
  ///Enum indicating network method.
  CallMethod callMethod;

  ///This can be POST or PUT. POST by default.
  CallMethod? multipartMethod;

  ///If we have set [FlavorConfig.baseUrl], then here can pass only the endpoint behind it.
  ///Other way we should pass the entire url(server url + endpoint) and set the flag [isFullUrl] to TRUE.
  String endpoint;

  ///Key value parameters to be appended to the end url as url parameters if [callMethod] is [CallMethod.GET].
  ///For other methods is sent as body, in that case we should have either [body] or [params].
  ///If the method is [CallMethod.POST] and we have set [params], then the content type is set from
  ///application/json to application/x-www-form-urlencoded .
  Map<String, String>? params;

  ///Custom headers to be added to the network request.
  Map<String, String>? headers;

  ///JSON formatted body.
  ///For POST, UPDATE, PATCH, Delete will set the content type to application/json.
  ///You can set either [body] or [params].
  String? body;

  String? toLog;

  ///Authorization token to the server. If is not null and if we have
  /// set [FlavorConfig.headerToken] field, will be added as a header to the request.
  String? token;

  ///Custom header field to be send to the server on request.
  ///You must set the header name in [FlavorConfig.headerLanguage] first.
  String? language;

  ///Field used for [CallMethod.UPLOAD], [CallMethod.UPLOAD_UPDATE] or [CallMethod.MULTIPART].
  ///This is actual file name that should be passed with the request.
  String? fileName;

  ///Field used for [CallMethod.UPLOAD], [CallMethod.UPLOAD_UPDATE] or [CallMethod.MULTIPART].
  ///This is field name on which the file should be set with the request.
  ///If is not set "file" is used.
  String? fileField;

  ///Indicates if [endpoint] field should be treated as full url or to be appended to [PolarFlavorConfig.baseUrl].
  ///FALSE by default.
  bool isFullUrl;

  @Deprecated('Use isFullUrl instead')
  bool isServerUrl;

  ///If on the request we receive 401 and this flag is TRUE, then the network manager will try
  ///to authorize again and repeat again the same code. If still got 401, the initial error is thrown.
  ///TRUE by default.
  bool refreshOn401;

  ///Flag to indicate if we want to log the request and response data.
  ///TRUE by default.
  ///In case is too big and makes your logs hard to read, set it to false.
  ///If you have sensitive information use [printResponseBody] to control it.
  bool  printLogs;

  ///Flag to indicate if we want to log the response body or just the response code.
  ///TRUE by default.
  ///If you have sensitive information set it to false or kDebugMode.
  bool  printResponseBody;


  bool  shouldCheckCustomErrors;

  ///Flag to indicate if we want to log the response headers.
  ///Useful for debug network calls.
  ///FALSE by default.
  bool  printResponseHeaders;

  ///If on the request we receive 401 and [refreshOn401] flag is TRUE, then the app can refresh in 2 different ways.
  ///If this flag is TRUE, will call [BaseNetworkManager.tryToRefreshSessionWithCall], else
  ///will call [BaseNetworkManager.tryToRefreshSession].
  ///FALSE by default.
  bool  refreshWithCall;

  ///Flag to indicate if you expect positive response to be json.
  ///If is True(by default) will print the response as well json formatted string else will be just the string.
  ///If you don't set it to false and the response is not json will see in the log handled error from
  ///[BaseNetworkManager] to not able to format the json.
  bool  isJsonResponse;

  ///File used for [CallMethod.UPLOAD] or [CallMethod.UPLOAD_UPDATE].
  ///If you want to upload on web use MULTIPART and pass [fileBites] instead.
  File? file;

  ///For multipart request that supports web add the file bites instead of the file.
  ///File bites used for [CallMethod.MULTIPART].
  Uint8List? fileBites;

  ///Field used for [CallMethod.UPLOAD], [CallMethod.UPLOAD_UPDATE] or [CallMethod.MULTIPART].
  ///The content type of the request will be generated from the file media type.
  MediaType? mediaType;

  ///Callback used for [CallMethod.UPLOAD] or [CallMethod.UPLOAD_UPDATE].
  ///Important, the http stream is updating this callback on data sent.
  ///It means it will send the file on chunks and update you on each chunk,
  ///but the final response from the server could be slower.
  ///Keep that in mind if you use that callback to indicate uploading progress.
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
    this.isJsonResponse = true,
    this.file,
    this.mediaType,
    this.fileName,
    this.fileField,
    this.refreshOn401 = true,
    this.refreshWithCall = false,
    this.shouldCheckCustomErrors = true,
    this.printResponseHeaders = false,
    this.onUploadProgress,
    this.fileBites,
    this.multipartMethod,
  });
}
