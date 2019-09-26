import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';

class DefaultFieldBlocBuilderTextStyle extends StatelessWidget {
  final bool isEnabled;
  final Widget child;

  const DefaultFieldBlocBuilderTextStyle({
    Key key,
    @required this.isEnabled,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Style.getDefaultTextStyle(
        context: context,
        isEnabled: isEnabled,
      ),
      child: child,
    );
  }
}

class DefaultFieldBlocBuilderPadding extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const DefaultFieldBlocBuilderPadding({
    Key key,
    @required this.padding,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? Style.defaultPadding,
      child: child,
    );
  }
}
