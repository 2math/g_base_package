import 'dart:convert';

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
    var session = await login("mm@mm.mm", "mmmmmm", (json) {
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
    Call call = new Call.name(CallMethod.GET, "v1/companies/workspaces", token: _token);

    return await doServerCall<List<Object>>(call, handlePositiveResultBody);
  }

  Future<bool> updateWorkspace() async {
    Call call = new Call.name(CallMethod.PUT, "v1/companies/43a5af6c-315f-4ce9-bcc8-9ee30d9311c5/workspaces/97cc8908-2011-435e-b89a-132324065d0e",
        token: _token, body: utf8.decode(utf8.encode(jsonEncode(<String, dynamic>{
          'name': "Voice 2 ф",
          'description': "I can’t I can't",
          'location': "Bb",
          'type': "GENERAL",
        }))));

    return await doServerCall<bool>(call, (_){

    });
  }
}
