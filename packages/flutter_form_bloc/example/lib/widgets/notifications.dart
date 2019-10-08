import 'package:flutter/material.dart';

class Notifications {
  Notifications._();

  static void showSnackBarWithError(BuildContext context, String message,
      {Key key}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: key,
        backgroundColor: Colors.red[200],
        content: Text('${message ?? 'Sorry, an error has ocurred.'}'),
      ),
    );
  }

  static void showSnackBarWithSuccess(BuildContext context, String message,
      {Key key}) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        key: key,
        backgroundColor: Colors.green[300],
        content: Text('${message ?? 'Success.'}'),
      ),
    );
  }
}
