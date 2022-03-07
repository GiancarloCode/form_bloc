import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/fields/simple_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design switch
class SwitchFieldBlocBuilder extends StatelessWidget {
  const SwitchFieldBlocBuilder({
    Key? key,
    required this.booleanFieldBloc,
    required this.body,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.alignment = AlignmentDirectional.centerStart,
    this.nextFocusNode,
    this.controlAffinity,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.autofocus = false,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.thumbColor,
    this.trackColor,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc booleanFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilderControlAffinity}
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

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxBody}
  final Widget body;

  /// {@macro flutter.cupertino.switch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  final TextStyle? textStyle;
  final MaterialStateProperty<Color?>? textColor;

  // ========== [Switch] ==========

  /// An image to use on the thumb of this switch when the switch is on.
  final ImageProvider? activeThumbImage;

  /// An image to use on the thumb of this switch when the switch is off.
  final ImageProvider? inactiveThumbImage;

  /// [Switch.thumbColor]
  final MaterialStateProperty<Color?>? thumbColor;

  /// [Switch.trackColor]
  final MaterialStateProperty<Color?>? trackColor;

  /// [Switch.materialTapTargetSize]
  final MaterialTapTargetSize? materialTapTargetSize;

  /// [Switch.mouseCursor]
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

  /// [Switch.overlayColor]
  final MaterialStateProperty<Color?>? overlayColor;

  /// [Switch.splashRadius]
  final double? splashRadius;

  SwitchFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.switchTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final switchTheme = fieldTheme.switchTheme ?? theme.switchTheme;

    return SwitchFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      switchTheme: switchTheme.copyWith(
        thumbColor: thumbColor,
        trackColor: trackColor,
        materialTapTargetSize: materialTapTargetSize,
        mouseCursor: mouseCursor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
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
        switchTheme: fieldTheme.switchTheme!,
      ),
      child: SimpleFieldBlocBuilder(
        singleFieldBloc: booleanFieldBloc,
        animateWhenCanShow: animateWhenCanShow,
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
                    prefixIcon: fieldTheme.controlAffinity ==
                            FieldBlocBuilderControlAffinity.leading
                        ? _buildSwitch(context, state)
                        : null,
                    suffixIcon: fieldTheme.controlAffinity ==
                            FieldBlocBuilderControlAffinity.trailing
                        ? _buildSwitch(context, state)
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

  Switch _buildSwitch(
    BuildContext context,
    BooleanFieldBlocState state,
  ) {
    return Switch(
      value: state.value,
      onChanged: fieldBlocBuilderOnChange<bool>(
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
        onChanged: booleanFieldBloc.changeValue,
      ),
      activeThumbImage: activeThumbImage,
      autofocus: autofocus,
      dragStartBehavior: dragStartBehavior,
      focusNode: focusNode,
      inactiveThumbImage: inactiveThumbImage,
      materialTapTargetSize: materialTapTargetSize,
    );
  }
}
