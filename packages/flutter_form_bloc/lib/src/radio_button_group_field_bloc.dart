import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design radio buttons.
class RadioButtonGroupFieldBlocBuilder<Value> extends StatelessWidget {
  const RadioButtonGroupFieldBlocBuilder({
    Key? key,
    required this.selectFieldBloc,
    required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.canDeselect = true,
    this.nextFocusNode,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.mouseCursor,
    this.fillColor,
    this.overlayColor,
    this.splashRadius,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<Value, dynamic> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  final FieldBlocStringItemBuilder<Value> itemBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  /// if `true` the radio button selected can
  ///  be deselect by tapping.
  final bool canDeselect;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  final TextStyle? textStyle;
  final MaterialStateProperty<Color?>? textColor;

  // ========== [Radio] ==========

  /// [Radio.mouseCursor]
  final MaterialStateProperty<MouseCursor?>? mouseCursor;

  /// [Radio.fillColor]
  final MaterialStateProperty<Color?>? fillColor;

  /// [Radio.overlayColor]
  final MaterialStateProperty<Color?>? overlayColor;

  /// [Radio.splashRadius]
  final double? splashRadius;

  RadioFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.radioTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final radioTheme = fieldTheme.radioTheme ?? theme.radioTheme;

    return RadioFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      radioTheme: radioTheme.copyWith(
        mouseCursor: mouseCursor,
        fillColor: fillColor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return RadioTheme(
      data: fieldTheme.radioTheme!,
      child: CanShowFieldBlocBuilder(
        fieldBloc: selectFieldBloc,
        animate: animateWhenCanShow,
        builder: (_, __) {
          return BlocBuilder<SelectFieldBloc<Value, dynamic>,
              SelectFieldBlocState<Value, dynamic>>(
            bloc: selectFieldBloc,
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
                  isEmpty: false,
                  decoration:
                      _buildDecoration(context, fieldTheme, state, isEnabled),
                  child: _buildRadioButtons(state, fieldTheme, isEnabled),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRadioButtons(
    SelectFieldBlocState<Value, dynamic> state,
    RadioFieldTheme fieldTheme,
    bool isEnable,
  ) {
    final onChanged = fieldBlocBuilderOnChange<Value?>(
      isEnabled: isEnabled,
      nextFocusNode: nextFocusNode,
      onChanged: selectFieldBloc.updateValue,
    );
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];

        return InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            prefixIcon: Stack(
              children: <Widget>[
                Radio<Value>(
                  value: item,
                  groupValue: state.value,
                  onChanged: onChanged,
                ),
                if (canDeselect && item == state.value)
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.transparent,
                    ),
                    child: Radio<Value?>(
                      value: null,
                      groupValue: state.value,
                      onChanged: onChanged,
                    ),
                  )
              ],
            ),
          ),
          child: Text(
            itemBuilder(context, item),
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
    RadioFieldTheme fieldTheme,
    SelectFieldBlocState<Value, dynamic> state,
    bool isEnable,
  ) {
    var decoration = this.decoration;

    decoration = decoration.copyWith(
      suffix: this.decoration.suffix != null ? SizedBox.shrink() : null,
      prefixIcon: this.decoration.prefixIcon != null ? SizedBox.shrink() : null,
      prefix: this.decoration.prefix != null ? SizedBox.shrink() : null,
      suffixIcon: this.decoration.suffixIcon != null ? SizedBox.shrink() : null,
      enabled: isEnable,
      contentPadding: Style.getGroupFieldBlocContentPadding(
        isVisible: false,
        decoration: decoration,
      ),
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: selectFieldBloc,
      ),
    );

    return decoration.applyDefaults(fieldTheme.decorationTheme!);
  }
}
