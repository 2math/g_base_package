import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:g_base_package/base/flavor_config.dart';
import 'package:g_base_package/base/utils/logger.dart';
import 'package:g_base_package/base/utils/network.dart';
import 'package:g_base_package/base/net/call.dart';
import 'package:g_base_package/base/utils/system.dart';
import 'package:http/http.dart' as http;

class PlatformInterface {
  static Future<bool> checkInternet() async {
    return NetUtil().checkInternet();
  }

  static bool get isAndroid => Platform.isAndroid;

  static bool get isIOS => Platform.isIOS;

  static bool get isWindows => Platform.isWindows;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isLinux => Platform.isLinux;

  static Future<http.Response> doUploadFileMultipart(String url, Call call) async {
    final request = call.callMethod == CallMethod.UPLOAD_UPDATE
        ? await HttpClient().putUrl(Uri.parse(url))
        : await HttpClient().postUrl(Uri.parse(url));

    var requestMultipart = http.MultipartRequest(request.method, Uri.parse("uri"));

    if (call.file != null && await call.file!.exists()) {
      var multipartFile = await http.MultipartFile.fromPath(call.fileField ?? "file", call.file!.path,
          filename: call.fileName, contentType: call.mediaType);

      requestMultipart.files.add(multipartFile);
    }

    if (call.params != null) {
      requestMultipart.fields.addAll(call.params!);
    }

    var msStream = requestMultipart.finalize();

    var totalByteLength = requestMultipart.contentLength;

    request.contentLength = totalByteLength;

    Map<String, String> headers = _getUpdatedHeaders(
        call.token, call.language, requestMultipart.headers[HttpHeaders.contentTypeHeader], call.headers);

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

    // _logLastRequest("UploadFile", requestLog);

    if (call.printLogs) {
      Log.d(requestLog, "NET UploadFile");
    }
    final httpResponse = await request.close();
//    var response = await request.send();
//
//    http.Response httpResponse = await http.Response.fromStream(response);

    String res = await _readResponseAsString(httpResponse);

    String responseLog = "Response Code : ${httpResponse.statusCode}\n"
        "${call.printResponseBody ? "Body :\n${_printJson(res, true)}" : ""}";

    // _logLastResponse("UploadFile", url, responseLog);

    if (call.printLogs) {
      Log.d("$url\n$responseLog", "NET Response UploadFile");
    }
    return http.Response(res, httpResponse.statusCode);
  }

  static Future<String> _readResponseAsString(HttpClientResponse response) {
    var completer = Completer<String>();
    var contents = StringBuffer();
    response.transform(utf8.decoder).listen((String data) {
      contents.write(data);
    }, onDone: () => completer.complete(contents.toString()));
    return completer.future;
  }

  static Map<String, String> _getUpdatedHeaders(String? token, String? language, String? contentType,
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

    if (contentType != null && FlavorConfig.instance!.headerContentType != null) {
      customHeadersToAdd[FlavorConfig.instance!.headerContentType!] = contentType;
    }

    if (FlavorConfig.instance!.headerVersion != null) {
      customHeadersToAdd[FlavorConfig.instance!.headerVersion!] =
      System().isIOS() && FlavorConfig.instance!.useVersionForIOS
          ? (FlavorConfig.instance!.version ?? "unknown")
          : (FlavorConfig.instance!.buildNumber ?? "unknown");
    }
    if (FlavorConfig.instance!.headerOS != null) {
      String? os = (System().isAndroid()
          ? FlavorConfig.instance!.headerValueAndroid
          : System().isIOS()
          ? FlavorConfig.instance!.headerValueIOS
          : "unknown") ??
          "headerValue not set";
      customHeadersToAdd[FlavorConfig.instance!.headerOS!] = os;
    }

    return customHeadersToAdd;
  }

  static String _printMap(Map<String?, String?>? map) {
    String res = "";
    if (map != null) {
      map.forEach((k, v) => res = res + ('   $k: $v\n'));
    }
    return res;
  }

  static String _printJson(String? jsonToParse, bool isJson) {
    if (jsonToParse == null) {
      return "NULL";
    }
    if (jsonToParse.isEmpty) {
      return "EMPTY";
    }

    if (isJson) {
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

    return jsonToParse;
  }
}
