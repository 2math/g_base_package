import 'package:g_base_package/base/lang/localization.dart';

import 'string_keys.dart';

class BgStrings extends AppLocale {
  @override
  Map<String, String> get localizedStrings {
    return const {
      StrKey.appName: 'AssetTraxBG',
    };
  }

  @override
  String get languageCode => "bg";
}
