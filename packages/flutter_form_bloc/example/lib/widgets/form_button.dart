import 'package:flutter/material.dart';

class FormButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final EdgeInsetsGeometry padding;
  const FormButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    this.padding = const EdgeInsets.all(8.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: RaisedButton(
        onPressed: onPressed,
        child: Center(child: Text(text)),
      ),
    );
  }
}
