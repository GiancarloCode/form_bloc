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
    this.numberOfItemPerRow = 1,
    this.itemHight = 60,
  }) : super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final MultiSelectFieldBloc<Value, dynamic> multiSelectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.itemBuilder}
  final FieldItemBuilder<Value> itemBuilder;

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

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textStyle}
  final TextStyle? textStyle;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.textColor}
  final MaterialStateProperty<Color?>? textColor;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.numberOfItemPerRow}
  /// The number of checkbox button per row
  /// default is 1
  final int numberOfItemPerRow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.itemHight}
  /// checkbox item max hight
  /// default value is 60
  final double itemHight;

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
                child: GroupInputDecorator(
                  decoration:
                      _buildDecoration(context, state, isEnabled, fieldTheme),
                  child: _buildCheckboxes(state, isEnabled, fieldTheme),
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
    bool isFieldEnabled,
    CheckboxFieldTheme fieldTheme,
  ) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: numberOfItemPerRow,
        mainAxisExtent: itemHight,
      ),
      physics: const ClampingScrollPhysics(),
      itemCount: state.items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = state.items[index];
        final fieldItem = itemBuilder(context, state.items[index]);
        final isEnabled = isFieldEnabled && fieldItem.isEnabled;

        return InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            prefixIcon: Checkbox(
              value: state.value.contains(state.items[index]),
              fillColor: fieldTheme.checkboxTheme?.checkColor,
              side: fieldTheme.checkboxTheme?.side,
              overlayColor: fieldTheme.checkboxTheme?.overlayColor,
              materialTapTargetSize:
                  fieldTheme.checkboxTheme?.materialTapTargetSize,
              shape: fieldTheme.checkboxTheme?.shape,
              splashRadius: fieldTheme.checkboxTheme?.splashRadius,
              visualDensity: fieldTheme.checkboxTheme?.visualDensity,
              onChanged: fieldBlocBuilderOnChange<bool?>(
                isEnabled: isEnabled,
                nextFocusNode: nextFocusNode,
                onChanged: (_) {
                  if (state.value.contains(item)) {
                    multiSelectFieldBloc.deselect(item);
                  } else {
                    multiSelectFieldBloc.select(item);
                  }
                  fieldItem.onTap?.call();
                },
              ),
            ),
          ),
          child: DefaultTextStyle(
            style: Style.resolveTextStyle(
              isEnabled: isEnabled,
              style: fieldTheme.textStyle!,
              color: fieldTheme.textColor!,
            ),
            child: fieldItem,
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
    var decoration = this.decoration;

    decoration = decoration.copyWith(
      enabled: isEnabled,
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
