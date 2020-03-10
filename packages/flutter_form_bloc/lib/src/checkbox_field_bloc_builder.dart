import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/src/field_bloc_builder_control_affinity.dart';

/// A material design checkbox.
class CheckboxFieldBlocBuilder extends StatelessWidget {
  const CheckboxFieldBlocBuilder({
    Key key,
    @required this.booleanFieldBloc,
    @required this.body,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.checkColor,
    this.activeColor,
    this.padding,
    this.nextFocusNode,
    this.controlAffinity = FieldBlocBuilderControlAffinity.leading,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(controlAffinity != null),
        assert(isEnabled != null),
        assert(body != null),
        super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc booleanFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilderControlAffinity}
  final FieldBlocBuilderControlAffinity controlAffinity;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxBody}
  final Widget body;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxColor}
  final Color checkColor;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxActiveColor}
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    if (booleanFieldBloc == null) {
      return Container();
    }
    return BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
      bloc: booleanFieldBloc,
      builder: (context, state) {
        final isEnabled = fieldBlocIsEnabled(
          isEnabled: this.isEnabled,
          enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
          fieldBlocState: state,
        );

        return DefaultFieldBlocBuilderPadding(
          padding: padding,
          child: InputDecorator(
            decoration: Style.inputDecorationWithoutBorder.copyWith(
              contentPadding: EdgeInsets.all(0),
              prefixIcon:
                  controlAffinity == FieldBlocBuilderControlAffinity.leading
                      ? _buildCheckbox(context: context, state: state)
                      : null,
              suffixIcon:
                  controlAffinity == FieldBlocBuilderControlAffinity.trailing
                      ? _buildCheckbox(context: context, state: state)
                      : null,
              errorText: Style.getErrorText(
                context: context,
                errorBuilder: errorBuilder,
                fieldBlocState: state,
              ),
            ),
            child: DefaultFieldBlocBuilderTextStyle(
              isEnabled: isEnabled,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 48),
                child: body,
              ),
            ),
          ),
        );
      },
    );
  }

  Checkbox _buildCheckbox(
      {@required BuildContext context, @required BooleanFieldBlocState state}) {
    return Checkbox(
      checkColor: Style.getIconColor(
        customColor: checkColor,
        defaultColor: Theme.of(context).toggleableActiveColor,
      ),
      activeColor: activeColor,
      value: state.value,
      onChanged: fieldBlocBuilderOnChange<bool>(
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
        onChanged: booleanFieldBloc.updateValue,
      ),
    );
  }
}
