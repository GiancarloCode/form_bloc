import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';

class Notifications {
  Notifications._();

  static void showSnackBarWithError(BuildContext context, String message,
      {Key key}) {
    Flushbar(
      messageText: Text(
        message ?? 'Sorry, an error has ocurred',
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.red[200],
      duration: Duration(seconds: 2),
    ).show(context);
  }

  static void showSnackBarWithSuccess(BuildContext context, String message,
      {Key key}) {
    Flushbar(
      messageText: Text(
        message ?? 'Success.',
        style: TextStyle(color: Colors.black87),
      ),
      backgroundColor: Colors.green[300],
      duration: Duration(seconds: 2),
    ).show(context);
  }
}
