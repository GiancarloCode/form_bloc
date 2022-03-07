import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/features/appear/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design checkbox.
class CheckboxFieldBlocBuilder extends StatelessWidget {
  const CheckboxFieldBlocBuilder({
    Key? key,
    required this.booleanFieldBloc,
    required this.body,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.alignment = AlignmentDirectional.centerStart,
    this.nextFocusNode,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.controlAffinity,
    this.mouseCursor,
    this.fillColor,
    this.checkColor,
    this.overlayColor,
    this.splashRadius,
    this.shape,
    this.side,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc<dynamic> booleanFieldBloc;

  /// {@template flutter_form_bloc.FieldBlocBuilderControlAffinity}
  /// Where to place the control in widgets
  /// {@endtemplate}
  final FieldBlocBuilderControlAffinity? controlAffinity;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry alignment;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@template flutter_form_bloc.FieldBlocBuilder.checkboxBody}
  /// The widget on the right side of the checkbox
  /// {@endtemplate}
  final Widget body;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textStyle}
  final TextStyle? textStyle;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textColor}
  final MaterialStateProperty<Color?>? textColor;

  // ========== [Checkbox] ==========

  /// [Checkbox.mouseCursor]
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

  /// [Checkbox.fillColor]
  final MaterialStateProperty<Color?>? fillColor;

  /// [Checkbox.checkColor]
  final MaterialStateProperty<Color?>? checkColor;

  /// [Checkbox.overlayColor]
  final MaterialStateProperty<Color?>? overlayColor;

  /// [Checkbox.splashRadius]
  final double? splashRadius;

  /// [Checkbox.shape]
  final OutlinedBorder? shape;

  /// [Checkbox.side]
  final BorderSide? side;

  CheckboxFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.checkboxTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final checkboxTheme = fieldTheme.checkboxTheme ?? theme.checkboxTheme;

    return CheckboxFieldTheme(
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      decorationTheme: fieldTheme.decorationTheme ?? resolver.decorationTheme,
      checkboxTheme: checkboxTheme.copyWith(
        mouseCursor: mouseCursor,
        fillColor: fillColor,
        checkColor: checkColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
        shape: shape,
        side: side,
      ),
      controlAffinity: controlAffinity ??
          fieldTheme.controlAffinity ??
          FieldBlocBuilderControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: fieldTheme.checkboxTheme,
      ),
      child: CanShowFieldBlocBuilder(
        fieldBloc: booleanFieldBloc,
        animate: animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
            bloc: booleanFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: this.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              return DefaultFieldBlocBuilderPadding(
                padding: padding,
                child: InputDecorator(
                  decoration: Style.inputDecorationWithoutBorder.copyWith(
                    prefixIcon: fieldTheme.controlAffinity! ==
                            FieldBlocBuilderControlAffinity.leading
                        ? _buildCheckbox(context, state)
                        : null,
                    suffixIcon: fieldTheme.controlAffinity! ==
                            FieldBlocBuilderControlAffinity.trailing
                        ? _buildCheckbox(context, state)
                        : null,
                    errorText: Style.getErrorText(
                      context: context,
                      errorBuilder: errorBuilder,
                      fieldBlocState: state,
                      fieldBloc: booleanFieldBloc,
                    ),
                  ),
                  child: DefaultTextStyle(
                    style: Style.resolveTextStyle(
                      isEnabled: isEnabled,
                      style: fieldTheme.textStyle!,
                      color: fieldTheme.textColor!,
                    ),
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: kMinInteractiveDimension,
                      ),
                      alignment: alignment,
                      child: body,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Checkbox _buildCheckbox(BuildContext context, BooleanFieldBlocState state) {
    return Checkbox(
      value: state.value,
      onChanged: fieldBlocBuilderOnChange<bool?>(
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
        onChanged: booleanFieldBloc.changeValue as void Function(bool?),
      ),
    );
  }
}
