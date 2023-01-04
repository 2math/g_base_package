import 'dart:collection';

import 'package:collection/collection.dart';

import 'logger.dart';

class BaseUtils{
    static bool isEmpty(List? list){
        return list == null || list.isEmpty;
    }

    static bool isNotEmpty(List? list){
        return !isEmpty(list);
    }

    static bool isEmptyStr(String? string){
        return string == null || string.isEmpty;
    }

    static bool isNotEmptyStr(String? string){
        return !isEmptyStr(string);
    }

    ///sort ascended
    ///You can pass objects that has compareTo function only
    static int sort(dynamic a, dynamic b) {
      if (a == null && b == null) {
        return 0;
      }

      if (a == null) {
        return 1;
      }

      if (b == null) {
        return -1;
      }

      return a.compareTo(b);
    }

    ///natural = true => "a", "a0", "a0b", "a1", "a01", "a9", "a10", "a100", "
    ///a100b", "aa"
    int sortString(String? a, String? b, {bool natural = false}) {
      if (a == null && b == null) {
        return 0;
      }

      if (a == null) {
        return 1;
      }

      if (b == null) {
        return -1;
      }

      if (natural) {
        return compareNatural(a, b);
      }
      return a.compareTo(b);
    }

    ///sort ascended
    static int sortBool(bool? a, bool? b) {
      if (a == null && b == null) {
        return 0;
      }

      if (a == null) {
        return 1;
      }

      if (b == null) {
        return -1;
      }

      return a && b ? 0 : a ? -1 : 1;
    }

    String multiSelectOptionsToString(List<String>? ids, {String? divider = ","}) {
      if (ids == null || ids.isEmpty) {
        return "";
      }
      return ids.reduce((value, element) => value + divider! + element);
    }

    List<String> stringToMultiSelectOptions(String value, {String? divider = ","}) {
      return value.split(divider!);
    }

    //replace all symbols that are not numbers and +
    String? clearPhone(String? phone) {
      if (phone != null) {
        return phone.replaceAll(RegExp(r'[^0-9+]'), "");
      }

      return phone;
    }

    static double? getDouble(String? string) {
      if (string == null) return null;
      double? doubleNumber;
      try {
        doubleNumber = double.parse(string.replaceAll(",", "."));
      } on FormatException {
        Log.d("can't parse $string");
      }
      return doubleNumber;
    }

    static bool isValidDouble(String? text) {
      return text != null && double.tryParse(text.replaceAll(",", ".")) != null;
    }

    LinkedHashMap<K?, V?> sortMapByKeys<K, V>(Map temp, {bool isAcs = true}) {
      var sortedKeys = temp.keys.toList(growable: false)..sort((k1, k2) => isAcs ? k1.compareTo(k2) : k2.compareTo(k1));

      LinkedHashMap<K?, V?> sortedMap = new LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => temp[k]);

      return sortedMap;
    }

    LinkedHashMap<K?, V?> sortMapByValues<K, V>(Map temp, {bool isAcs = true}) {
      var sortedKeys = temp.keys.toList(growable: false)
        ..sort((k1, k2) => isAcs ? temp[k1].compareTo(temp[k2]) : temp[k2].compareTo(temp[k1]));

      LinkedHashMap<K?, V?> sortedMap = new LinkedHashMap.fromIterable(sortedKeys, key: (k) => k, value: (k) => temp[k]);

      return sortedMap;
    }
}