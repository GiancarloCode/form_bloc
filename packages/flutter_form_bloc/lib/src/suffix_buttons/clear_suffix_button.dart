import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/suffix_buttons/suffix_button_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/theme/suffix_button_themes.dart';
import 'package:form_bloc/form_bloc.dart';

class ClearSuffixButton extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool isEnabled;
  final bool? visibleWithoutValue;
  final Duration? appearDuration;
  final Widget? icon;

  const ClearSuffixButton({
    Key? key,
    required this.singleFieldBloc,
    this.visibleWithoutValue,
    this.appearDuration,
    this.isEnabled = true,
    this.icon,
  }) : super(key: key);

  ClearSuffixButtonTheme themeOf(BuildContext context) {
    final buttonTheme = FormTheme.of(context).clearSuffixButtonTheme;

    return ClearSuffixButtonTheme(
      visibleWithoutValue:
          visibleWithoutValue ?? buttonTheme.visibleWithoutValue ?? false,
      appearDuration:
          appearDuration ?? buttonTheme.appearDuration ?? const Duration(milliseconds: 300),
      icon: icon ?? buttonTheme.icon ?? const  Icon(Icons.clear),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonTheme = themeOf(context);

    return SuffixButtonBuilderBase(
      singleFieldBloc: singleFieldBloc,
      isEnabled: isEnabled,
      visibleWithoutValue: buttonTheme.visibleWithoutValue!,
      appearDuration: buttonTheme.appearDuration!,
      onTap: singleFieldBloc.clear,
      icon: buttonTheme.icon!,
    );
  }
}
