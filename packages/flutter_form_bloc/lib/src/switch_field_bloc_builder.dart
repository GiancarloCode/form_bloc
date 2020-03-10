import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';
import 'package:flutter_form_bloc/src/field_bloc_builder_control_affinity.dart';

/// A material design switch
class SwitchFieldBlocBuilder extends StatelessWidget {
  const SwitchFieldBlocBuilder({
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
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.materialTapTargetSize,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.autofocus = false,
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

  /// The color to use on the track when this switch is on.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor] with the opacity set at 50%.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final Color activeTrackColor;

  /// The color to use on the thumb when this switch is off.
  ///
  /// Defaults to the colors described in the Material design specification.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final Color inactiveThumbColor;

  /// The color to use on the track when this switch is off.
  ///
  /// Defaults to the colors described in the Material design specification.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final Color inactiveTrackColor;

  /// An image to use on the thumb of this switch when the switch is on.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final ImageProvider activeThumbImage;

  /// An image to use on the thumb of this switch when the switch is off.
  ///
  /// Ignored if this switch is created with [Switch.adaptive].
  final ImageProvider inactiveThumbImage;

  /// Configures the minimum size of the tap target.
  ///
  /// Defaults to [ThemeData.materialTapTargetSize].
  ///
  /// See also:
  ///
  ///  * [MaterialTapTargetSize], for a description of how this affects tap targets.
  final MaterialTapTargetSize materialTapTargetSize;

  /// {@macro flutter.cupertino.switch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// The color for the button's [Material] when it has the input focus.
  final Color focusColor;

  /// The color for the button's [Material] when a pointer is hovering over it.
  final Color hoverColor;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

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
                      ? _buildSwitch(context: context, state: state)
                      : null,
              suffixIcon:
                  controlAffinity == FieldBlocBuilderControlAffinity.trailing
                      ? _buildSwitch(context: context, state: state)
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

  Switch _buildSwitch(
      {@required BuildContext context, @required BooleanFieldBlocState state}) {
    return Switch(
      value: state.value,
      onChanged: fieldBlocBuilderOnChange<bool>(
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
        onChanged: booleanFieldBloc.updateValue,
      ),
      activeColor: activeColor,
      activeThumbImage: activeThumbImage,
      activeTrackColor: activeTrackColor,
      autofocus: autofocus,
      dragStartBehavior: dragStartBehavior,
      focusColor: focusColor,
      focusNode: focusNode,
      hoverColor: hoverColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveThumbImage: inactiveThumbImage,
      inactiveTrackColor: inactiveThumbColor,
      materialTapTargetSize: materialTapTargetSize,
    );
  }
}
