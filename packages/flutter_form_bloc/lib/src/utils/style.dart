import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/src/field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

class Style {
  static const EdgeInsets defaultInputDecorationContentPadding =
      EdgeInsets.fromLTRB(15, 14, 14, 12);

  static const InputDecoration inputDecorationWithoutBorder = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    errorBorder: InputBorder.none,
    disabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    focusedErrorBorder: InputBorder.none,
    contentPadding: defaultInputDecorationContentPadding,
  );

  static Color getIconColor({
    @required Color customColor,
    @required Color defaultColor,
  }) =>
      customColor ??
      (ThemeData.estimateBrightnessForColor(defaultColor) == Brightness.dark
          ? Colors.white
          : Colors.grey[800]);

  static String getErrorText({
    @required BuildContext context,
    @required FieldBlocState fieldBlocState,
    @required FieldBlocErrorBuilder errorBuilder,
  }) {
    if (fieldBlocState.canShowError) {
      if (errorBuilder != null) {
        return errorBuilder(context, fieldBlocState.error);
      } else {
        return FieldBlocBuilder.defaultErrorBuilder(
            context, fieldBlocState.error);
      }
    } else {
      return null;
    }
  }

  static TextStyle getDefaultTextStyle({
    @required BuildContext context,
    @required bool isEnabled,
  }) =>
      isEnabled
          ? Theme.of(context).textTheme.subhead
          : Theme.of(context)
              .textTheme
              .subhead
              .copyWith(color: Theme.of(context).disabledColor);

  /// Returns `EdgeInsets.all(8.0)`.
  static EdgeInsets defaultPadding = const EdgeInsets.all(8.0);

  static EdgeInsets getGroupFieldBlocContentPadding({
    @required bool isVisible,
    @required InputDecoration decoration,
  }) {
    final contentPadding =
        decoration.contentPadding as EdgeInsets ?? EdgeInsets.all(0);

    if (isVisible) {
      return EdgeInsets.fromLTRB(
        contentPadding.left,
        contentPadding.top,
        contentPadding.right + 15,
        contentPadding.bottom,
      );
    } else {
      return EdgeInsets.fromLTRB(
        contentPadding.left + 15,
        contentPadding.top,
        contentPadding.right,
        contentPadding.bottom,
      );
    }
  }
}
