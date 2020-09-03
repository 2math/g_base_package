import 'package:g_base_package/base/lang/localization.dart';

import '../string_keys.dart';

///english translations, each new String must be also added to the other
///translation files and the key must be a constant
class EnUSGlobalStrings extends AppLocale {
  @override
  Map<String, String> get localizedStrings {
    return const {
      //  use str live template
      StrKey.mainTitle: 'Home',
      StrKey.msgLoading: 'Loading...',
      StrKey.unauthorized: 'Unauthorized',
      StrKey.forbidden: 'Forbidden',
      StrKey.notFound: 'Not Found',
      StrKey.unsupportedVersion: 'Unsupported Version Please Update!',
      StrKey.noNetwork: 'No Network',
      StrKey.serverError: 'Server Error',
      StrKey.confirmAction: 'Please confirm action',
      StrKey.btnCancel: 'Cancel',
      StrKey.btnOK: 'OK',

      //Welcome screen
      StrKey.btnLogin: "Login",
      StrKey.lblEmail: 'Email',
      StrKey.hintEmail: 'Enter your email',
      StrKey.errEmail: 'Please enter a valid email',
      StrKey.lblPass: 'Password',
      StrKey.hintPass: 'Enter your password',
      StrKey.errPass: 'Minimum 6 symbols',
      StrKey.errCreds: 'Invalid credentials',
      StrKey.smlLogo: 'Company logo',
      StrKey.forgotPassword: 'Forgot Password',
      StrKey.loginError: 'Login Error',

    };
  }

  @override
  String get languageCode => "en_US";
}
