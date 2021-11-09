import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';

class DefaultFieldBlocBuilderTextStyle extends StatelessWidget {
  final bool isEnabled;
  final TextStyle? style;
  final Widget child;

  const DefaultFieldBlocBuilderTextStyle({
    Key? key,
    required this.isEnabled,
    this.style,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formStyle = FormTheme.of(context);

    return DefaultTextStyle(
      style: Style.resolveTextStyle(
        isEnabled: isEnabled,
        style: style ?? formStyle.textStyle ?? theme.textTheme.subtitle1!,
        color: formStyle.textColor ??
            SimpleMaterialStateProperty(
              normal: theme.textTheme.subtitle1!.color,
              disabled: theme.disabledColor,
            ),
      ),
      child: child,
    );
  }
}

class DefaultFieldBlocBuilderPadding extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Widget child;

  const DefaultFieldBlocBuilderPadding({
    Key? key,
    required this.padding,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? FormTheme.of(context).padding ?? FormTheme.defaultPadding,
      child: child,
    );
  }
}
