import 'package:flutter/material.dart';
import 'package:g_base_package/base/app_exception.dart';

import 'dart:async';

import 'package:g_base_package/base/utils/versions.dart';

import 'logger.dart';

class Dialogs {
  static Future<void> showErrorMessage(BuildContext context, String errorTitle, String errorMessage) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(title: new Text(errorTitle), content: Text(errorMessage));
      },
    );
  }

  ///if you want any of the widgets missing pass null, one of both button should be non-null though, otherwise will
  ///throw and exception.
  ///Will return Version.UPDATE_AVAILABLE if btnSkip was clicked or Version.UPDATE_REQUIRED if btnGoToStore
  ///was clicked
  static Future<int?> showVersions(
      BuildContext context, Widget? title, Widget message, Widget? btnSkip, Widget? btnGoToStore) async {
    if (btnGoToStore == null && btnSkip == null) {
      throw AppException(errorMessage: "please provide atleast one button");
    }
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, //prevent back btn
          child: AlertDialog(
            title: title,
            content: message,
            actions: <Widget>[
              btnSkip != null
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(Version.UPDATE_AVAILABLE);
                      },
                      child: btnSkip,
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
              btnGoToStore != null
                  ? TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(Version.UPDATE_REQUIRED);
                      },
                      child: btnGoToStore,
                    )
                  : const SizedBox(
                      width: 0,
                      height: 0,
                    ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> showProgressDialog(BuildContext context, AlertDialog alertDialog) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //cancelable false
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false, //prevent back btn
            child: alertDialog);
      },
    );
  }

  static AlertDialog createProgressDialog(String? title, String message, {TextStyle? textStyle}) {
    return new AlertDialog(
        title: title != null ? new Text(title) : null,
        content: new Row(
          children: <Widget>[
            const CircularProgressIndicator(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: new Text(message, softWrap: true, style: textStyle),
              ),
            ),
          ],
        ));
  }

  static showSnackBar(BuildContext context, String msg,
      {TextStyle? textStyle,
      Color? bkgColor,
      double marginBottom = 0,
      Duration? duration,
      String? closeAction,
      Color? closeActionColor,
      SnackBarAction? action}) {
    SnackBarAction? snackBarAction = _getAction(action, closeAction, closeActionColor);
    final snackBar = (marginBottom == 0)
        ? SnackBar(
            content: Text(msg, style: textStyle),
            backgroundColor: bkgColor,
            duration: duration ?? const Duration(milliseconds: 4000),
            action: snackBarAction,
          )
        : SnackBar(
            content: Container(
              child: Padding(
                padding: snackBarAction != null
                    ? const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0)
                    : const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Text(msg, style: textStyle)),
                    snackBarAction ?? const SizedBox(width: 0, height: 0),
                  ],
                ),
              ),
              margin: EdgeInsets.fromLTRB(0, 0, 0, marginBottom),
              decoration: BoxDecoration(
                color: bkgColor ?? Theme.of(context).snackBarTheme.backgroundColor,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            backgroundColor: Colors.transparent,
            duration: duration ?? const Duration(milliseconds: 4000),
            elevation: 0,
            behavior: SnackBarBehavior.floating,
          );

// Find the Scaffold in the Widget tree and use it to show a SnackBar
    ScaffoldMessengerState? scaffoldState;

    try {
      // scaffoldState = Scaffold.of(context);
      scaffoldState = ScaffoldMessenger.of(context);
    } catch (e) {
      Log.error('Wrong context?', error: e);
    }

    if (scaffoldState != null) {
      scaffoldState.removeCurrentSnackBar();
      scaffoldState.showSnackBar(snackBar);
    } else {
      //fallback to popup
      showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(content: Text(msg));
        },
      );
    }
  }

  static SnackBarAction? _getAction(SnackBarAction? action, String? closeAction, Color? closeActionColor) {
    return action ??
        (closeAction != null
            ? SnackBarAction(
                label: closeAction,
                textColor: closeActionColor ?? Colors.white,
                onPressed: () {
                  //this is no need , because is handled by the snackbar
                  // ScaffoldState scaffoldState = Scaffold.of(context, nullOk: true);
                  // if (scaffoldState != null) {
                  //   scaffoldState.hideCurrentSnackBar(reason:SnackBarClosedReason.action);
                  // }
                },
              )
            : null);
  }
}
