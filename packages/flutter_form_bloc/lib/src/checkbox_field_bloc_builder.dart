import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:form_bloc/form_bloc.dart';

class CheckboxFieldBlocBuilder extends StatelessWidget {
  const CheckboxFieldBlocBuilder({
    @required this.booleanFieldBloc,
    @required this.body,
    Key key,
    this.formBloc,
    this.requiredError,
    this.checkColor,
    this.activeColor,
    this.padding,
    this.nextFocusNode,
  })  : assert(booleanFieldBloc != null),
        assert(body != null),
        super(key: key);

  final BooleanFieldBloc booleanFieldBloc;

  /// This widget will be enable only when the [FormBloc] state is
  /// [FormBlocLoaded] or [FormBlocFailure]
  final FormBloc formBloc;

  /// Error when [booleanFieldBloc] is required
  /// and the value is false
  final String requiredError;

  final Widget body;

  /// The color to use for the check icon when this checkbox is checked
  final Color checkColor;

  /// The color to use when this checkbox is checked.
  ///
  /// Defaults to [ThemeData.toggleableActiveColor].
  final Color activeColor;

  final EdgeInsetsGeometry padding;

  /// When change the value of checkbox, this will call
  /// [nextFocusNode.requestFocus()]
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    if (formBloc != null) {
      return BlocBuilder<FormBloc, FormBlocState>(
        bloc: formBloc,
        builder: (context, formState) {
          return _buildChild(
              formState is FormBlocLoaded || formState is FormBlocFailure);
        },
      );
    } else {
      return _buildChild(true);
    }
  }

  Widget _buildChild(bool isEnable) {
    return BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
      bloc: booleanFieldBloc,
      builder: (context, state) {
        return Padding(
          padding: padding ?? EdgeInsets.all(8),
          child: InputDecorator(
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              prefixIcon: Checkbox(
                checkColor: checkColor ??
                    (ThemeData.estimateBrightnessForColor(
                                Theme.of(context).toggleableActiveColor) ==
                            Brightness.dark
                        ? Colors.white
                        : Colors.grey[800]),
                activeColor: activeColor,
                value: state.value,
                onChanged: isEnable
                    ? (value) {
                        booleanFieldBloc.updateValue(value);
                        if (nextFocusNode != null) {
                          nextFocusNode.requestFocus();
                        }
                      }
                    : null,
              ),
              errorText: !state.isInitial && !state.isValid
                  ? requiredError ?? 'This field is required.'
                  : null,
              contentPadding: EdgeInsets.fromLTRB(15, 14, 14, 12),
            ),
            child: DefaultTextStyle(
              style: isEnable
                  ? Theme.of(context).textTheme.subhead
                  : Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: Theme.of(context).disabledColor),
              child: body,
            ),
          ),
        );
      },
    );
  }
}
