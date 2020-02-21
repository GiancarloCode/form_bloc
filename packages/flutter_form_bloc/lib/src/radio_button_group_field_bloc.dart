import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design radio buttons.
class RadioButtonGroupFieldBlocBuilder<Value> extends StatelessWidget {
  const RadioButtonGroupFieldBlocBuilder({
    Key key,
    @required this.selectFieldBloc,
    @required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.canDeselect = true,
    this.nextFocusNode,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(canDeselect != null),
        assert(decoration != null),
        super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final SelectFieldBloc<Value> selectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  final FieldBlocStringItemBuilder<Value> itemBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// if `true` the radio button selected can
  ///  be deselect by tapping.
  final bool canDeselect;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    if (selectFieldBloc == null) {
      return Container();
    }

    return BlocBuilder<SelectFieldBloc<Value>, SelectFieldBlocState<Value>>(
      bloc: selectFieldBloc,
      builder: (context, state) {
        final isEnabled = fieldBlocIsEnabled(
          isEnabled: this.isEnabled,
          enableOnlyWhenFormBlocCanSubmit: enableOnlyWhenFormBlocCanSubmit,
          fieldBlocState: state,
        );

        return DefaultFieldBlocBuilderPadding(
          padding: padding,
          child: Stack(
            children: <Widget>[
              InputDecorator(
                decoration: _buildDecoration(context, state, isEnabled),
                child: Opacity(
                  opacity: 0.0,
                  child: _buildRadioButtons(state, isEnabled),
                ),
              ),
              InputDecorator(
                decoration: Style.inputDecorationWithoutBorder.copyWith(
                  contentPadding: Style.getGroupFieldBlocContentPadding(
                    isVisible: true,
                    decoration: decoration,
                  ),
                ),
                child: _buildRadioButtons(state, isEnabled),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioButtons(SelectFieldBlocState<Value> state, bool isEnable) {
    final onChanged = fieldBlocBuilderOnChange<Value>(
      isEnabled: isEnabled,
      nextFocusNode: nextFocusNode,
      onChanged: selectFieldBloc.updateValue,
    );
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        return InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            prefixIcon: Stack(
              children: <Widget>[
                Radio<Value>(
                  value: state.items.elementAt(index),
                  groupValue: state.value,
                  onChanged: onChanged,
                ),
                if (canDeselect && state.items.elementAt(index) == state.value)
                  Theme(
                    data: Theme.of(context).copyWith(
                      unselectedWidgetColor: Colors.transparent,
                    ),
                    child: Radio<Value>(
                      value: null,
                      groupValue: state.value,
                      onChanged: onChanged,
                    ),
                  )
              ],
            ),
          ),
          child: DefaultFieldBlocBuilderTextStyle(
            isEnabled: isEnabled,
            child: Text(itemBuilder(context, state.items.elementAt(index))),
          ),
        );
      },
    );
  }

  InputDecoration _buildDecoration(
      BuildContext context, SelectFieldBlocState<Value> state, bool isEnable) {
    InputDecoration decoration = this.decoration;

    return decoration.copyWith(
      suffix: SizedBox.shrink(),
      prefixIcon: SizedBox.shrink(),
      prefix: SizedBox.shrink(),
      suffixIcon: SizedBox.shrink(),
      enabled: isEnable,
      contentPadding: Style.getGroupFieldBlocContentPadding(
        isVisible: false,
        decoration: decoration,
      ),
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
      ),
    );
  }
}
