import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/chip/chip_field_item_builder.dart';
import 'package:flutter_form_bloc/src/fields/simple_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// [FilterChip]
class ChoiceChipFieldBlocBuilder<T> extends StatelessWidget {
  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<T, dynamic> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.readOnly}
  final bool readOnly;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// if `true` the radio button selected can
  /// be deselect by tapping.
  final bool canDeselect;

  // ========== WRAP ==========

  /// [Wrap.direction]
  final Axis direction;

  /// [Wrap.alignment]
  final WrapAlignment alignment;

  /// [Wrap.spacing]
  final double? spacing;

  /// [Wrap.runAlignment]
  final WrapAlignment runAlignment;

  /// [Wrap.runSpacing]
  final double? runSpacing;

  /// [Wrap.crossAxisAlignment]
  final WrapCrossAlignment crossAxisAlignment;

  /// [Wrap.textDirection]
  final TextDirection? textDirection;

  /// [Wrap.verticalDirection]
  final VerticalDirection verticalDirection;

  // ========== Chip ==========

  /// [FilterChip.labelStyle]
  final TextStyle? labelStyle;

  /// [FilterChip.labelPadding]
  final EdgeInsetsGeometry? labelPadding;

  /// [FilterChip.pressElevation]1
  final double? pressElevation;

  /// [FilterChip.disabledColor]
  final Color? disabledColor;

  /// [FilterChip.selectedColor]
  final Color? selectedColor;

  /// [FilterChip.avatar]
  final BorderSide? side;

  /// [FilterChip.shape]
  final OutlinedBorder? shape;

  /// [FilterChip.clipBehavior]
  final Clip clipBehavior;

  /// [FilterChip.autofocus]
  final bool autofocus;

  /// [FilterChip.backgroundColor]
  final Color? backgroundColor;

  /// [FilterChip.backgroundColor]
  final EdgeInsetsGeometry? chipPadding;

  /// [FilterChip.visualDensity]
  final VisualDensity? visualDensity;

  /// [FilterChip.materialTapTargetSize]
  final MaterialTapTargetSize? materialTapTargetSize;

  /// [FilterChip.elevation]
  final double? elevation;

  /// [FilterChip.shadowColor]
  final Color? shadowColor;

  /// [FilterChip.selectedShadowColor]
  final Color? selectedShadowColor;

  /// [FilterChip.showCheckmark]
  final bool? showCheckmark;

  /// [FilterChip.checkmarkColor]
  final Color? checkmarkColor;

  /// [FilterChip.avatarBorder]
  final ShapeBorder avatarBorder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.itemBuilder}
  final ChipFieldItemBuilder<T> itemBuilder;

  const ChoiceChipFieldBlocBuilder({
    Key? key,
    required this.selectFieldBloc,
    this.focusNode,
    this.nextFocusNode,
    this.autofocus = false,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.readOnly = false,
    this.animateWhenCanShow = true,
    this.padding,
    this.decoration = const InputDecoration(),
    this.errorBuilder,
    this.canDeselect = true,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.labelStyle,
    this.labelPadding,
    this.pressElevation,
    this.disabledColor,
    this.selectedColor,
    this.side,
    this.shape,
    this.backgroundColor,
    this.chipPadding,
    this.visualDensity,
    this.materialTapTargetSize,
    this.elevation,
    this.shadowColor,
    this.selectedShadowColor,
    this.showCheckmark,
    this.checkmarkColor,
    this.avatarBorder = const CircleBorder(),
    required this.itemBuilder,
  }) : super(key: key);

  ChoiceChipFieldTheme themeOf(BuildContext context) {
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.choiceChipTheme;
    final wrapTheme = fieldTheme.wrapTheme;

    return ChoiceChipFieldTheme(
      chipTheme: fieldTheme.chipTheme,
      wrapTheme: WrapChipFieldTheme(
        spacing: wrapTheme.spacing ?? 8.0,
        runSpacing: wrapTheme.runSpacing ?? 8.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeOf(context);

    final current = SimpleFieldBlocBuilder(
      singleFieldBloc: selectFieldBloc,
      animateWhenCanShow: animateWhenCanShow,
      builder: (context, canShow) {
        return BlocBuilder<SelectFieldBloc<T, dynamic>,
            SelectFieldBlocState<T, dynamic>>(
          bloc: selectFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: this.isEnabled,
              enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            final value = state.value;
            final items = state.items;

            return DefaultFieldBlocBuilderPadding(
              padding: padding,
              child: InputDecorator(
                decoration: _buildDecoration(context, state, isEnabled),
                isEmpty: false,
                child: Wrap(
                  direction: direction,
                  alignment: alignment,
                  spacing: fieldTheme.wrapTheme.spacing!,
                  runAlignment: runAlignment,
                  runSpacing: fieldTheme.wrapTheme.runSpacing!,
                  crossAxisAlignment: crossAxisAlignment,
                  textDirection: textDirection,
                  verticalDirection: verticalDirection,
                  children: items.map((item) {
                    final fieldItem = itemBuilder(context, item);

                    return ChoiceChip(
                      focusNode: focusNode,
                      autofocus: autofocus,
                      selected: value == item,
                      onSelected: fieldBlocBuilderOnChange<bool>(
                        isEnabled: isEnabled && fieldItem.isEnabled,
                        readOnly: readOnly,
                        nextFocusNode: nextFocusNode,
                        onChanged: (isSelected) {
                          selectFieldBloc.changeValue(isSelected ? item : null);
                          fieldItem.onTap?.call();
                        },
                      ),
                      labelStyle: labelStyle,
                      labelPadding: labelPadding,
                      pressElevation: pressElevation,
                      disabledColor: disabledColor,
                      selectedColor: selectedColor,
                      side: side,
                      shape: shape,
                      clipBehavior: clipBehavior,
                      backgroundColor: backgroundColor,
                      padding: chipPadding,
                      visualDensity: visualDensity,
                      materialTapTargetSize: materialTapTargetSize,
                      elevation: elevation,
                      shadowColor: shadowColor,
                      selectedShadowColor: selectedShadowColor,
                      avatarBorder: avatarBorder,
                      tooltip: fieldItem.tooltip,
                      avatar: fieldItem.avatar,
                      label: fieldItem.label,
                    );
                  }).toList(),
                ),
              ),
            );
          },
        );
      },
    );

    if (fieldTheme.chipTheme == null) return current;

    return ChipTheme(
      data: fieldTheme.chipTheme!,
      child: current,
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    FieldBlocState state,
    bool isEnabled,
  ) {
    return decoration.copyWith(
      enabled: isEnabled,
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: selectFieldBloc,
      ),
    );
  }
}
