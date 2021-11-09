import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/theme/material_states.dart';

/// Resolves looking for the appropriate value to use in the widget
class FieldThemeResolver {
  final ThemeData theme;
  final FormTheme formTheme;
  final FieldTheme? fieldTheme;

  const FieldThemeResolver(this.theme, this.formTheme, [this.fieldTheme]);

  InputDecorationTheme get decorationTheme {
    return fieldTheme?.decorationTheme ?? formTheme.decorationTheme ?? theme.inputDecorationTheme;
  }

  TextStyle get textStyle {
    return fieldTheme?.textStyle ?? formTheme.textStyle ?? theme.textTheme.subtitle1!;
  }

  MaterialStateProperty<Color?> get textColor {
    return fieldTheme?.textColor ??
        formTheme.textColor ??
        SimpleMaterialStateProperty(
          normal: theme.textTheme.subtitle1!.color,
          disabled: theme.disabledColor,
        );
  }
}

/// Represents the basic theme for a field
class FieldTheme {
  /// Represents the style of the text within the field
  /// If null, defaults to the `subtitle` text style from the current [Theme].
  final TextStyle? textStyle;

  /// Resolves the color of the [textStyle].
  /// You will receive [MaterialState.disabled]
  final MaterialStateProperty<Color?>? textColor;

  /// The theme for InputDecoration of this field
  final InputDecorationTheme? decorationTheme;

  const FieldTheme({
    this.textStyle,
    this.textColor,
    this.decorationTheme,
  });
}
