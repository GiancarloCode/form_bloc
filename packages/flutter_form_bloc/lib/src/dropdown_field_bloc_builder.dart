import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/flutter_typeahead.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design dropdown.
class DropdownFieldBlocBuilder<Value> extends StatelessWidget {
  DropdownFieldBlocBuilder({
    Key? key,
    required this.selectFieldBloc,
    required this.itemBuilder,
    this.selectedItemBuilder,
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
    this.hint,
    this.disabledHint,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<Value, dynamic> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.itemBuilder}
  final FieldItemBuilder<Value> itemBuilder;

  /// This function is invoked to render the selected item
  ///
  /// {@macro flutter_form_bloc.FieldBlocBuilder.itemBuilder}
  final ItemBuilder<Value>? selectedItemBuilder;

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

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textStyle}
  final TextStyle? textStyle;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textColor}
  final MaterialStateProperty<Color?>? textColor;

  /// A placeholder widget that is displayed by the dropdown button.
  ///
  /// If [value] is null and the dropdown is enabled ([items] and [onChanged] are non-null),
  /// this widget is displayed as a placeholder for the dropdown button's value.
  ///
  /// If [value] is null and the dropdown is disabled and [disabledHint] is null,
  /// this widget is used as the placeholder.
  final Widget? hint;

  /// A preferred placeholder widget that is displayed when the dropdown is disabled.
  ///
  /// If [value] is null, the dropdown is disabled ([items] or [onChanged] is null),
  /// this widget is displayed as a placeholder for the dropdown button's value.
  final Widget? disabledHint;

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
                    hint: hint,
                    disabledHint: disabledHint ??
                        (decoration.hintText != null
                            ? DefaultTextStyle(
                                style: Style.resolveTextStyle(
                                  isEnabled: isEnabled,
                                  style: decoration.hintStyle ??
                                      fieldTheme.textStyle!,
                                  color: fieldTheme.textColor!,
                                ),
                                child: Text(decoration.hintText!),
                              )
                            : null),
                    onChanged: fieldBlocBuilderOnChange<Value?>(
                      isEnabled: isEnabled,
                      nextFocusNode: nextFocusNode,
                      onChanged: (value) {
                        selectFieldBloc.updateValue(value);
                        onChanged?.call(value);
                      },
                    ),
                    items: _buildItems(
                        context, fieldTheme, fieldState.items, false),
                    selectedItemBuilder: (context) {
                      return _buildItems(
                          context, fieldTheme, fieldState.items, true);
                    },
                    // Simulates the normal alignment of the suffixIcon
                    icon: Transform.translate(
                      offset: Offset(6.0, 0.0),
                      child: ConstrainedBox(
                        constraints: this.decoration.suffixIconConstraints ??
                            const BoxConstraints(
                              minHeight: 48.0,
                              minWidth: 48.0,
                            ),
                        child: this.decoration.suffixIcon ??
                            fieldTheme.moreIcon ??
                            const Icon(Icons.arrow_drop_down),
                      ),
                    ),
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
    DropdownFieldTheme fieldTheme,
    Iterable<Value> items,
    bool isSelected,
  ) {
    final builder =
        (isSelected ? this.selectedItemBuilder : itemBuilder) ?? itemBuilder;

    return [
      if (showEmptyItem)
        DropdownMenuItem<Value>(
          value: null,
          child: Text(
            isSelected ? decoration.hintText ?? '' : emptyItemLabel,
            style: isSelected ? decoration.hintStyle : null,
          ),
        ),
      ...items.map<DropdownMenuItem<Value>>((value) {
        final fieldItem = builder(context, value);

        if (fieldItem is! FieldItem) {
          return DropdownMenuItem<Value>(
            value: value,
            child: DefaultTextStyle(
              style: Style.resolveTextStyle(
                isEnabled: isEnabled,
                style: fieldTheme.textStyle!,
                color: fieldTheme.textColor!,
              ),
              child: fieldItem,
            ),
          );
        }
        return DropdownMenuItem<Value>(
          value: value,
          enabled: fieldItem.isEnabled,
          alignment: fieldItem.alignment,
          onTap: fieldItem.onTap,
          child: DefaultTextStyle(
            style: Style.resolveTextStyle(
              isEnabled: fieldItem.isEnabled,
              style: fieldTheme.textStyle!,
              color: fieldTheme.textColor!,
            ),
            child: fieldItem.child,
          ),
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
      contentPadding: const EdgeInsets.only(left: 16.0),
      suffix: const SizedBox.shrink(),
      suffixIcon: const SizedBox.shrink(),
      suffixIconConstraints: const BoxConstraints(),
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
