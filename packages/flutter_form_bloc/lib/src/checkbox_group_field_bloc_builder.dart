import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/src/can_show_field_bloc_builder.dart';
import 'package:flutter_form_bloc/src/utils/utils.dart';
import 'package:form_bloc/form_bloc.dart';

/// A material design checkboxes.
class CheckboxGroupFieldBlocBuilder<Value> extends StatelessWidget {
  const CheckboxGroupFieldBlocBuilder({
    Key key,
    @required this.multiSelectFieldBloc,
    @required this.itemBuilder,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.decoration = const InputDecoration(),
    this.checkColor,
    this.activeColor,
    this.nextFocusNode,
    this.animateWhenCanShow = true,
  })  : assert(enableOnlyWhenFormBlocCanSubmit != null),
        assert(isEnabled != null),
        assert(decoration != null),
        super(key: key);

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final MultiSelectFieldBloc<Value, Object> multiSelectFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.stringItemBuilder}
  final FieldBlocStringItemBuilder<Value> itemBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry padding;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.decoration}
  final InputDecoration decoration;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxColor}
  final Color checkColor;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxActiveColor}
  final Color activeColor;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  @override
  Widget build(BuildContext context) {
    if (multiSelectFieldBloc == null) {
      return SizedBox();
    }

    return CanShowFieldBlocBuilder(
      fieldBloc: multiSelectFieldBloc,
      animate: animateWhenCanShow,
      builder: (_, __) {
        return BlocBuilder<MultiSelectFieldBloc<Value, dynamic>,
            MultiSelectFieldBlocState<Value, dynamic>>(
          cubit: multiSelectFieldBloc,
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
                      child: _buildCheckboxes(state, isEnabled),
                    ),
                  ),
                  InputDecorator(
                    decoration: Style.inputDecorationWithoutBorder.copyWith(
                      contentPadding: Style.getGroupFieldBlocContentPadding(
                        isVisible: true,
                        decoration: decoration,
                      ),
                    ),
                    child: _buildCheckboxes(state, isEnabled),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCheckboxes(
      MultiSelectFieldBlocState<Value, dynamic> state, bool isEnabled) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 4),
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      itemCount: state.items.length,
      itemBuilder: (context, index) {
        final item = state.items[index];
        return InputDecorator(
          decoration: Style.inputDecorationWithoutBorder.copyWith(
            prefixIcon: Checkbox(
              checkColor: Style.getIconColor(
                customColor: checkColor,
                defaultColor: Theme.of(context).toggleableActiveColor,
              ),
              activeColor: activeColor,
              value: state.value.contains(state.items[index]),
              onChanged: fieldBlocBuilderOnChange<bool>(
                isEnabled: isEnabled,
                nextFocusNode: nextFocusNode,
                onChanged: (_) {
                  if (state.value.contains(item)) {
                    multiSelectFieldBloc.deselect(item);
                  } else {
                    multiSelectFieldBloc.select(item);
                  }
                },
              ),
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

  InputDecoration _buildDecoration(BuildContext context,
      MultiSelectFieldBlocState<Value, dynamic> state, bool isEnabled) {
    InputDecoration decoration = this.decoration;

    return decoration.copyWith(
      suffix: this.decoration.suffix != null ? SizedBox.shrink() : null,
      prefixIcon: this.decoration.prefixIcon != null ? SizedBox.shrink() : null,
      prefix: this.decoration.prefix != null ? SizedBox.shrink() : null,
      suffixIcon: this.decoration.suffixIcon != null ? SizedBox.shrink() : null,
      enabled: isEnabled,
      contentPadding: Style.getGroupFieldBlocContentPadding(
        isVisible: false,
        decoration: decoration,
      ),
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: errorBuilder,
        fieldBlocState: state,
        fieldBloc: multiSelectFieldBloc,
      ),
    );
  }
}
