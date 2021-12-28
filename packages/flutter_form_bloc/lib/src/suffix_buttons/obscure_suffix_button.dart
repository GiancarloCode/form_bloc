import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/suffix_buttons/suffix_button_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/theme/suffix_button_themes.dart';
import 'package:form_bloc/form_bloc.dart';

class ObscureSuffixButton extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool isEnabled;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? falseIcon;
  final Widget? trueIcon;

  const ObscureSuffixButton({
    Key? key,
    required this.singleFieldBloc,
    required this.isEnabled,
    required this.value,
    required this.onChanged,
    this.falseIcon,
    this.trueIcon,
  }) : super(key: key);

  ObscureSuffixButtonTheme themeOf(BuildContext context) {
    final buttonTheme = FormTheme.of(context).obscureSuffixButtonTheme;

    return ObscureSuffixButtonTheme(
      trueIcon:
          trueIcon ?? buttonTheme.trueIcon ?? const Icon(Icons.visibility),
      falseIcon: falseIcon ??
          buttonTheme.falseIcon ??
          const Icon(Icons.visibility_off),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonTheme = themeOf(context);

    return SuffixButtonBuilderBase(
      singleFieldBloc: singleFieldBloc,
      isEnabled: isEnabled,
      onTap: () => onChanged(!value),
      icon: value ? buttonTheme.trueIcon! : buttonTheme.falseIcon!,
    );
  }
}
