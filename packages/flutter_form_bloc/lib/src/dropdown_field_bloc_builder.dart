import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design dropdown.
class DropdownFieldBlocBuilder<Value> extends StatelessWidget {
  DropdownFieldBlocBuilder({
    Key? key,
    required this.selectFieldBloc,
    required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.padding,
    this.decoration = const InputDecoration(),
    this.errorBuilder,
    this.showEmptyItem = true,
    this.nextFocusNode,
    this.focusNode,
    this.textAlign,
    this.animateWhenCanShow = true,
    this.emptyItemLabel = '',
    this.onChanged,
    this.textStyle,
    this.textColor,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<Value, dynamic> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@template flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  /// This function takes the `context` and the `value`
  /// and must return a String that represent that `value`.
  /// {@endtemplate}
  final FieldItemBuilder<Value> itemBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// If `true` an empty item is showed at the top of the dropdown items,
  /// and can be used for deselect.
  final bool showEmptyItem;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode? focusNode;

  /// {@template flutter_form_bloc.FieldBlocBuilder.decoration}
  /// The decoration to show around the field.
  /// {@endtemplate}
  final InputDecoration decoration;

  /// How the text in the decoration should be aligned horizontally.
  final TextAlign? textAlign;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// A label to display for an empty item
  final String emptyItemLabel;

  /// Called when the user selects an item.
  final ValueChanged<Value?>? onChanged;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.style}
  final TextStyle? textStyle;

  final MaterialStateProperty<Color?>? textColor;

  DropdownFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.dropdownTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);

    return DropdownFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return CanShowFieldBlocBuilder(
      fieldBloc: selectFieldBloc,
      animate: animateWhenCanShow,
      builder: (_, __) {
        return BlocBuilder<SelectFieldBloc<Value, dynamic>,
            SelectFieldBlocState<Value, dynamic>>(
          bloc: selectFieldBloc,
          builder: (context, fieldState) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: this.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: fieldState,
            );

            final decoration =
                _buildDecoration(context, fieldTheme, fieldState, isEnabled);

            return DefaultFieldBlocBuilderPadding(
              padding: padding,
              child: InputDecorator(
                decoration: decoration,
                textAlign: textAlign,
                isEmpty:
                    fieldState.value == null && decoration.hintText == null,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Value>(
                    value: fieldState.value,
                    focusNode: focusNode,
                    disabledHint: decoration.hintText != null
                        ? DefaultTextStyle(
                            style: Style.resolveTextStyle(
                              isEnabled: isEnabled,
                              style:
                                  decoration.hintStyle ?? fieldTheme.textStyle!,
                              color: fieldTheme.textColor!,
                            ),
                            child: Text(decoration.hintText!),
                          )
                        : null,
                    style: Style.resolveTextStyle(
                      isEnabled: isEnabled,
                      style: fieldTheme.textStyle!,
                      color: fieldTheme.textColor!,
                    ),
                    onChanged: fieldBlocBuilderOnChange<Value?>(
                      isEnabled: isEnabled,
                      nextFocusNode: nextFocusNode,
                      onChanged: (value) {
                        selectFieldBloc.updateValue(value);
                        onChanged?.call(value);
                      },
                    ),
                    items: fieldState.items.isEmpty
                        ? null
                        : _buildItems(context, fieldState.items, false),
                    selectedItemBuilder: (context) {
                      return _buildItems(context, fieldState.items, true);
                    },
                    icon: decoration.suffixIcon ?? fieldTheme.moreIcon,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<DropdownMenuItem<Value>> _buildItems(
    BuildContext context,
    Iterable<Value> items,
    bool isSelected,
  ) {
    return [
      if (showEmptyItem)
        DropdownMenuItem<Value>(
          value: null,
          child: Text(
            isSelected ? decoration.hintText ?? '' : emptyItemLabel,
            style: isSelected ? decoration.hintStyle : null,
          ),
        ),
      ...items.map<DropdownMenuItem<Value>>((Value value) {
        final fieldItem = itemBuilder(context, value);

        return DropdownMenuItem<Value>(
          value: value,
          enabled: fieldItem.isEnabled,
          onTap: fieldItem.onTap,
          child: fieldItem.child,
        );
      })
    ];
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    DropdownFieldTheme fieldTheme,
    SelectFieldBlocState<Value, dynamic> state,
    bool isEnabled,
  ) {
    InputDecoration decoration = this.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
      contentPadding: EdgeInsets.only(left: 16.0),
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
