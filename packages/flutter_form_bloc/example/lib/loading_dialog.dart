import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
              width: 80,
              height: 80,
              padding: EdgeInsets.all(12.0),
              child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => LoadingDialog(),
    );
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
