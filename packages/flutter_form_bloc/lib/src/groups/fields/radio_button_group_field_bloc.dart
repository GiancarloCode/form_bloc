import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/features/appear/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/groups/widgets/group_view.dart';
import 'package:flutter_form_bloc/src/groups/widgets/item_group_tile.dart';
import 'package:flutter_form_bloc/src/theme/field_theme_resolver.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
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
    this.canDeselect,
    this.nextFocusNode,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.mouseCursor,
    this.fillColor,
    this.overlayColor,
    this.splashRadius,
    this.groupStyle = const FlexGroupStyle(),
    this.canTapItemTile,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<Value, dynamic> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.itemBuilder}
  final FieldItemBuilder<Value> itemBuilder;

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
  ///  Defaults `true`
  final bool? canDeselect;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textStyle}
  final TextStyle? textStyle;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textColor}
  final MaterialStateProperty<Color?>? textColor;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.groupStyle}
  final GroupStyle groupStyle;

  /// Identifies whether the item tile is touchable
  /// to change the status of the item
  /// Defaults `false`
  final bool? canTapItemTile;

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
      canDeselect: canDeselect ?? fieldTheme.canDeselect,
      canTapItemTile: canTapItemTile ?? fieldTheme.canTapItemTile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return Theme(
      data: Theme.of(context).copyWith(
        radioTheme: fieldTheme.radioTheme,
      ),
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
                child: GroupInputDecorator(
                  decoration:
                      _buildDecoration(context, fieldTheme, state, isEnabled),
                  child:
                      _buildRadioButtons(context, state, fieldTheme, isEnabled),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildRadioButtons(
    BuildContext context,
    SelectFieldBlocState<Value, dynamic> state,
    RadioFieldTheme fieldTheme,
    bool isFieldEnabled,
  ) {
    return DefaultTextStyle(
      style: Style.resolveTextStyle(
        isEnabled: isEnabled,
        style: fieldTheme.textStyle!,
        color: fieldTheme.textColor!,
      ),
      child: GroupView(
        style: groupStyle,
        padding: Style.getGroupFieldBlocContentPadding(
          isVisible: true,
          decoration: decoration,
        ),
        count: state.items.length,
        builder: (context, index) {
          final item = state.items[index];
          final fieldItem = itemBuilder(context, item);
          final isEnabled = isFieldEnabled && fieldItem.isEnabled;

          final onChanged = fieldBlocBuilderOnChange<Value?>(
            isEnabled: isEnabled,
            nextFocusNode: nextFocusNode,
            onChanged: (value) {
              selectFieldBloc.changeValue(value);
              fieldItem.onTap?.call();
            },
          );

          return ItemGroupTile(
            customBorder: Style.getInputBorder(
              decoration: decoration,
              decorationTheme: fieldTheme.decorationTheme!,
            ),
            onTap: fieldTheme.canTapItemTile && onChanged != null
                ? () => onChanged(
                    fieldTheme.canDeselect && state.value == item ? null : item)
                : null,
            leading: Radio<Value>(
              value: item,
              fillColor: fieldTheme.radioTheme?.fillColor,
              overlayColor: fieldTheme.radioTheme?.overlayColor,
              splashRadius: fieldTheme.radioTheme?.splashRadius,
              groupValue: state.value,
              toggleable: fieldTheme.canDeselect,
              onChanged: onChanged,
            ),
            content: fieldItem,
          );
        },
      ),
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
      enabled: isEnable,
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
