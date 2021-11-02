// import 'package:test/test.dart';

enum Validation { NotChecked, Valid, Invalid }

class Validator {
  static bool isEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(email);
  }

  ///if you don't specify pattern that one is in use : r'^(?:[+0]9)?[0-9]{10}$'
  static bool isPhone(String phone, {String? pattern}) {
    return RegExp(pattern == null ? r'^(?:[+0]9)?[0-9]{10}$' : pattern).hasMatch(phone);
  }

  static bool isValidLength(String pass, int length) {
    return pass != null && pass.length >= length;
  }

  static bool confirmPass(String pass, String confirmPass) {
    return pass != null && confirmPass != null && pass == confirmPass;
  }

  static bool isEmpty(String? text) {
    return text == null || text.trim() == "";
  }

  static bool isEmptyList(List list) {
    return list == null || list.length == 0;
  }

  static bool isLink(String input) {
    final matcher = new RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.hasMatch(input);
  }
}

// void main() {
//   test("confirmPass", () {
//     expect(true, Validator.confirmPass("pass", "pass"));
//   });
// }
