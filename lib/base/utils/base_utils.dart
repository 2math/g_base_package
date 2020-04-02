
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
}