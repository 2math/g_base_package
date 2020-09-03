import 'package:g_base_package/base/lang/localization.dart';

import 'string_keys.dart';

///english translations, each new String must be also added to the other
///translation files and the key must be a constant
class EnUSStrings extends AppLocale {
  @override
  Map<String, String> get localizedStrings {
    return const {
      //  use str live template
      StrKey.appName: 'AssetTrax',
    };
  }

  @override
  String get languageCode => "en_US";
}
