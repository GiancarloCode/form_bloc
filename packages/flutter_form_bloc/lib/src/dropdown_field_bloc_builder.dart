import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/fields/simple_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/flutter_typeahead.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design dropdown.
class DropdownFieldBlocBuilder<Value> extends StatelessWidget {
  const DropdownFieldBlocBuilder({
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
    this.textOverflow,
    this.maxLines,
    this.selectedTextStyle,
    this.selectedMaxLines,
    this.isExpanded = true,
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

  /// Defaults is [TextOverflow.ellipsis]
  final TextOverflow? textOverflow;

  /// Defaults is `2`
  final int? maxLines;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textStyle}
  final TextStyle? selectedTextStyle;

  /// Defaults is [maxLines]
  final int? selectedMaxLines;

  /// Set the dropdown's inner contents to horizontally fill its parent.
  ///
  /// By default this button's inner width is the minimum size of its contents.
  /// If [isExpanded] is true, the inner width is expanded to fill its
  /// surrounding container.
  final bool isExpanded;

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

    final textStyle = this.textStyle ?? resolver.textStyle;
    final textOverflow =
        this.textOverflow ?? fieldTheme.textOverflow ?? TextOverflow.ellipsis;
    final maxLines = this.maxLines ?? fieldTheme.maxLines ?? 2;

    return DropdownFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle,
      textColor: textColor ?? resolver.textColor,
      maxLines: maxLines,
      textOverflow: textOverflow,
      selectedTextStyle:
          selectedTextStyle ?? fieldTheme.selectedTextStyle ?? textStyle,
      selectedMaxLines:
          selectedMaxLines ?? fieldTheme.selectedMaxLines ?? maxLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return SimpleFieldBlocBuilder(
      singleFieldBloc: selectFieldBloc,
      animateWhenCanShow: animateWhenCanShow,
      builder: (context, canShow) {
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
                    isExpanded: isExpanded,
                    isDense: true,
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
                        selectFieldBloc.changeValue(value);
                        onChanged?.call(value);
                      },
                    ),
                    items: _buildItems(
                      context: context,
                      fieldTheme: fieldTheme,
                      items: fieldState.items,
                      isEnabled: isEnabled,
                      isSelected: false,
                    ),
                    selectedItemBuilder: (context) => _buildItems(
                      context: context,
                      fieldTheme: fieldTheme,
                      items: fieldState.items,
                      isEnabled: isEnabled,
                      isSelected: true,
                    ),
                    icon: this.decoration.suffixIcon ??
                        fieldTheme.moreIcon ??
                        const Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDefaultTextStyle({
    required DropdownFieldTheme fieldTheme,
    required bool isEnabled,
    required bool isSelected,
    required Widget child,
  }) {
    return DefaultTextStyle(
      overflow: fieldTheme.textOverflow!,
      maxLines: isSelected ? fieldTheme.selectedMaxLines : fieldTheme.maxLines,
      style: Style.resolveTextStyle(
        isEnabled: isEnabled,
        style:
            isSelected ? fieldTheme.selectedTextStyle! : fieldTheme.textStyle!,
        color: fieldTheme.textColor!,
      ),
      child: child,
    );
  }

  List<DropdownMenuItem<Value>> _buildItems({
    required BuildContext context,
    required DropdownFieldTheme fieldTheme,
    required Iterable<Value> items,
    required bool isSelected,
    required bool isEnabled,
  }) {
    final builder =
        (isSelected ? selectedItemBuilder : itemBuilder) ?? itemBuilder;

    return [
      if (showEmptyItem)
        DropdownMenuItem<Value>(
          value: null,
          child: Text(
            isSelected ? decoration.hintText ?? '' : emptyItemLabel,
            style: isSelected
                ? decoration.hintStyle
                : Style.resolveTextStyle(
                    isEnabled: isEnabled,
                    style: fieldTheme.textStyle!,
                    color: fieldTheme.textColor!,
                  ),
          ),
        ),
      ...items.map<DropdownMenuItem<Value>>((value) {
        final fieldItem = builder(context, value);

        if (fieldItem is! FieldItem) {
          return DropdownMenuItem<Value>(
            value: value,
            child: _buildDefaultTextStyle(
              fieldTheme: fieldTheme,
              isEnabled: isEnabled,
              isSelected: isSelected,
              child: fieldItem,
            ),
          );
        }
        return DropdownMenuItem<Value>(
          value: value,
          enabled: fieldItem.isEnabled,
          alignment: fieldItem.alignment,
          onTap: fieldItem.onTap,
          child: _buildDefaultTextStyle(
            fieldTheme: fieldTheme,
            isEnabled: fieldItem.isEnabled && isEnabled,
            isSelected: isSelected,
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
