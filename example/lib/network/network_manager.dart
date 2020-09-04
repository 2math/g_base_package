import 'dart:convert';
import 'dart:io';
import 'package:g_base_package/base/utils/utils.dart';
import 'package:http_parser/http_parser.dart';

import 'package:example/model/page.dart';
import 'package:example/model/session.dart';
import 'package:g_base_package/base/net/base_network_manager.dart';
import 'package:g_base_package/base/net/call.dart';
import 'package:g_base_package/base/utils/logger.dart';

import 'net_constants.dart';

class NetworkManager extends BaseNetworkManager {
  String _token;

  NetworkManager(this._token);

  @override
  Future<String> tryToRefreshSession() async {
    var session = await login("g.blagoev@futurist-labs.com", "123456", (json) {
      try {
        var session = Session.fromJson(jsonDecode(json));
        _token = session?.sessionId;
        return session;
      } catch (e) {
        Log.e("weird error parsing session", "tryToRefreshSession", e);
      }
      return null;
    });
    if (session != null) {
      return session.sessionId;
    }
    return null;
  }

  /**
   * open calls
   */

  ///pass a function which will get the JsonBody as parameter and will be called in background
  ///only if the result is positive, so the app can handle there json parsing and persisting
  Future<Session> login(String email, String pass, Function handlePositiveResultBody) async {
    var body = {
      'username': email,
      'password': pass,
    };
    Call call = new Call.name(CallMethod.POST, NetConstants.SESSIONS, body: jsonEncode(body), refreshOn401: false);

//    call = new Call.name(
//        CallMethod.GET, "http://www.mocky.io/v2/5e4285162f00007b0087f697",
//        isFullUrl: true, isServerUrl: false);
    return await doServerCall<Session>(call, handlePositiveResultBody);
  }

  Future<Page> getPage(String pageName, Function handlePositiveResultBody) async {
    Call call = new Call.name(CallMethod.GET, "${NetConstants.PAGE}/$pageName", token: _token);

    return await doServerCall<Page>(call, handlePositiveResultBody);
  }

  /**authorized calls*/

  ///We must pass the sessionId , because is deleted from repository already
  Future<bool> logout() async {
    Call call = new Call.name(CallMethod.DELETE, NetConstants.SESSIONS, token: _token, refreshOn401: false);

    return await doServerCall<bool>(call, (json) {});
  }

  ///Get all workspaces of mine
  Future<List<Object>> getWorkspaces(String companyId, Function handlePositiveResultBody) async {
    Call call = new Call.name(CallMethod.GET, "v1/companies/$companyId/workspaces", token: _token);

    return await doServerCall<List<Object>>(call, handlePositiveResultBody);
  }

  Future<void> uploadImageFuture(String pathFile, String companyId, String workspaceId, handlePositiveResultBody)
  async {
    File file = File(pathFile);

    Call call = new Call.name(
      CallMethod.UPLOAD,
      "v1/companies/$companyId/workspaces/$workspaceId/resources",
      token: _token,
      file: file,
      fileName: pathFile.substring(pathFile.lastIndexOf("/") + 1),
      mediaType: MediaType("image", "jpg"),
      onUploadProgress: (sentBytes, totalBytes) {
        Log.w("$sentBytes - $totalBytes", "onUploadProgress");
      },
      refreshOn401: false,
    );

    return await doServerCall<void>(call, handlePositiveResultBody);
  }

  Future<void> uploadFileFuture(
      String pathFile, String companyId, String workspaceId, String data, handlePositiveResultBody) async {
    File file = File(pathFile);

    Call call = new Call.name(
      CallMethod.UPLOAD,
      "v1/companies/$companyId/workspaces/$workspaceId/documents",
      token: _token,
      file: file,
      fileName: pathFile.substring(pathFile.lastIndexOf("/") + 1),
      mediaType: MediaType("image", "jpg"),
      params: {"data": data},
      onUploadProgress: (sentBytes, totalBytes) {
        Log.w("$sentBytes - $totalBytes", "onUploadProgress");
      },
      refreshOn401: false,
    );

    return await doServerCall<void>(call, handlePositiveResultBody);
  }

  Future<void> updateFileFuture(
  {String pathFile, String companyId, String workspaceId, String documentId, String data, handlePositiveResultBody})
  async {
    File file = BaseUtils.isNotEmptyStr(pathFile) ? File(pathFile) : null;

    Call call = new Call.name(
      CallMethod.UPLOAD_UPDATE,
      "v1/companies/$companyId/workspaces/$workspaceId/documents/$documentId",
      token: _token,
      file: file,
      fileName: file != null ? pathFile.substring(pathFile.lastIndexOf("/") + 1) : null,
      mediaType: MediaType("image", "jpg"),
      params: {"data": data},
      onUploadProgress: (sentBytes, totalBytes) {
        Log.w("$sentBytes - $totalBytes", "onUploadProgress");
      },
    );

    return await doServerCall<void>(call, handlePositiveResultBody);
  }

  Future<void> deleteFile(String companyId, String workspaceId, String documentId, handlePositiveResultBody) async {
    Call call = new Call.name(
      CallMethod.DELETE,
      "v1/companies/$companyId/workspaces/$workspaceId/documents/$documentId",
      token: _token,
    );

    return await doServerCall<void>(call, handlePositiveResultBody);
  }

  Future<void> getFile(String companyId, String workspaceId) async {
    Call call = new Call.name(
      CallMethod.GET,
      "v1/companies/$companyId/workspaces/$workspaceId/documents",
      token: _token,
    );

    return await doServerCall<void>(call, (_) {});
  }
}
