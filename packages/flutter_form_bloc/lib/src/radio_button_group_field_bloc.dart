import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils.dart';
import 'package:form_bloc/form_bloc.dart';

class RadioButtonGroupFieldBlocBuilder<Value> extends StatelessWidget {
  const RadioButtonGroupFieldBlocBuilder({
    @required this.selectFieldBloc,
    @required this.itemBuilder,
    Key key,
    this.formBloc,
    this.requiredError,
    this.padding = const EdgeInsets.all(8),
    this.decoration = const InputDecoration(),
    this.canDeselect = true,
    this.nextFocusNode,
  })  : assert(selectFieldBloc != null),
        assert(canDeselect != null),
        assert(padding != null),
        assert(decoration != null),
        super(key: key);

  final SelectFieldBloc<Value> selectFieldBloc;

  /// This widget will be enable only when the [FormBloc] state is
  /// [FormBlocLoaded] or [FormBlocFailure]
  final FormBloc formBloc;

  final ItemBuilder<Value> itemBuilder;

  /// Error when [selectFieldBloc] is required
  /// and the value is false
  final String requiredError;

  final EdgeInsetsGeometry padding;

  final bool canDeselect;

  final InputDecoration decoration;

  /// When change the value this will call
  /// [nextFocusNode.requestFocus()]
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    if (formBloc != null) {
      return BlocBuilder<FormBloc, FormBlocState>(
        bloc: formBloc,
        builder: (context, formState) {
          return _buildChild(formState.canSubmit);
        },
      );
    } else {
      return _buildChild(true);
    }
  }

  Widget _buildChild(bool isEnable) {
    return BlocBuilder<SelectFieldBloc<Value>, SelectFieldBlocState<Value>>(
      bloc: selectFieldBloc,
      builder: (context, state) {
        return Padding(
          padding: padding,
          child: Stack(
            children: <Widget>[
              InputDecorator(
                decoration: _buildDecoration(state, isEnable),
                child: Opacity(
                  opacity: 0,
                  child: _buildRadioButtons(state, isEnable),
                ),
              ),
              InputDecorator(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                ),
                child: _buildRadioButtons(state, isEnable),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioButtons(SelectFieldBlocState<Value> state, bool isEnable) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        return InputDecorator(
          decoration: InputDecoration(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            prefixIcon: Stack(
              children: <Widget>[
                Radio<Value>(
                  value: state.items.elementAt(index),
                  groupValue: state.value,
                  onChanged: isEnable
                      ? (value) {
                          selectFieldBloc.updateValue(value);

                          if (nextFocusNode != null) {
                            nextFocusNode.requestFocus();
                          }
                        }
                      : null,
                ),
                if (canDeselect && state.items.elementAt(index) == state.value)
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.transparent,
                    ),
                    child: Radio<Value>(
                      value: null,
                      groupValue: state.value,
                      onChanged: isEnable
                          ? (value) {
                              selectFieldBloc.updateValue(value);

                              if (nextFocusNode != null) {
                                nextFocusNode.requestFocus();
                              }
                            }
                          : null,
                    ),
                  )
              ],
            ),
            contentPadding: EdgeInsets.fromLTRB(15, 14, 14, 12),
          ),
          child: DefaultTextStyle(
            style: isEnable
                ? Theme.of(context).textTheme.subhead
                : Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(color: Theme.of(context).disabledColor),
            child: Text(itemBuilder(context, state.items.elementAt(index))),
          ),
        );
      },
    );
  }

  InputDecoration _buildDecoration(
      SelectFieldBlocState<Value> state, bool isEnable) {
    InputDecoration decoration = this.decoration;

    if (!state.isValid && !state.isInitial) {
      decoration = decoration.copyWith(
          errorText: requiredError ?? 'Please select an option.');
    }

    if (decoration.contentPadding == null) {
      decoration = decoration.copyWith(
        contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      );
    }

    decoration = decoration.copyWith(
      suffix: null,
      prefixIcon: null,
      prefix: null,
      suffixIcon: null,
      enabled: isEnable,
    );

    return decoration;
  }
}
