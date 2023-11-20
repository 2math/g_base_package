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
      {List<AppLocale>? globalLocales, bool force = false})
  /*async*/ {
    if (force || _defaultLocale == null) {
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

  ///This one works only if you have set a list of supported Locales and to pick one of them.
  ///If the language code is not for one of the locales, current language remains.
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

  ///It checks current device locale and compares it with [supportedAppLocales] by exact match, by language and script
  ///or by language code only. If no one matches, the [defaultLocale] is returned.
  ///
  /// It is usually called on app start before to call [Localization.init].
  ///
  /// If you provide [forceLocaleCode] then the locale in [supportedAppLocales] with this code will be returned.
  /// If dose not exist in [supportedAppLocales], then [defaultLocale] will be returned. This is helpful if
  /// the app is saving the locale code of selected language and on restart wants to use that language instead of
  /// device language.
  static Future<AppLocale> findDeviceLocale(List<AppLocale> supportedAppLocales, AppLocale defaultLocale,
      {String? forceLocaleCode}) async {
    if(forceLocaleCode != null){
      for (int i = 0; i < supportedAppLocales.length; i++) {
        if (supportedAppLocales[i].languageCode == forceLocaleCode) {
          //we have found our locale
          Log.d("Set locale : ${supportedAppLocales[i].languageCode}");
          return supportedAppLocales[i];
        }
      }

      //If we are here, then "setLocale" code was provided but not found in supportedAppLocales.
      //Then we return the defaultLocale.
      return defaultLocale;
    }

    // Get the list of locales that the user has defined in the system settings. First is the current app language
    final List<Locale> systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    Log.w('systemLocales : $systemLocales');

    //We will go trough all system locales(start from system default) and try to find a match with our supported
    //languages. First we check by exact match language and country and if nothing is found we check
    //by language and script, if still nothing we check just by language code.
    //If we can not find by language code only then the EN(default) language is selected
    for (int k = 0; k < systemLocales.length; k++) {
      AppLocale? foundLocale = findLocale(supportedAppLocales, systemLocales[k]);
      if(foundLocale != null) return foundLocale;
    }

    //We couldn't find any of our supported languages to match with the devices languages.
    //In that case we set EN
    Log.d("Set default locale : ${defaultLocale.languageCode}");
    return defaultLocale;
  }

  static AppLocale? findLocale(List<AppLocale> supportedAppLocales, Locale locale) {
    for (int i = 0; i < supportedAppLocales.length; i++) {
      if (supportedAppLocales[i].languageCode == locale.toString()) {
        //we have found our exact locale by exact match language and (~script + ~country). Lets set it
        Log.d("Set locale : ${supportedAppLocales[i].languageCode}");
        return supportedAppLocales[i];
      }
    }

    //If we are here the defaultSystemLocale was not found, lets try by language and script only and ignore the
    //country(region)
    //If our device is zh_Hans_CN, then we should load zh_Hans_US
    for (int i = 0; i < supportedAppLocales.length; i++) {
      List<String> parts = supportedAppLocales[i].languageCode.split('_');
      //If parts.length == 2 we have just language and region and should skip this check.
      //Same if the system locale has no scriptCode
      if (parts.length > 2 &&
          locale.scriptCode?.isNotEmpty == true &&
          '${parts[0]}_${parts[1]}' == '${locale.languageCode}_${locale.scriptCode}') {
        //we have found our locale by language and script only. Lets set it
        Log.d("Set locale by language and script : ${supportedAppLocales[i].languageCode}");
        return supportedAppLocales[i];
      }
    }

    //If we are here the defaultSystemLocale was not found, lets try by language only
    //If our device is se_Fi, then we should load se_Se
    for (int i = 0; i < supportedAppLocales.length; i++) {
      if (supportedAppLocales[i].languageCode.split('_')[0] == locale.languageCode) {
        //we have found our locale by language only. Lets set it
        Log.d("Set locale by language : ${supportedAppLocales[i].languageCode}");
        return supportedAppLocales[i];
      }
    }

    return null;
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
