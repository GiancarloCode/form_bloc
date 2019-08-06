import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_bloc/form_bloc.dart';

typedef ItemBuilder<Value> = Widget Function(BuildContext context, Value value);

typedef DropDownFieldBlocErrorBuilder = String Function(BuildContext context);

class DropDownFieldBlocBuilder<Value> extends StatefulWidget {
  static String _defaultErrorBuilder(BuildContext context) =>
      'Please select an option.';

  DropDownFieldBlocBuilder({
    Key key,
    @required this.iterableFieldBloc,
    @required this.itemBuilder,
    @required this.formBloc,
    this.decoration = const InputDecoration(),
    this.enabled = true,
    this.errorBuilder = _defaultErrorBuilder,
    this.hintText,
  }) : super(key: key);

  final IterableFieldBloc<Value> iterableFieldBloc;

  final ItemBuilder<Value> itemBuilder;

  /// return he error when [iterableFieldBloc] is required
  /// and try to submit the form when the value is null
  final DropDownFieldBlocErrorBuilder errorBuilder;

  final FormBloc formBloc;

  final bool enabled;

  final String hintText;

  /// The decoration to show around the text field.
  ///
  /// By default, draws a horizontal line under the text field but can be
  /// configured to show an icon, label, hint text, and error text.
  final InputDecoration decoration;

  _DropDownFieldBlocBuilderState<Value> createState() =>
      _DropDownFieldBlocBuilderState();
}

class _DropDownFieldBlocBuilderState<Value>
    extends State<DropDownFieldBlocBuilder<Value>> {
  Value value;

  @override
  void initState() {
    super.initState();
    value = widget.iterableFieldBloc.currentState.value;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormBloc, FormBlocState>(
      bloc: widget.formBloc,
      condition: (previousState, currentState) =>
          previousState.runtimeType != currentState.runtimeType,
      builder: (context, formState) {
        return BlocBuilder<IterableFieldBloc<Value>,
            IterableFieldBlocState<Value>>(
          bloc: widget.iterableFieldBloc,
          builder: (context, fieldState) {
            return InkWell(
              onTap: () {},
              child: DropdownButtonHideUnderline(
                child: InputDecorator(
                  decoration: buildDecoration(fieldState),
                  isEmpty: false,
                  child: DropdownButton<Value>(
                    isExpanded: true,
                    hint:
                        widget.hintText != null ? Text(widget.hintText) : null,
                    value: fieldState.value,
                    disabledHint: fieldState.value != null
                        ? widget.itemBuilder(context, fieldState.value)
                        : widget.hintText != null
                            ? Text(widget.hintText)
                            : null,
                    onChanged: isEnable(formState)
                        ? widget.iterableFieldBloc.updateValue
                        : null,
                    items: fieldState.items.isEmpty
                        ? null
                        : fieldState.items.map<DropdownMenuItem<Value>>(
                            (Value value) {
                              return DropdownMenuItem<Value>(
                                value: value,
                                child: widget.itemBuilder(context, value),
                              );
                            },
                          ).toList(),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration buildDecoration(IterableFieldBlocState<Value> state) {
    InputDecoration decoration = widget.decoration;

    if (decoration.errorText == null) {
      if (widget.errorBuilder != null && !state.isValid && !state.isInitial) {
        decoration =
            decoration.copyWith(errorText: widget.errorBuilder(context));
      }
    }

    if (decoration.errorMaxLines == null) {
      decoration = decoration.copyWith(errorMaxLines: 10);
    }

    decoration =
        decoration.copyWith(contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 0));

    return decoration;
  }

  bool isEnable(FormBlocState state) =>
      (widget.enabled ?? true) && state is FormBlocNotSubmitted;
}
