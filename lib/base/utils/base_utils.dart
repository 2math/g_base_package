
class BaseUtils{
    static bool isEmpty(List list){
        return list == null || list.isEmpty;
    }

    static bool isNotEmpty(List list){
        return !isEmpty(list);
    }

    static bool isEmptyStr(String string){
        return string == null || string.isEmpty;
    }

    static bool isNotEmptyStr(String string){
        return !isEmptyStr(string);
    }

    ///sort ascended
    static int sort(String a, String b) {
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

    String multiSelectOptionsToString(List<String> ids, {String divider = ","}) {
      if (ids == null || ids.isEmpty) {
        return "";
      }
      return ids?.reduce((value, element) => value + divider + element);
    }

    List<String> stringToMultiSelectOptions(String value, {String divider = ","}) {
      return value?.split(divider);
    }
}