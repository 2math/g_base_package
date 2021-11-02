import 'dart:convert';

import '../utils/utils.dart';

import '../app_exception.dart';

class JsonParser {
  String? parseErr(AppException? exception) {
    if (exception != null && exception.data != null) {
      try {
        Map<String, dynamic>? jsonData = jsonDecode(exception.data as String);
        if (jsonData != null && jsonData.containsKey("code")) {
          return jsonData["code"];
        }
      } catch (e) {
        Log.error("parseErr $exception", error: e);
        return exception.error;
      }
    }
    return null;
  }

  void removeNulls(Map<String, dynamic>? jsonMap) {
    if (jsonMap == null) {
      return;
    }

    List<String> keysToRemove = [];

    jsonMap.forEach((k, v) {
      if (jsonMap[k] == null) {
        keysToRemove.add(k);
      }
    });

    for (var key in keysToRemove) {
      jsonMap.remove(key);
    }
  }
}
