import 'package:flutter/material.dart';

extension BaseColor on Color {
    /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
    static Color fromHex(String hexString) {
        final buffer = StringBuffer();
        if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
        buffer.write(hexString.replaceFirst('#', ''));
        return Color(int.parse(buffer.toString(), radix: 16));
    }

    /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
    String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
            '${alpha.toRadixString(16).padLeft(2, '0')}'
            '${red.toRadixString(16).padLeft(2, '0')}'
            '${green.toRadixString(16).padLeft(2, '0')}'
            '${blue.toRadixString(16).padLeft(2, '0')}';
}

extension BaseString on String? {
  ///Returns true if the String is null or empty.
  ///If you set parameter [withTrim] to TRUE, will trim the
  ///string before to check if is empty.
  ///This way you can detect as empty string values as '    ', which when [withTrim]
  ///is false(by default) the function will return false as non empty string.
  bool isNullOrEmpty({bool withTrim = false}) => this == null || (withTrim ? this!.trim().isEmpty : this!.isEmpty);

  ///Returns true if the String is not null or empty.
  ///If you set parameter [withTrim] to TRUE, will trim the
  ///string before to check if is empty.
  ///This way you can detect as empty string values as '    ', which when [withTrim]
  ///is false(by default) the function will return TRUE as non empty string.
  bool isNotNullOrEmpty({bool withTrim = false}) =>
      this != null && (withTrim ? this!.trim().isNotEmpty : this!.isNotEmpty);

  ///Replace all symbols that are not numbers and plus.
  ///
  ///If you have a string as +359/888 666-555, this
  ///function will change the string to +359888666555.
  clearForPhone() {
    if (this != null) {
      this!.replaceAll(RegExp(r'[^0-9+]'), "");
    }
  }

  ///Validate if the string is an email.
  bool isEmail() {
    if (this == null) return false;

    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(pattern);

    return regExp.hasMatch(this!);
  }

  ///Validate if a string is long enough. Useful for password length check.
  bool isValidLength(int length) {
    return this != null && this!.length >= length;
  }

  ///Validates if 2 strings are equal. Useful for comparison of 2 passwords.
  ///Will return TRUE only if both strings are not null and equal.
  bool confirmSame(String? confirmString) {
    return this != null && confirmString != null && this == confirmString;
  }

  ///Validates if the string is a valid url.
  bool isLink() {
    if (this == null) return false;

    final matcher =
    RegExp(r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");

    return matcher.hasMatch(this!);
  }
}

extension BaseList on List? {
  ///Returns true if the List is null or empty.
  bool isNullOrEmpty() => this == null || this!.isEmpty;

  ///Returns true if the List is not null or empty.
  bool isNotNullOrEmpty() => this != null && this!.isNotEmpty;
}