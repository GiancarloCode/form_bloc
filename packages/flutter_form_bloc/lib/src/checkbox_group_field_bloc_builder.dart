import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design checkboxes.
class CheckboxGroupFieldBlocBuilder<Value> extends StatelessWidget {
  const CheckboxGroupFieldBlocBuilder({
    Key? key,
    required this.multiSelectFieldBloc,
    required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.nextFocusNode,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.mouseCursor,
    this.fillColor,
    this.checkColor,
    this.overlayColor,
    this.splashRadius,
    this.shape,
    this.side,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final MultiSelectFieldBloc<Value, dynamic> multiSelectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  final FieldBlocStringItemBuilder<Value> itemBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  final TextStyle? textStyle;
  final MaterialStateProperty<Color>? textColor;

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
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return CheckboxTheme(
      data: fieldTheme.checkboxTheme!,
      child: CanShowFieldBlocBuilder(
        fieldBloc: multiSelectFieldBloc,
        animate: animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<MultiSelectFieldBloc<Value, dynamic>,
              MultiSelectFieldBlocState<Value, dynamic>>(
            bloc: multiSelectFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: this.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );

              return DefaultFieldBlocBuilderPadding(
                padding: padding,
                child: Stack(
                  children: <Widget>[
                    InputDecorator(
                      decoration: _buildDecoration(
                          context, state, isEnabled, fieldTheme),
                      child: Opacity(
                        opacity: 0.0,
                        child: _buildCheckboxes(state, isEnabled, fieldTheme),
                      ),
                    ),
                    InputDecorator(
                      decoration: Style.inputDecorationWithoutBorder.copyWith(
                        contentPadding: Style.getGroupFieldBlocContentPadding(
                          isVisible: true,
                          decoration: decoration,
                        ),
                      ),
                      child: _buildCheckboxes(state, isEnabled, fieldTheme),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCheckboxes(
    MultiSelectFieldBlocState<Value, dynamic> state,
    bool isEnabled,
    CheckboxFieldTheme fieldTheme,
  ) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            prefixIcon: Checkbox(
              value: state.value.contains(state.items[index]),
              onChanged: fieldBlocBuilderOnChange<bool?>(
                isEnabled: isEnabled,
                nextFocusNode: nextFocusNode,
                onChanged: (_) {
                  if (state.value.contains(item)) {
                    multiSelectFieldBloc.deselect(item);
                  } else {
                    multiSelectFieldBloc.select(item);
                  }
                },
              ),
            ),
          ),
          child: Text(
            itemBuilder(context, state.items[index]),
            style: Style.resolveTextStyle(
              isEnabled: isEnabled,
              style: fieldTheme.textStyle!,
              color: fieldTheme.textColor!,
            ),
          ),
        );
      },
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    MultiSelectFieldBlocState<Value, dynamic> state,
    bool isEnabled,
    CheckboxFieldTheme fieldTheme,
  ) {
    final decoration = this.decoration.copyWith(
          suffix: this.decoration.suffix != null ? SizedBox.shrink() : null,
          prefixIcon:
              this.decoration.prefixIcon != null ? SizedBox.shrink() : null,
          prefix: this.decoration.prefix != null ? SizedBox.shrink() : null,
          suffixIcon:
              this.decoration.suffixIcon != null ? SizedBox.shrink() : null,
          enabled: isEnabled,
          contentPadding: Style.getGroupFieldBlocContentPadding(
            isVisible: false,
            decoration: this.decoration,
          ),
          errorText: Style.getErrorText(
            context: context,
            errorBuilder: errorBuilder,
            fieldBlocState: state,
            fieldBloc: multiSelectFieldBloc,
          ),
        );

    return decoration.applyDefaults(fieldTheme.decorationTheme!);
  }
}
