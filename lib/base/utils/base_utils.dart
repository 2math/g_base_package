import 'package:collection/collection.dart';

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
}