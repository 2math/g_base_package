import 'dart:convert';

import '../utils/utils.dart';

import '../app_exception.dart';

class JsonParser {
  String parseErr(AppException exception) {
    if (exception != null && exception.data != null) {
      try {
        Map<String, dynamic> jsonData = jsonDecode(exception.data);
        if (jsonData != null && jsonData.containsKey("code")) {
          return jsonData["code"];
        }
      } catch (e) {
        Log.e("parseErr", null, e is Error ? e : AssertionError(e));
        return exception.error;
      }
    }
    return null;
  }

  void removeNulls(Map<String, dynamic> jsonMap) {
    if (jsonMap == null) {
      return;
    }

    List<String> keysToRemove = new List();

    jsonMap.forEach((k, v) {
      if (jsonMap[k] == null) {
        keysToRemove.add(k);
      }
    });

    keysToRemove.forEach((key) {
      jsonMap.remove(key);
    });
  }
}
