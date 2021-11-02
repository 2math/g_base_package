import 'dart:ui';
import 'package:g_base_package/base/utils/base_utils.dart';

import '../utils/logger.dart';
import 'package:flutter/material.dart';
//import 'package:devicelocale/devicelocale.dart';

class Localization {
  static VoidCallback? onLocaleChanged;
  static List<AppLocale>? _supportedLocales, _globalLocales;
  static AppLocale? _defaultLocale, _currentLocale, _currentGlobalLocale;

  ///support to have locales per flavors, each flavor has its custom strings in "locales" and
  ///similar strings are added in "globalLocales". This way if you have 2 flavors that has differences
  ///only in appName and a few other strings those will be in "locales", while all other will be in "globalLocales".
  ///This is better for translation and adding new Strings in multi flavor apps. When the app searches
  ///for a String will check first in "locales" and if is not there will check in "globalLocales".
  ///
  ///If your app does not care about multi flavors, can omit the "globalLocales" and send it's "locales" only
  static bool init(BuildContext? context, List<AppLocale> locales, AppLocale
  defaultLocale,
      {List<AppLocale>? globalLocales})
  /*async*/ {
    if (_defaultLocale == null) {
      _defaultLocale = defaultLocale;
      _currentLocale = _defaultLocale;
      _supportedLocales = locales;
      _globalLocales = globalLocales;
      _selectCurrentGlobalLocale();
      return true;
    }
    return false;
//    deviceLanguageCode = await Devicelocale.currentLocale;
//            Localizations.localeOf(context).languageCode;
//    Log.d(deviceLanguageCode, "deviceLanguageCode");
  }

  static String? setLocale(String code) {
    Log.d(code, "setLocale");

    if (BaseUtils.isEmpty(_supportedLocales)) return _currentLocale?.languageCode;

    bool isLocaleFound = false;

    for (var locale in _supportedLocales!) {
      if (locale.languageCode == code) {
        _currentLocale = locale;
        isLocaleFound = true;
        break;
      }
    }

    if (!isLocaleFound) {
      _currentLocale = _defaultLocale; //non supported locales default to en.
    }

    Log.d(_currentLocale!.languageCode, "applied Locale");

    _selectCurrentGlobalLocale();

    if (onLocaleChanged != null) {
      onLocaleChanged!();
    }

    return _currentLocale!.languageCode;
  }

  static get deviceLanguageCode {
    return _defaultLocale?.languageCode;
  }

  static get currentLanguageCode => _currentLocale?.languageCode ?? deviceLanguageCode;

  static Locale getAppLocale() {
    return Locale(_currentLocale!.languageCode);
  }

  ///Use for key parameter one out of Keys class
  ///
  ///import 'package:sofia_airport/res/strings/string_keys.dart';
  static String getString(String? key) {
    if (_currentLocale == null && _currentGlobalLocale == null) return "no locale";

    String? textToReturn = _currentLocale?.localizedStrings != null ? _currentLocale!.localizedStrings[key!] : null;

    if (textToReturn == null && _currentGlobalLocale?.localizedStrings != null) {
      textToReturn = _currentGlobalLocale?.localizedStrings[key!];
    }

    if (textToReturn == null) {
      Log.e("No text for id : $key");
      textToReturn = 'no text';
    }
    return textToReturn;
  }

  static void _selectCurrentGlobalLocale() {
    if (BaseUtils.isNotEmpty(_globalLocales) && _currentLocale != null) {
      for (final locale in _globalLocales!) {
        if (locale.languageCode == _currentLocale!.languageCode) {
          _currentGlobalLocale = locale;
          break;
        }
      }
    }
  }
}

class Txt {
  ///Short call of Localization.getString(key)
  ///use live template txt for Txt.get(StrKey.$)
  static String get(String? key) {
    return Localization.getString(key);
  }
}

abstract class AppLocale {
  String get languageCode;

  Map<String, String> get localizedStrings;
}
