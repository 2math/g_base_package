import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:g_base_package/base/provider/instance_provider.dart';

import '../lang/localization.dart';
import '../flavor_config.dart';
import '../utils/logger.dart';
import '../utils/versions.dart';
import '../app_exception.dart';
import 'call.dart';

// import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class BaseNetworkManager {
  final String netTag = "NET";
  String? latestCookie;
  Map<String, String>? latestHeaders;

  Future<T?> doServerCall<T>(
      Call call, Function handlePositiveResultBody) async {
    await _checkNetwork();

    final response = await _doCall(call);

    if (response.statusCode < 300) {
      return await (_onPositiveResponse<T>(
          call, response, handlePositiveResultBody));
    } else {
      if (call.shouldCheckCustomErrors &&
          getCustomErrorResponseCodes().contains(response.statusCode)) {
        var res = await handleCustomError(call, response);

        if (res != null) {
          //return the response
          return res;
        }
      }

      if (response.statusCode == 401 && call.refreshOn401) {
        Log.d("tryToRefreshSession", netTag);
        String? newToken = await tryToRefreshSession();

        if (newToken != null) {
          Log.d("repeat call with new session", netTag);

          call.token = newToken;

          final response2 = await _doCall(call);

          if (response2.statusCode < 300) {
            return await (_onPositiveResponse(
                call, response2, handlePositiveResultBody));
          } else {
            throw AppException(
                errorMessage: 'Server Error',
                code: response2.statusCode,
                data: _getBodyAsUtf8(response2));
          }
        } else {
          //return original response if we couldn't auto login!
          throw AppException(
              errorMessage: 'Server Error',
              code: response.statusCode,
              data: _getBodyAsUtf8(response));
        }
      } else {
        // If that call was not successful, throw an error.
        throw AppException(
            errorMessage: 'Server Error',
            code: response.statusCode,
            data: _getBodyAsUtf8(response));
      }
    }
  }

  ///override this function if you want to refresh session on 401 and repeat call
  Future<String?> tryToRefreshSession() async {
    return Future.value(null);
  }

  ///override this function if you want to be called when custom response code is received and want to handle it
  ///globally
  List<int> getCustomErrorResponseCodes() {
    return [];
  }

  ///override this function to be called when response code is in getCustomErrorResponseCodes()
  ///should return null if we want to continue as regular or return some object to stop
  ///You can also trow some AppException
  Future<dynamic> handleCustomError(Call call, http.Response response) async {
    return Future.value(null);
  }

  Future<Version?> getVersions() async {
//    return Version(clientVersion: "1.10.7", currentVersion: 5, minimalVersion: 2);
    Call call = new Call.name(
        CallMethod.GET, "versions/${Platform.isIOS ? "IOS" : "ANDROID"}");

    return await doServerCall<Version>(call, (json) {
      Log.d(json, "$netTag versions");
      return Version.fromJson(jsonDecode(json));
    });
  }

  Future<T?> _onPositiveResponse<T>(Call call, http.Response response,
      Function handlePositiveResultBody) async {
    if(call.printResponseHeaders) {
      Log.d(_printMap(response.headers));
    }

    latestHeaders = response.headers;

    latestCookie = response.headers['set-cookie'];

    if (call.callMethod == CallMethod.DOWNLOAD) {
      return await _saveToFile(call, response);
    } else {
      // If the call to the server was successful, parse the JSON.
      return await handlePositiveResultBody(
          _getBodyAsUtf8(response)); //JsonParser().toPost
    }
  }

  Future<http.Response> _doCall(Call call) async {
    switch (call.callMethod) {
      case CallMethod.GET:
        return _doGetRequest(call);
      case CallMethod.POST:
        return _doPostRequest(call);
      case CallMethod.PUT:
      case CallMethod.PATCH:
        return _doPutRequest(call);
      case CallMethod.DELETE:
        return _doDeleteRequest(call);
      case CallMethod.DOWNLOAD:
        return _doDownloadFileRequest(call);
      case CallMethod.UPLOAD:
        return call.onUploadProgress != null
            ? _doUploadFileMultipart(call)
            : _doUploadFile(call);
      case CallMethod.UPLOAD_UPDATE:
        return _doUploadFileMultipart(call);
      default:
        throw AppException(
            errorMessage: 'Call without method',
            code: AppException.NO_CALL_METHOD_ERROR,
            data: call);
    }
  }

  Future<http.Response> _doGetRequest(Call call) async {
    Map<String, String> headers =
        _getUpdatedHeaders(call.token, call.language, null, call.headers);
    String url = _getUrl(call);

    String requestLog = "$url\nHeaders :\n${_printMap(headers)}";

    if (call.printLogs) {
      Log.d(requestLog, "$netTag GET");
    }

    _logLastRequest("GET", requestLog);

    // make GET request
    http.Response response =
        await http.get(Uri.parse(url), headers: headers); //todo add timeout

//    String responseHeaders = _printMap(response.headers);
    String responseLog = "Response Code : ${response.statusCode}\n"
//            "Headers :\n$responseHeaders\n"
        "${call.printResponseBody ? "Body :\n${_printJson(_getBodyAsUtf8(response))}" : ""}";

    _logLastResponse("GET", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog", "$netTag Response GET");
    }
    return response;
  }

  void _logLastRequestAndResponse(
      String method, String requestLog, String responseLog) {
    InstanceProvider.getInstance()
        ?.crashReporter
        ?.setString("Last Call", '$method : $requestLog');
    InstanceProvider.getInstance()
        ?.crashReporter
        ?.setString("Last Call response", responseLog);
  }

  void _logLastRequest(String method, String requestLog) {
    InstanceProvider.getInstance()
        ?.crashReporter
        ?.setString("Last Call", '$method : $requestLog');
  }

  void _logLastResponse(String method, String url, String responseLog) {
    InstanceProvider.getInstance()
        ?.crashReporter
        ?.setString("Last Call response", '$method $url : $responseLog');
  }

  String _getBodyAsUtf8(http.Response response) =>
      utf8.decode(response.bodyBytes);

  Future<http.Response> _doPostRequest(Call call) async {
    String contentType = call.params != null
        ? "application/x-www-form-urlencoded; charset=utf-8"
        : "application/json; charset=utf-8";
    Map<String, String> headers = _getUpdatedHeaders(
        call.token, call.language, contentType, call.headers);

    String url = _getUrl(call);

    String requestLog = "$url\nHeaders :\n${_printMap(headers)}\n"
        "Body :\n${call.body != null ? _printJson(call.body) : _printMap(call.params)}";

    _logLastRequest("POST", requestLog);

    if (call.printLogs) {
      Log.d(requestLog, "$netTag POST");
    }
    // make POST request
    http.Response response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: call.body ?? call.params,
      encoding: Encoding.getByName("utf-8"),
    );

    String responseLog = "Response Code : ${response.statusCode}\n"
//            "Headers :\n$responseHeaders\n"
        "${call.printResponseBody ? "Body :\n${_printJson(_getBodyAsUtf8(response))}" : ""}";

    _logLastResponse("POST", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog", "$netTag Response POST");
    }
    return response;
  }

  Future<http.Response> _doPutRequest(Call call) async {
    Map<String, String> headers = _getUpdatedHeaders(call.token, call.language,
        "application/json; charset=utf-8", call.headers);

    String url = _getUrl(call);

    String requestLog = "$url\nHeaders :\n${_printMap(headers)}\n"
        "Body :\n${call.body != null ? _printJson(call.body) : _printMap(call.params)}";

    _logLastRequest(
        call.callMethod == CallMethod.PUT ? "PUT" : "PATCH", requestLog);

    if (call.printLogs) {
      Log.d(requestLog,
          "$netTag ${call.callMethod == CallMethod.PUT ? "PUT" : "PATCH"}");
    }

    // make PUT request
    http.Response response = call.callMethod == CallMethod.PUT
        ? await http.put(Uri.parse(url),
            headers: headers,
            body: call.body,
            encoding: Encoding.getByName("utf-8"))
        : await http.patch(Uri.parse(url),
            headers: headers,
            body: call.body,
            encoding: Encoding.getByName("utf-8"));

    String responseLog = "Response Code : ${response.statusCode}\n"
//            "Headers :\n$responseHeaders\n"
        "${call.printResponseBody ? "Body :\n${_printJson(_getBodyAsUtf8(response))}" : ""}";

    _logLastResponse(
        call.callMethod == CallMethod.PUT ? "PUT" : "PATCH", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog",
          "$netTag Response ${call.callMethod == CallMethod.PUT ? "PUT" : "PATCH"}");
    }
    return response;
  }

  Future<http.Response> _doDeleteRequest(Call call) async {
    Map<String, String> headers =
        _getUpdatedHeaders(call.token, call.language, null, call.headers);
    String url = _getUrl(call);

    String requestLog = "$url\nHeaders :\n${_printMap(headers)}";

    _logLastRequest("DELETE", requestLog);

    if (call.printLogs) {
      Log.d(requestLog, "$netTag DELETE");
    }
    // make GET request
    http.Response response =
        await http.delete(Uri.parse(url), headers: headers);

//    String responseHeaders = _printMap(response.headers);
    String responseLog = "Response Code : ${response.statusCode}\n"
//            "Headers :\n$responseHeaders\n"
        "${call.printResponseBody ? "Body :\n${_printJson(_getBodyAsUtf8(response))}" : ""}";

    _logLastResponse("DELETE", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog", "$netTag Response DELETE");
    }
    return response;
  }

  Future<http.Response> _doDownloadFileRequest(Call call) async {
    Map<String, String> headers =
        _getUpdatedHeaders(call.token, call.language, null, call.headers);
    String fileURL = _getUrl(call);

    String requestLog = "$fileURL\nHeaders :\n${_printMap(headers)}";

    _logLastRequest("Download", requestLog);

    if (call.printLogs) {
      Log.d(requestLog, "$netTag GET");
    }
    // make GET request
    http.Response response =
        await http.get(Uri.parse(fileURL), headers: headers); //todo add timeout

    String responseHeaders = _printMap(response.headers);

    String responseLog;

    if (response.statusCode < 300) {
      String fileName = "";
      String? disposition = response.headers["Content-Disposition"];
      if (disposition != null) {
        // extracts file name from header field
        int index = disposition.indexOf("filename=");
        if (index > 0) {
          fileName = disposition.substring(index + 10, disposition.length - 1);
        }
      } else {
        // extracts file name from URL
        fileName =
            fileURL.substring(fileURL.lastIndexOf("/") + 1, fileURL.length);
      }

      //    String responseHeaders = _printMap(response.headers);
      responseLog =
          "Response Code : ${response.statusCode}\nContent-Disposition = $disposition"
          "\nContent-Length = ${response.contentLength}\nfileName = $fileName"
          "\nResponse Headers\n$responseHeaders";

      if (call.printLogs) {
        Log.d("$fileURL\n$responseLog", "$netTag Response Download");
      }
    } else {
      responseLog = "Response Code : ${response.statusCode}";
      if (call.printLogs) {
        Log.d("$fileURL\n$responseLog", "$netTag Response Download");
      }
    }

    _logLastResponse("Download", fileURL, responseLog);

    return response;
  }

  Future<http.Response> _doUploadFileMultipart(Call call) async {
    if (call.callMethod == CallMethod.UPLOAD &&
        (call.file == null || !await call.file!.exists())) {
      Log.w('Uploading File without actual file set', "$netTag UploadFile");
      // throw AppException(
      //     errorMessage: 'Uploading File without actual file set', code: AppException.NO_CALL_METHOD_ERROR, data: call);
    }

    String url = _getUrl(call);

    final request = call.callMethod == CallMethod.UPLOAD_UPDATE
        ? await HttpClient().putUrl(Uri.parse(url))
        : await HttpClient().postUrl(Uri.parse(url));

    var requestMultipart = http.MultipartRequest(request.method, Uri.parse("uri"));

    if (call.file != null && await call.file!.exists()) {
      var multipartFile = await http.MultipartFile.fromPath(
          "file", call.file!.path,
          filename: call.fileName, contentType: call.mediaType);

      requestMultipart.files.add(multipartFile);
    }

    if (call.params != null) {
      requestMultipart.fields.addAll(call.params!);
    }

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;

    request.contentLength = totalByteLength;

    Map<String, String> headers = _getUpdatedHeaders(call.token, call.language,
        requestMultipart.headers[HttpHeaders.contentTypeHeader], call.headers);
    headers.forEach((key, value) {
      request.headers.set(key, value);
    });

    if (call.printLogs) {
      Log.d(requestMultipart.headers[HttpHeaders.contentTypeHeader]!);
    }
//    request.headers.set(HttpHeaders.contentTypeHeader, requestMultipart.headers[HttpHeaders.contentTypeHeader]);

    int byteCount = 0;

    Stream<List<int>> streamUpload = msStream.transform(
      new StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(data);

          byteCount += data.length;

          if (call.onUploadProgress != null) {
            call.onUploadProgress!(byteCount, totalByteLength);
            // CALL STATUS CALLBACK;
          }
        },
        handleError: (error, stack, sink) {
          //print(error.toString());
        },
        handleDone: (sink) {
          sink.close();
          // UPLOAD DONE;
        },
      ),
    );

    await request.addStream(streamUpload);

    String requestLog = "$url\nParams :\n${_printMap(call.params)}"
        "\nHeaders :\n${_printMap(headers)}"
        "\nFile : ${call.file?.path}"
        "\nfilename : ${call.fileName}"
        "\ncontentType : ${call.mediaType}"
        "\ncontentLength : $totalByteLength";

    _logLastRequest("UploadFile", requestLog);

    if (call.printLogs) {
      Log.d(requestLog, "$netTag UploadFile");
    }
    final httpResponse = await request.close();
//    var response = await request.send();
//
//    http.Response httpResponse = await http.Response.fromStream(response);

    String res = await _readResponseAsString(httpResponse);

    String responseLog = "Response Code : ${httpResponse.statusCode}\n"
        "${call.printResponseBody ? "Body :\n${_printJson(res)}" : ""}";

    _logLastResponse("UploadFile", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog", "$netTag Response UploadFile");
    }
    return http.Response(res, httpResponse.statusCode);
  }

  Future<String> _readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  Future<http.Response> _doUploadFile(Call call) async {
    if (call.file == null || !await call.file!.exists()) {
      throw AppException(
          errorMessage: 'Uploading File without actual file set',
          code: AppException.NO_CALL_METHOD_ERROR,
          data: call);
    }
    var stream = new http.ByteStream(call.file!.openRead());
    var length = await call.file!.length();
    String url = _getUrl(call);

    var request = new http.MultipartRequest("POST", Uri.parse(url));

    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: call.fileName, contentType: call.mediaType);

    request.files.add(multipartFile);

    Map<String, String> headers =
        _getUpdatedHeaders(call.token, call.language, null, call.headers);
    request.headers.addAll(headers);

    String requestLog = "$url\nHeaders :\n${_printMap(request.headers)}"
        "\nFile : ${call.file!.path}"
        "\nfilename : ${call.fileName}"
        "\ncontentType : ${call.mediaType}"
        "\ncontentLenght : $length";

    _logLastRequest("UploadFile", requestLog);

    if (call.printLogs) {
      Log.d(requestLog, "$netTag UploadFile");
    }
    var response = await request.send();
    http.Response httpResponse = await http.Response.fromStream(response);

    String responseLog = "Response Code : ${response.statusCode}\n"
        "${call.printResponseBody ? "Body :\n${_printJson(httpResponse.body)}" : ""}";

    _logLastResponse("UploadFile", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog", "$netTag Response UploadFile");
    }
    return httpResponse;
  }

  String _getUrl(Call call) {
    // if (call.isHttp) {
    //  return Uri.http(
    //     call.isFullUrl ? call.endpoint : FlavorConfig.instance.baseUrl,
    //     call.isFullUrl ? null : call.endpoint,
    //     _isGetWithParams(call) ? call.params : null,
    //   );
    // } else {
    //   Uri.https(
    //     call.isFullUrl ? call.endpoint : FlavorConfig.instance.baseUrl,
    //     call.isFullUrl ? null : call.endpoint,
    //     _isGetWithParams(call) ? call.params : null,
    //   );
    // }

    String url = call.isFullUrl
        ? call.endpoint
        : FlavorConfig.instance!.baseUrl + call.endpoint;
    if (_isGetWithParams(call)) {
      String urlParams = call.params!.keys
          .map((key) =>
              "${Uri.encodeComponent(key)}=${Uri.encodeComponent(call.params![key]!)}")
          .join("&");
      url = url + "?" + urlParams;
    }

    return url;
  }

  bool _isGetWithParams(Call call) =>
      call.callMethod == CallMethod.GET &&
      call.params != null &&
      call.params!.isNotEmpty;

  Map<String, String> _getUpdatedHeaders(
      String? token, String? language, String? contentType,
      [Map<String, String>? customHeadersToAdd]) {
    customHeadersToAdd ??= <String, String>{};

    customHeadersToAdd["accept-encoding"] = "utf-8";
    customHeadersToAdd["accept-charset"] = "utf-8";

    if (token != null && FlavorConfig.instance!.headerToken != null) {
      customHeadersToAdd[FlavorConfig.instance!.headerToken!] = token;
    }

    if (language != null && FlavorConfig.instance!.headerLanguage != null) {
      customHeadersToAdd[FlavorConfig.instance!.headerLanguage!] = language;
    }

    if (contentType != null &&
        FlavorConfig.instance!.headerContentType != null) {
      customHeadersToAdd[FlavorConfig.instance!.headerContentType!] =
          contentType;
    }

    if (FlavorConfig.instance!.headerVersion != null) {
      customHeadersToAdd[FlavorConfig.instance!.headerVersion!] =
          Platform.isIOS && FlavorConfig.instance!.useVersionForIOS
              ? (FlavorConfig.instance!.version ?? "unknown")
              : (FlavorConfig.instance!.buildNumber ?? "unknown");
    }
    if (FlavorConfig.instance!.headerOS != null) {
      String? os = (Platform.isAndroid
              ? FlavorConfig.instance!.headerValueAndroid
              : Platform.isIOS
                  ? FlavorConfig.instance!.headerValueIOS
                  : "unknown") ??
          "headerValue not set";
      customHeadersToAdd[FlavorConfig.instance!.headerOS!] = os;
    }

    return customHeadersToAdd;
  }

  String _printMap(Map<String?, String?>? map) {
    String res = "";
    if (map != null) {
      map.forEach((k, v) => res = res + ('   $k: $v\n'));
    }
    return res;
  }

  String _printJson(String? jsonToParse) {
    if (jsonToParse == null) {
      return "NULL";
    }
    if (jsonToParse.isEmpty) {
      return "EMPTY";
    }
    try {
//      JsonUtf8Encoder e8 = JsonUtf8Encoder();
//      Log.d("b: "+utf8.decode(e8.convert(json.decode(jsonToParse))));

      JsonEncoder encoder = const JsonEncoder.withIndent('  ');
      return encoder.convert(json.decode(jsonToParse));
    } catch (e) {
      Log.error("printJson", error: e);
      return jsonToParse;
    }
  }

  Future _checkNetwork() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      _throwNoNetwork();
    }
  }

  void _throwNoNetwork() {
    throw AppException(
        errorMessage: FlavorConfig.instance!.noNetworkKey != null
            ? Txt.get(FlavorConfig.instance!.noNetworkKey)
            : "No network",
        code: AppException.OFFLINE_ERROR);
  }

  ///will be called on positive response only
  Future _saveToFile(Call call, http.Response response) {
    if (call.file != null) {
      return call.file!.writeAsBytes(response.bodyBytes);
    }
    throw AppException(
        errorMessage: 'No file to save into',
        code: response.statusCode,
        data: "No file");
  }
}
