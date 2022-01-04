import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/theme/material_states.dart';
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

/// Removes the suffix from the decoration, moves the label to the right as
/// if the suffix were present and keeps the error shifted slightly to the right
class GroupInputDecorator extends StatelessWidget {
  final InputDecoration decoration;
  final Widget child;

  const GroupInputDecorator({
    Key? key,
    required this.decoration,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // Shows the shifted error of common field padding
        InputDecorator(
          decoration: decoration.copyWith(
            // Align the label with the texts of the children
            prefixIcon: const SizedBox.shrink(),
            prefix: const SizedBox.shrink(),
            contentPadding: Style.getGroupFieldBlocContentPadding(
              isVisible: false,
              decoration: decoration,
            ),
          ),
          child: Opacity(
            opacity: 0.0,
            child: child,
          ),
        ),
        InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            // Removes the prefix and the space it would occupy
            prefixIcon: const SizedBox.shrink(),
            prefix: const SizedBox.shrink(),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0.0,
              minHeight: 0.0,
              maxHeight: 0.0,
              maxWidth: 0.0,
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}
