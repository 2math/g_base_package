import 'package:g_base_package/base/lang/localization.dart';

import 'string_keys.dart';

class BgStrings extends AppLocale {
  @override
  Map<String, String> get localizedStrings {
    return const {
      StrKey.mainTitle: 'Начало',
      StrKey.msgLoading: 'Зарежда...',
      StrKey.unauthorized: 'Неупълномощен',
      StrKey.unsupportedVersion: 'Стара версия моля обновете!',
      StrKey.noNetwork: 'Няма връзка',
      StrKey.serverError: 'Грешка от сървъра',

      //Welcome screen
      StrKey.btnLogin: "Логин",
      StrKey.lblEmail: 'Имейл',
      StrKey.hintEmail: 'Въведете имейл',
      StrKey.errEmail: 'Въведете правилен имейл',
      StrKey.lblPass: 'Парола',
      StrKey.hintPass: 'Въведете парола',
      StrKey.errPass: 'Миниму 6 символа',
      StrKey.errCreds: 'Невалидни данни',
      StrKey.smlLogo: 'Лого на компанията',
      StrKey.forgotPassword: 'Забравена Парола',
      StrKey.loginError: 'Грешка при логин',
    };
  }

  @override
  String get languageCode => "bg";
}
