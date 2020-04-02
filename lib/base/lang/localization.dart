import 'dart:ui';
import '../utils/logger.dart';
import 'package:flutter/material.dart';
//import 'package:devicelocale/devicelocale.dart';

class Localization {
  static VoidCallback onLocaleChanged;
  static List<AppLocale> _supportedLocales;
  static AppLocale _defaultLocale, _currentLocale;

  static bool init(BuildContext context, List<AppLocale> locales,
      AppLocale defaultLocale) /*async*/ {
    if (_defaultLocale == null) {
      _defaultLocale = defaultLocale;
      _currentLocale = _defaultLocale;
      _supportedLocales = locales;
      return true;
    }
    return false;
//    deviceLanguageCode = await Devicelocale.currentLocale;
//            Localizations.localeOf(context).languageCode;
//    Log.d(deviceLanguageCode, "deviceLanguageCode");
  }

  static String setLocale(String code) {
    Log.d(code, "setLocale");
    bool isLocaleFound = false;

    for (var locale in _supportedLocales) {
      if (locale.languageCode == code) {
        _currentLocale = locale;
        isLocaleFound = true;
        break;
      }
    }

    if (!isLocaleFound) {
      _currentLocale = _defaultLocale; //non supported locales default to en.
    }

    Log.d(_currentLocale.languageCode, "applyed Locale");

    if (onLocaleChanged != null) {
      onLocaleChanged();
    }

    return _currentLocale.languageCode;
  }

  static get deviceLanguageCode {
    return _defaultLocale.languageCode;
  }

  static get currentLanguageCode =>
      _currentLocale?.languageCode ?? deviceLanguageCode;

  static Locale getAppLocale() {
    return Locale(_currentLocale.languageCode);
  }

  ///Use for key parameter one out of Keys class
  ///
  ///import 'package:sofia_airport/res/strings/string_keys.dart';
  static String getString(String key) {
    if (_currentLocale == null) return "";
    String textToReturn = _currentLocale.localizedStrings[key];
    if (textToReturn == null) {
      Log.e("No text for id : $key");
      textToReturn = 'no text';
    }
    return textToReturn;
  }
}

class Txt {
  ///Short call of Localization.getString(key)
  ///use live template txt for Txt.get(StrKey.$)
  static String get(String key) {
    return Localization.getString(key);
  }
}

abstract class AppLocale {
  String get languageCode;

  Map<String, String> get localizedStrings;
}
