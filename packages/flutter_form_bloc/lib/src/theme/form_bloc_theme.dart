import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/slider/slider_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme_provider.dart';
import 'package:flutter_form_bloc/src/theme/form_config.dart';
import 'package:flutter_form_bloc/src/theme/suffix_button_themes.dart';
import 'package:flutter_form_bloc/src/utils/field_bloc_builder_control_affinity.dart';
import 'package:flutter_form_bloc/src/utils/to_string.dart';

class FormTheme extends Equatable {
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

  /// The theme of [ChoiceChipFieldBlocBuilder]
  final ChoiceChipFieldTheme choiceChipTheme;

  /// The theme of [FilterChipFieldBlocBuilder]
  final FilterChipFieldTheme filterChipTheme;

  /// The theme of [DateTimeFieldBlocBuilder]
  final DateTimeFieldTheme dateTimeTheme;

  /// The theme of [DropdownFieldBlocBuilder]
  final DropdownFieldTheme dropdownTheme;

  /// The theme of [SliderFieldBlocBuilder]
  final SliderFieldTheme sliderTheme;

  /// The theme of [SwitchFieldBlocBuilder]
  final SwitchFieldTheme switchTheme;

  /// the theme of [RadioButtonGroupFieldBlocBuilder]
  final RadioFieldTheme radioTheme;

  /// The theme of [TextFieldBlocBuilder]
  final TextFieldTheme textTheme;

  final ClearSuffixButtonTheme clearSuffixButtonTheme;

  final ObscureSuffixButtonTheme obscureSuffixButtonTheme;

  /// The theme of [ScrollableFormBlocManager]
  final ScrollableFormTheme scrollableFormTheme;

  /// Returns `EdgeInsets.symmetric(vertical: 8.0)`.
  static EdgeInsets defaultPadding = const EdgeInsets.symmetric(vertical: 8.0);

  const FormTheme({
    this.textStyle,
    this.textColor,
    this.decorationTheme,
    this.padding,
    this.checkboxTheme = const CheckboxFieldTheme(),
    this.choiceChipTheme = const ChoiceChipFieldTheme(),
    this.filterChipTheme = const FilterChipFieldTheme(),
    this.dateTimeTheme = const DateTimeFieldTheme(),
    this.dropdownTheme = const DropdownFieldTheme(),
    this.sliderTheme = const SliderFieldTheme(),
    this.switchTheme = const SwitchFieldTheme(),
    this.radioTheme = const RadioFieldTheme(),
    this.textTheme = const TextFieldTheme(),
    this.clearSuffixButtonTheme = const ClearSuffixButtonTheme(),
    this.obscureSuffixButtonTheme = const ObscureSuffixButtonTheme(),
    this.scrollableFormTheme = const ScrollableFormTheme(),
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

  @override
  List<Object?> get props => [
        textStyle,
        textColor,
        decorationTheme,
        padding,
        checkboxTheme,
        choiceChipTheme,
        filterChipTheme,
        dateTimeTheme,
        dropdownTheme,
        switchTheme,
        radioTheme,
        textTheme.hashCode
      ];

  @override
  String toString() {
    return (ToString(FormTheme)
          ..add('textStyle', textStyle)
          ..add('textColor', textColor)
          ..add('decorationTheme', decorationTheme)
          ..add('padding', padding)
          ..add('checkboxTheme', checkboxTheme)
          ..add('choiceChipFieldTheme', choiceChipTheme)
          ..add('filterChipFieldTheme', filterChipTheme)
          ..add('dateTimeTheme', dateTimeTheme)
          ..add('dropdownTheme', dropdownTheme)
          ..add('switchTheme', switchTheme)
          ..add('radioTheme', radioTheme)
          ..add('textTheme', textTheme))
        .toString();
  }
}

/// The theme of [CheckboxFieldBlocBuilder] and [CheckboxGroupFieldBlocBuilder]
class CheckboxFieldTheme extends FieldTheme {
  /// The [Checkbox] theme inside the field
  final CheckboxThemeData? checkboxTheme;

  /// The position of the [Checkbox] inside the field
  final FieldBlocBuilderControlAffinity? controlAffinity;

  /// Identifies whether the item tile is touchable
  /// to change the status of the item
  final bool canTapItemTile;

  const CheckboxFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.checkboxTheme,
    this.controlAffinity,
    this.canTapItemTile = false,
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
    bool? canTapItemTile,
  }) {
    return CheckboxFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      controlAffinity: controlAffinity ?? this.controlAffinity,
      canTapItemTile: canTapItemTile ?? this.canTapItemTile,
    );
  }

  @override
  List<Object?> get props =>
      [super.props, checkboxTheme, controlAffinity, canTapItemTile];

  @override
  String toString([ToString? toString]) {
    return super.toString(ToString(runtimeType)
      ..add('checkboxTheme', checkboxTheme)
      ..add('controlAffinity', controlAffinity)
      ..add('canTapItemTile', canTapItemTile));
  }
}

/// The theme of [ChoiceChipFieldBlocBuilder] and [FilterChipFieldBlocBuilder]
/// for the chip wrap
class WrapChipFieldTheme extends Equatable {
  /// Defaults value is `8.0`
  final double? spacing;

  /// Defaults value is `8.0`
  final double? runSpacing;

  const WrapChipFieldTheme({
    this.spacing,
    this.runSpacing,
  });

  WrapChipFieldTheme copyWith({
    double? spacing,
    double? runSpacing,
  }) {
    return WrapChipFieldTheme(
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
    );
  }

  @override
  List<Object?> get props => [spacing, runSpacing];

  @override
  String toString() {
    return (ToString(runtimeType)
          ..add('spacing', spacing)
          ..add('runSpacing', runSpacing))
        .toString();
  }
}

/// The theme of [ChoiceChipFieldBlocBuilder]
class ChoiceChipFieldTheme extends Equatable {
  final ChipThemeData? chipTheme;
  final WrapChipFieldTheme wrapTheme;

  const ChoiceChipFieldTheme({
    this.chipTheme,
    this.wrapTheme = const WrapChipFieldTheme(),
  });

  ChoiceChipFieldTheme copyWith({
    ChipThemeData? chipTheme,
    WrapChipFieldTheme? wrapTheme,
  }) {
    return ChoiceChipFieldTheme(
      chipTheme: chipTheme ?? this.chipTheme,
      wrapTheme: wrapTheme ?? this.wrapTheme,
    );
  }

  @override
  List<Object?> get props => [chipTheme, wrapTheme];

  @override
  String toString() {
    return (ToString(runtimeType)
          ..add('chipTheme', chipTheme)
          ..add('wrapTheme', wrapTheme))
        .toString();
  }
}

/// The theme of [FilterChipFieldBlocBuilder]
class FilterChipFieldTheme extends Equatable {
  final ChipThemeData? chipTheme;
  final WrapChipFieldTheme wrapTheme;

  const FilterChipFieldTheme({
    this.chipTheme,
    this.wrapTheme = const WrapChipFieldTheme(),
  });

  FilterChipFieldTheme copyWith({
    ChipThemeData? chipTheme,
    WrapChipFieldTheme? wrapTheme,
  }) {
    return FilterChipFieldTheme(
      chipTheme: chipTheme ?? this.chipTheme,
      wrapTheme: wrapTheme ?? this.wrapTheme,
    );
  }

  @override
  List<Object?> get props => [chipTheme, wrapTheme];

  @override
  String toString() {
    return (ToString(runtimeType)
          ..add('chipTheme', chipTheme)
          ..add('wrapTheme', wrapTheme))
        .toString();
  }
}

/// The theme of [DateTimeFieldBlocBuilder]
class DateTimeFieldTheme extends FieldTheme {
  /// The position of the text within the field
  final TextAlign? textAlign;
  final bool? showClearIcon;

  final Widget? clearIcon;

  final ClearSuffixButtonTheme clearSuffixButtonTheme;

  const DateTimeFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.textAlign,
    this.showClearIcon,
    @Deprecated('Use clearSuffixButtonTheme.icon') this.clearIcon,
    this.clearSuffixButtonTheme = const ClearSuffixButtonTheme(),
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
    ClearSuffixButtonTheme? clearSuffixButtonTheme,
    TextAlign? textAlign,
  }) {
    return DateTimeFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      showClearIcon: showClearIcon ?? this.showClearIcon,
      // ignore: deprecated_member_use_from_same_package
      clearIcon: clearIcon ?? this.clearIcon,
      clearSuffixButtonTheme:
          clearSuffixButtonTheme ?? this.clearSuffixButtonTheme,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  @override
  List<Object?> get props => [
        super.props,
        textAlign,
        showClearIcon,
        clearIcon,
        clearSuffixButtonTheme
      ];

  @override
  String toString([ToString? toString]) {
    return super.toString(ToString(runtimeType)
      ..add('textAlign', textAlign)
      ..add('showClearIcon', showClearIcon)
      ..add('clearIcon', clearIcon)
      ..add('clearSuffixButtonTheme', clearSuffixButtonTheme));
  }
}

/// The theme of [DropdownFieldBlocBuilder]
class DropdownFieldTheme extends FieldTheme {
  /// Defaults is [TextOverflow.ellipsis]
  final TextOverflow? textOverflow;

  /// Defaults is `1`
  final int? maxLines;

  /// Defaults is [FieldTheme.textStyle]
  final TextStyle? selectedTextStyle;

  /// Defaults is [DropdownFieldTheme.maxLines]
  final int? selectedMaxLines;

  /// Defaults is [Icons.arrow_drop_down]
  final Widget? moreIcon;

  const DropdownFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.textOverflow,
    this.maxLines,
    this.selectedTextStyle,
    this.selectedMaxLines,
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
    TextOverflow? textOverflow,
    int? maxLines,
    TextStyle? selectedTextStyle,
    int? selectedMaxLines,
    Widget? moreIcon,
  }) {
    return DropdownFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      textOverflow: textOverflow ?? this.textOverflow,
      maxLines: maxLines ?? this.maxLines,
      selectedTextStyle: selectedTextStyle ?? this.selectedTextStyle,
      selectedMaxLines: selectedMaxLines ?? this.selectedMaxLines,
      moreIcon: moreIcon ?? this.moreIcon,
    );
  }

  @override
  List<Object?> get props => [
        super.props,
        textOverflow,
        maxLines,
        selectedTextStyle,
        selectedMaxLines,
        moreIcon
      ];

  @override
  String toString([ToString? toString]) {
    return super.toString(ToString(runtimeType)
      ..add('textOverflow', textOverflow)
      ..add('maxLines', maxLines)
      ..add('selectedTextStyle', selectedTextStyle)
      ..add('selectedMaxLines', selectedMaxLines)
      ..add('moreIcon', moreIcon));
  }
}

class SliderFieldTheme extends Equatable {
  final SliderThemeData? sliderTheme;

  const SliderFieldTheme({
    this.sliderTheme,
  });

  @override
  List<Object?> get props => [sliderTheme];

  @override
  String toString() {
    return (ToString(runtimeType)..add('sliderTheme', sliderTheme)).toString();
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

  @override
  List<Object?> get props => [super.props, switchTheme, controlAffinity];

  @override
  String toString([ToString? toString]) {
    return super.toString(ToString(runtimeType)
      ..add('switchTheme', switchTheme)
      ..add('controlAffinity', controlAffinity));
  }
}

/// Theme of [RadioButtonGroupFieldBlocBuilder]
class RadioFieldTheme extends FieldTheme {
  /// The [Radio] theme inside the field
  final RadioThemeData? radioTheme;

  /// Identifies whether the item tile is touchable
  /// to change the status of the item
  final bool canTapItemTile;

  /// if `true` the radio button selected can
  ///  be deselect by tapping.
  final bool canDeselect;

  const RadioFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.radioTheme,
    this.canTapItemTile = false,
    this.canDeselect = true,
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
    bool? canTapItemTile,
    bool? canDeselect,
  }) {
    return RadioFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      canTapItemTile: canTapItemTile ?? this.canTapItemTile,
      canDeselect: canDeselect ?? this.canDeselect,
    );
  }

  @override
  List<Object?> get props => [
        super.props,
        radioTheme,
        canTapItemTile,
        canDeselect,
      ];

  @override
  String toString([ToString? toString]) {
    return super.toString(ToString(runtimeType)
      ..add('radioTheme', radioTheme)
      ..add('canTapItemTile', canTapItemTile)
      ..add('canDeselect', canDeselect));
  }
}

class TextFieldTheme extends FieldTheme {
  /// The position of the text within the field
  final TextAlign? textAlign;

  final Widget? clearIcon;

  final ClearSuffixButtonTheme clearSuffixButtonTheme;

  final ObscureSuffixButtonTheme obscureSuffixButtonTheme;

  final Widget? obscureTrueIcon;

  final Widget? obscureFalseIcon;

  /// The style of suggestions
  final TextStyle? suggestionsTextStyle;

  const TextFieldTheme({
    TextStyle? textStyle,
    MaterialStateProperty<Color?>? textColor,
    InputDecorationTheme? decorationTheme,
    this.textAlign,
    @Deprecated('Use clearSuffixButtonTheme.icon') this.clearIcon,
    this.clearSuffixButtonTheme = const ClearSuffixButtonTheme(),
    @Deprecated('Use obscureSuffixButtonTheme.trueIcon') this.obscureTrueIcon,
    @Deprecated('Use obscureSuffixButtonTheme.falseIcon') this.obscureFalseIcon,
    this.obscureSuffixButtonTheme = const ObscureSuffixButtonTheme(),
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
    ClearSuffixButtonTheme? clearSuffixButtonTheme,
    Widget? obscureTrueIcon,
    Widget? obscureFalseIcon,
    ObscureSuffixButtonTheme? obscureSuffixButtonTheme,
    TextStyle? suggestionsTextStyle,
  }) {
    return TextFieldTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      textAlign: textAlign ?? this.textAlign,
      // ignore: deprecated_member_use_from_same_package
      clearIcon: clearIcon ?? this.clearIcon,
      clearSuffixButtonTheme:
          clearSuffixButtonTheme ?? this.clearSuffixButtonTheme,
      // ignore: deprecated_member_use_from_same_package
      obscureTrueIcon: obscureTrueIcon ?? this.obscureTrueIcon,
      // ignore: deprecated_member_use_from_same_package
      obscureFalseIcon: obscureFalseIcon ?? this.obscureFalseIcon,
      obscureSuffixButtonTheme:
          obscureSuffixButtonTheme ?? this.obscureSuffixButtonTheme,
      suggestionsTextStyle: suggestionsTextStyle ?? this.suggestionsTextStyle,
    );
  }

  @override
  List<Object?> get props => [
        super.props,
        textAlign,
        clearIcon,
        clearSuffixButtonTheme,
        obscureTrueIcon,
        obscureFalseIcon,
        obscureSuffixButtonTheme,
        suggestionsTextStyle
      ];

  @override
  String toString([ToString? toString]) {
    return super.toString(ToString(runtimeType)
      ..add('textAlign', textAlign)
      ..add('clearIcon', clearIcon)
      ..add('clearSuffixButtonTheme', clearSuffixButtonTheme)
      ..add('obscureTrueIcon', obscureTrueIcon)
      ..add('obscureFalseIcon', obscureFalseIcon)
      ..add('obscureSuffixButtonTheme', obscureSuffixButtonTheme)
      ..add('suggestionsTextStyle', suggestionsTextStyle));
  }
}
