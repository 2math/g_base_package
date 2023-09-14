import 'dart:io';

import '../flavor_config.dart';
import '../lang/localization.dart';
import '../provider/instance_provider.dart';
import '../net/json_parser.dart';
import '../utils/utils.dart';
import '../app_exception.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Create AppBaseState for each app where K should be App Repository class, which was init on App
/// create
abstract class BaseState<T extends StatefulWidget, K, P> extends State<T> {
  K? remoteRepository;
  P? localRepository;
  AlertDialog? progressDialog;

  String get tag;

  ///this getter is for consistence with older versions
  @Deprecated('This getter is for consistence with older versions. Use remoteRepository or localRepository')
  K? get repository => remoteRepository;

  @override
  void initState() {
    super.initState();

    Log.d("init state", tag);

    InstanceProvider.getInstance()?.analyticsUtil?.logCurrentScreen(tag);

    remoteRepository = InstanceProvider.getInstance()?.provideRepository();
    localRepository = InstanceProvider.getInstance()?.provideLocalRepository();
  }

  // @override
  // @mustCallSuper
  // // ignore: missing_return
  // Widget build(BuildContext context) {
  //   if (SizeConfig().init(context)) {
  //     Log.d(SizeConfig().toString());
  //   }
  // }

  bool canShowProgressDialog() {
    return progressDialog == null;
  }

  bool showProgressIndicatorIfNotShowing({String? msgKey, String? text}) {
    if (canShowProgressDialog()) {
      showProgressIndicator(msgKey: msgKey, text: text);
      return true;
    }

    return false;
  }

  showProgressIndicator({String? msgKey, String? text}) {
    if (progressDialog == null || msgKey != null) {
      String message;
      if (msgKey != null) {
        message = Txt.get(msgKey);
      } else if (text != null) {
        message = text;
      } else if (FlavorConfig.instance!.msgLoadingKey != null) {
        message = Txt.get(FlavorConfig.instance!.msgLoadingKey);
      } else {
        message = 'Loading...';
      }
      progressDialog = Dialogs.createProgressDialog(null, message);
    }
    Dialogs.showProgressDialog(context, progressDialog!);
  }

  hideProgressIndicator() {
    if (progressDialog != null) {
      Navigator.of(context, rootNavigator: true).pop();
      progressDialog = null;
    }
  }

  ///pass focus from one field to another
  fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void showError(e,
      {BuildContext? buildContext,
      Color? bkgColor,
      TextStyle? textStyle,
      double marginBottom = 0,
      Duration? duration,
      String? closeAction,
      Color? closeActionColor,
      SnackBarAction? action}) {
    hideProgressIndicator();
//    Log.e("login_screen", "$e");
    var msg = getErrorMessage(e)!;
    Log.e(msg);

    Dialogs.showSnackBar(
      buildContext ?? context,
      msg,
      bkgColor: bkgColor,
      textStyle: textStyle,
      duration: duration,
      marginBottom: marginBottom,
      closeAction: closeAction,
      closeActionColor: closeActionColor,
      action: action,
    );
  }

  void showInfoMessage(String msg,
      {BuildContext? buildContext,
      TextStyle? textStyle,
      Color? bkgColor,
      double marginBottom = 0,
      Duration? duration,
      String? closeAction,
      Color? closeActionColor,
      SnackBarAction? action}) {
//    Log.e("login_screen", "$e");
    Dialogs.showSnackBar(
      buildContext ?? context,
      msg,
      bkgColor: bkgColor,
      textStyle: textStyle,
      duration: duration,
      marginBottom: marginBottom,
      closeAction: closeAction,
      closeActionColor: closeActionColor,
      action: action,
    );
  }

  String? getErrorMessage(error, {String? defaultMessage}) {
    if (error is AppException) {
      switch (error.code) {
        case 400:
          String? serverCode = JsonParser().parseErr(error);
          if (serverCode != null &&
              serverCode == AppException.UNSUPPORTED_VERSION &&
              FlavorConfig.instance!.unsupportedVersionKey != null) {
            return Txt.get(FlavorConfig.instance!.unsupportedVersionKey);
          }
          break;
        case 401:
          if (FlavorConfig.instance!.unauthorizedKey != null) {
            return Txt.get(FlavorConfig.instance!.unauthorizedKey);
          }
          break;
        case 403:
          if (FlavorConfig.instance!.forbiddenKey != null) {
            return Txt.get(FlavorConfig.instance!.forbiddenKey);
          }
          break;
        case 404:
          if (FlavorConfig.instance!.notFoundKey != null) {
            return Txt.get(FlavorConfig.instance!.notFoundKey);
          }
          break;
        case 500:
          if (FlavorConfig.instance!.serverErrorKey != null) {
            return Txt.get(FlavorConfig.instance!.serverErrorKey);
          }
          break;
        case AppException.OFFLINE_ERROR:
          if (FlavorConfig.instance!.noNetworkKey != null) {
            return Txt.get(FlavorConfig.instance!.noNetworkKey);
          }
          break;
      }

      if (!Validator.isEmpty(defaultMessage)) {
        return defaultMessage;
      }
      return error.data is String && BaseUtils.isNotEmptyStr(error.data as String?)
          ? error.data as String?
          : error.error;
    } else if (error is SocketException) {
      if (FlavorConfig.instance!.socketExceptionKey != null) {
        return Txt.get(FlavorConfig.instance!.socketExceptionKey);
      }

      if (FlavorConfig.instance!.noNetworkKey != null) {
        return Txt.get(FlavorConfig.instance!.noNetworkKey);
      }
    }

    return "$error";
  }

  void removeCurrentFocus(BuildContext context, {bool ignorePrimaryFocus = true}) {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!ignorePrimaryFocus || !currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  ///use this method only if removeCurrentFocus does not work
  void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
