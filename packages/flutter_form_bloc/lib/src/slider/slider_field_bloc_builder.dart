import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/fields/simple_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/theme/form_bloc_theme.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// [Slider]
class SliderFieldBlocBuilder extends StatelessWidget {
  final InputFieldBloc<double, dynamic> inputFieldBloc;

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

  // ========== SLIDER ==========

  /// [Slider.min]
  final double min;

  /// [Slider.max]
  final double max;

  /// [Slider.divisions]
  final int? divisions;

  /// [Slider.activeColor]
  final Color? activeColor;

  /// [Slider.inactiveColor]
  final Color? inactiveColor;

  /// [Slider.mouseCursor]
  final MouseCursor? mouseCursor;

  /// [Slider.label]
  final String Function(BuildContext context, double value)? labelBuilder;

  const SliderFieldBlocBuilder({
    Key? key,
    required this.inputFieldBloc,
    this.focusNode,
    this.nextFocusNode,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.activeColor,
    this.inactiveColor,
    this.mouseCursor,
    this.isEnabled = true,
    this.readOnly = false,
    this.animateWhenCanShow = true,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.padding,
    this.decoration = const InputDecoration(),
    this.errorBuilder,
    this.labelBuilder,
  }) : super(key: key);

  SliderFieldTheme themeOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = FormTheme.of(context);
    final fieldTheme = formTheme.sliderTheme;
    final sliderTheme = fieldTheme.sliderTheme ?? theme.sliderTheme;
    return SliderFieldTheme(sliderTheme: sliderTheme);
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeOf(context);

    return Theme(
      data: Theme.of(context).copyWith(
        sliderTheme: fieldTheme.sliderTheme,
      ),
      child: SimpleFieldBlocBuilder(
        singleFieldBloc: inputFieldBloc,
        animateWhenCanShow: animateWhenCanShow,
        builder: (context, _) {
          return BlocBuilder<InputFieldBloc<double, dynamic>,
              InputFieldBlocState<double, dynamic>>(
            bloc: inputFieldBloc,
            builder: (context, state) {
              final isEnabled = fieldBlocIsEnabled(
                isEnabled: this.isEnabled,
                enableOnlyWhenFormBlocCanSubmit:
                    enableOnlyWhenFormBlocCanSubmit,
                fieldBlocState: state,
              );
              final value = state.value;

              return DefaultFieldBlocBuilderPadding(
                padding: padding,
                child: InputDecorator(
                  decoration: _buildDecoration(context, state, isEnabled),
                  isEmpty: false,
                  child: Slider(
                    value: value,
                    min: min,
                    max: max,
                    focusNode: focusNode,
                    divisions: divisions,
                    onChanged: fieldBlocBuilderOnChange<double>(
                      isEnabled: isEnabled,
                      readOnly: readOnly,
                      nextFocusNode: nextFocusNode,
                      onChanged: inputFieldBloc.changeValue,
                    ),
                    label: labelBuilder?.call(context, value),
                    activeColor: activeColor,
                    inactiveColor: inactiveColor,
                    mouseCursor: mouseCursor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  InputDecoration _buildDecoration(
    BuildContext context,
    FieldBlocState state,
    bool isEnabled,
  ) {
    return decoration.copyWith(
      enabled: isEnabled,
      contentPadding: decoration.contentPadding ??
          const EdgeInsets.symmetric(vertical: 8.0),
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: inputFieldBloc,
      ),
    );
  }
}
