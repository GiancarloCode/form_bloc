import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme_provider.dart';
import 'package:flutter_form_bloc/src/utils/field_bloc_builder_control_affinity.dart';

class FormTheme {
  /// If [FieldTheme.textStyle] is null this value is used
  final TextStyle? textStyle;

  /// If [FieldTheme.textColor] is null this value is used
  final MaterialStateProperty<Color?>? textColor;

  /// If [FieldTheme.decorationTheme] is null this value is used
  final InputDecorationTheme? decorationTheme;

  /// Defaults [defaultPadding]
  final EdgeInsetsGeometry? padding;

  /// The theme of [CheckboxFieldBlocBuilder] and [CheckboxGroupFieldBlocBuilder]
  final CheckboxFieldTheme checkboxTheme;

  /// The theme of [DateTimeFieldBlocBuilder]
  final DateTimeFieldTheme dateTimeTheme;

  /// The theme of [DropdownFieldBlocBuilder]
  final DropdownFieldTheme dropdownTheme;

  /// The theme of [SwitchFieldBlocBuilder]
  final SwitchFieldTheme switchTheme;

  /// the theme of [RadioButtonGroupFieldBlocBuilder]
  final RadioFieldTheme radioTheme;

  /// The theme of [TextFieldBlocBuilder]
  final TextFieldTheme textTheme;

  /// Returns `EdgeInsets.symmetric(vertical: 8.0)`.
  static EdgeInsets defaultPadding = const EdgeInsets.symmetric(vertical: 8.0);

  const FormTheme({
    this.textStyle,
    this.textColor,
    this.decorationTheme,
    this.padding,
    this.checkboxTheme = const CheckboxFieldTheme(),
    this.dateTimeTheme = const DateTimeFieldTheme(),
    this.dropdownTheme = const DropdownFieldTheme(),
    this.switchTheme = const SwitchFieldTheme(),
    this.radioTheme = const RadioFieldTheme(),
    this.textTheme = const TextFieldTheme(),
  });

  static FormTheme of(BuildContext context) {
    return FormThemeProvider.of(context) ?? const FormTheme();
  }

  FormTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    EdgeInsetsGeometry? padding,
    CheckboxFieldTheme? checkboxTheme,
    DropdownFieldTheme? dropdownTheme,
    RadioFieldTheme? radioTheme,
    SwitchFieldTheme? switchTheme,
    TextFieldTheme? textTheme,
  }) {
    return FormTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      padding: padding ?? this.padding,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      dropdownTheme: dropdownTheme ?? this.dropdownTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      textTheme: textTheme ?? this.textTheme,
    );
  }
}

/// The theme of [CheckboxFieldBlocBuilder] and [CheckboxGroupFieldBlocBuilder]
class CheckboxFieldTheme extends FieldTheme {
  /// The [Checkbox] theme inside the field
  final CheckboxThemeData? checkboxTheme;

  /// The position of the [Checkbox] inside the field
  final FieldBlocBuilderControlAffinity? controlAffinity;

  const CheckboxFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.checkboxTheme,
    this.controlAffinity,
  }) : super(
          textStyle: textStyle,
          textColor: textColor,
          decorationTheme: decorationTheme,
        );

  CheckboxFieldTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    CheckboxThemeData? checkboxTheme,
    FieldBlocBuilderControlAffinity? controlAffinity,
  }) {
    return CheckboxFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      controlAffinity: controlAffinity ?? this.controlAffinity,
    );
  }
}

/// The theme of [DateTimeFieldBlocBuilder]
class DateTimeFieldTheme extends FieldTheme {
  /// The position of the text within the field
  final TextAlign? textAlign;
  final bool? showClearIcon;
  final Widget? clearIcon;

  const DateTimeFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.textAlign,
    this.showClearIcon,
    this.clearIcon,
  }) : super(
          textStyle: textStyle,
          textColor: textColor,
          decorationTheme: decorationTheme,
        );

  DateTimeFieldTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    bool? showClearIcon,
    Widget? clearIcon,
    TextAlign? textAlign,
  }) {
    return DateTimeFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      clearIcon: clearIcon ?? this.clearIcon,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      textAlign: textAlign ?? this.textAlign,
    );
  }
}

/// The theme of [DropdownFieldBlocBuilder]
class DropdownFieldTheme extends FieldTheme {
  /// Defaults is [Icons.arrow_drop_down]
  final Widget? moreIcon;

  const DropdownFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.moreIcon,
  }) : super(
          textStyle: textStyle,
          textColor: textColor,
          decorationTheme: decorationTheme,
        );

  DropdownFieldTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    Widget? moreIcon,
  }) {
    return DropdownFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      moreIcon: moreIcon ?? this.moreIcon,
    );
  }
}

/// Theme of [SwitchFieldBlocBuilder]
class SwitchFieldTheme extends FieldTheme {
  /// The [Switch] theme inside the field
  final SwitchThemeData? switchTheme;

  /// The position of the [Switch] inside the field
  final FieldBlocBuilderControlAffinity? controlAffinity;

  const SwitchFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.switchTheme,
    this.controlAffinity,
  }) : super(
          textStyle: textStyle,
          textColor: textColor,
          decorationTheme: decorationTheme,
        );

  SwitchFieldTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    SwitchThemeData? switchTheme,
    FieldBlocBuilderControlAffinity? controlAffinity,
  }) {
    return SwitchFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      controlAffinity: controlAffinity ?? this.controlAffinity,
    );
  }
}

/// Theme of [RadioButtonGroupFieldBlocBuilder]
class RadioFieldTheme extends FieldTheme {
  /// The [Radio] theme inside the field
  final RadioThemeData? radioTheme;

  const RadioFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.radioTheme,
  }) : super(
          textStyle: textStyle,
          textColor: textColor,
          decorationTheme: decorationTheme,
        );

  RadioFieldTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    RadioThemeData? radioTheme,
  }) {
    return RadioFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      radioTheme: radioTheme ?? this.radioTheme,
    );
  }
}

class TextFieldTheme extends FieldTheme {
  /// The position of the text within the field
  final TextAlign? textAlign;

  final Widget? clearIcon;

  final Widget? obscureTrueIcon;

  final Widget? obscureFalseIcon;

  /// The style of suggestions
  final TextStyle? suggestionsTextStyle;

  const TextFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.textAlign,
    this.clearIcon,
    this.obscureTrueIcon,
    this.obscureFalseIcon,
    this.suggestionsTextStyle,
  }) : super(
          textStyle: textStyle,
          textColor: textColor,
          decorationTheme: decorationTheme,
        );

  TextFieldTheme copyWith({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    TextAlign? textAlign,
    Widget? clearIcon,
    Widget? obscureTrueIcon,
    Widget? obscureFalseIcon,
    TextStyle? suggestionsTextStyle,
  }) {
    return TextFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      textAlign: textAlign ?? this.textAlign,
      clearIcon: clearIcon ?? this.clearIcon,
      obscureTrueIcon: obscureTrueIcon ?? this.obscureTrueIcon,
      obscureFalseIcon: obscureFalseIcon ?? this.obscureFalseIcon,
      suggestionsTextStyle: suggestionsTextStyle ?? this.suggestionsTextStyle,
    );
  }
}
