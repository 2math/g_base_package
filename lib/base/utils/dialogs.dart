import 'package:flutter/material.dart';

import 'dart:async';

class Dialogs {
  static Future<Null> showErrorMessage(
      BuildContext context, String errorTitle, String errorMessage) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return new AlertDialog(
            title: new Text(errorTitle), content: Text(errorMessage));
      },
    );
  }

  static Future<Null> showProgressDialog(
      BuildContext context, AlertDialog alertDialog) async {
    return showDialog<Null>(
      context: context,
      barrierDismissible: false, //cancelable false
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false, //prevent back btn
            child: alertDialog);
      },
    );
  }

  static AlertDialog createProgressDialog(String title, String message) {
    return new AlertDialog(
        title: title != null ? new Text(title) : null,
        content: new Row(
          children: <Widget>[
            new CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: new Text(message),
            ),
          ],
        ));
  }

  static showSnackBar(BuildContext context, String msg, {Color bkgColor}) {
    final snackBar = SnackBar(content: Text(msg), backgroundColor: bkgColor,);

// Find the Scaffold in the Widget tree and use it to show a SnackBar
    ScaffoldState scaffoldState = Scaffold.of(context, nullOk: true);
    if (scaffoldState != null) {
      scaffoldState.removeCurrentSnackBar();
      scaffoldState.showSnackBar(snackBar);
    } else {
      //fallback to popup
      showDialog<Null>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return new AlertDialog(content: Text(msg));
        },
      );
    }
  }
}
